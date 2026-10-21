# ===============================================================================
# Ignytion IO - CRUCIBLE CORE
# Copyright (c) 2026 Ignytion IO. All rights reserved.
# Author      : IGNYTION_TECH
# File        : hw/protocols/i2c/10_gds/validate_gds.py
# Created     : 2026-10-03
# Description : Protocol reference integration and teaching build.
# Upstream copyright and licence notices below remain applicable.
# ===============================================================================
"""Independently decode GDS records and compare placed standard cells to DEF.

Structural/export evidence only: not a foundry DRC or LVS substitute.
"""
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import struct
import os
import sys

def require(condition, message="Validation failed"):
    if not condition:
        raise ValueError(message)

root = Path(__file__).resolve().parents[1]
gds_path = root / "10_gds/i2c_core.gds"
data = gds_path.read_bytes()
cells = {}
current = None
element = None
units = None
ended = False

def real8(raw):
    if raw == b"\0" * 8:
        return 0.0
    sign = -1 if raw[0] & 128 else 1
    return sign * (int.from_bytes(raw[1:], "big") / 2**56) * 16 ** ((raw[0] & 127) - 64)

offset = 0
while offset < len(data):
    length, kind, dtype = struct.unpack_from(">HBB", data, offset)
    require(length >= 4 and length % 2 == 0 and offset + length <= len(data), "Invalid GDS record")
    payload = data[offset + 4:offset + length]
    if kind == 3:
        units = (real8(payload[:8]), real8(payload[8:]))
    elif kind == 6:
        current = payload.rstrip(b"\0").decode("ascii")
        require(current not in cells, "Duplicate GDS cell")
        cells[current] = {"refs": [], "shapes": Counter()}
    elif kind in (8, 9, 10, 11, 12, 45):
        element = {"kind": kind}
    elif kind == 13 and element is not None:
        element["layer"] = struct.unpack(">h", payload)[0]
    elif kind == 16 and element is not None:
        element["xy"] = tuple(struct.unpack(">" + "i" * (len(payload) // 4), payload))
    elif kind == 18 and element is not None:
        element["name"] = payload.rstrip(b"\0").decode("ascii")
    elif kind == 26 and element is not None:
        element["mirror"] = bool(struct.unpack(">H", payload)[0] & 0x8000)
    elif kind == 28 and element is not None:
        element["angle"] = round(real8(payload)) % 360
    elif kind == 17:
        require(current is not None and element is not None , "Validation failed")
        if element["kind"] == 10:
            cells[current]["refs"].append((element["name"], element["xy"][:2], element.get("mirror", False), element.get("angle", 0)))
        elif element["kind"] == 11:
            raise AssertionError("Array references require expanded comparison")
        elif element["kind"] in (8, 9, 45):
            cells[current]["shapes"][element["layer"]] += 1
        element = None
    elif kind == 4:
        ended = True
    offset += length
require(ended and units and cells, "Incomplete GDS library")
def_text = (root / "09_place_and_route/route.def").read_text()
top = re.search(r"DESIGN\s+(\S+)\s*;", def_text)[1]
require(top in cells, "Missing design top")
for cell in cells.values():
    for name, xy, mirror, angle in cell["refs"]:
        require(name in cells, f"Unresolved GDS reference {name}")
require(cells[top]["shapes"], "Missing routed top geometry")

def_text = (root / "09_place_and_route/route.def").read_text()
def_units = int(re.search(r"UNITS DISTANCE MICRONS (\d+)", def_text)[1])
section = re.search(r"COMPONENTS (\d+)\s*;(.*?)END COMPONENTS", def_text, re.S)
placed = re.findall(r"-\s+\S+\s+(sg13g2_\S+).*?\+\s+(?:PLACED|FIXED)\s*\(\s*(-?\d+)\s+(-?\d+)\s*\)\s+(\w+)", section[2], re.S)
require(len(placed) == int(section[1]), "DEF component parse mismatch")
gds_um = units[1] * 1e6
lef = (Path(os.environ["IHP_PDK_ROOT"]) / "libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef").read_text()
sizes = {name: (float(w), float(h)) for name, w, h in re.findall(r"MACRO\s+(\S+).*?SIZE\s+([\d.]+)\s+BY\s+([\d.]+)", lef, re.S)}
expected = Counter()
for name, x, y, orientation in placed:
    width, height = sizes[name]
    require(orientation in ("N", "S", "FN", "FS"), f"Unsupported DEF orientation {orientation}")
    dx = width if orientation in ("S", "FN") else 0
    dy = height if orientation in ("S", "FS") else 0
    mirror = orientation in ("FN", "FS")
    angle = 180 if orientation in ("S", "FN") else 0
    expected[(name, round((int(x) / def_units + dx) / gds_um), round((int(y) / def_units + dy) / gds_um), mirror, angle)] += 1
actual = Counter((name, xy[0], xy[1], mirror, angle) for name, xy, mirror, angle in cells[top]["refs"] if name.startswith("sg13g2_"))
if "--inject_failure" in sys.argv:
    expected[("missing_negative_control_cell", 0, 0, False, 0)] += 1
require(expected == actual, f"DEF/GDS placement mismatch: missing={sum((expected - actual).values())}, extra={sum((actual - expected).values())}")
for name, _, _, _, _ in expected:
    require(cells[name]["shapes"], f"Empty standard-cell geometry {name}")
via_section = re.search(r"VIAS (\d+)\s*;(.*?)END VIAS", def_text, re.S)
via_names = set(re.findall(r"-\s+(\S+)", via_section[2])) if via_section else set()
tech_lef = (Path(os.environ["IHP_PDK_ROOT"]) / "libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef").read_text()
via_names.update(re.findall(r"^\s*VIA\s+(\S+)", tech_lef, re.M | re.I))
non_std = Counter(name for name, xy, mirror, angle in cells[top]["refs"] if not name.startswith("sg13g2_"))
require(set(non_std) <= via_names, f"Unexpected top references: {set(non_std) - via_names}")
summary = {"top": top, "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest(), "cells": len(cells), "placed_instances": sum(actual.values()), "top_shape_layers": dict(cells[top]["shapes"]), "raw_sha256_scope": "Run-specific byte fingerprint; GDS timestamps may change", "non_stdcell_references": dict(non_std), "status": "PASS structural export; DRC/LVS/signoff not performed"}
(root / "10_gds/validation.json").write_text(json.dumps(summary, indent=2) + "\n")
print(json.dumps(summary, indent=2))
print("PASS independent GDS decode and DEF placement comparison")
