"""Run IHP main-deck DRC and strict, power-aware Netgen LVS for UART."""

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET

sys.dont_write_bytecode = True
from reference import cell_models, prepare_reference, require_defined_layout_cells

STAGE = Path(__file__).resolve().parent
ROOT = STAGE.parent
PDK_REVISION = "22f43352dd8219f9007eb659e422e0d5fe28c5fb"
LIMITATIONS = ["density", "antenna", "ERC", "IR/EM", "DFT", "padframe",
               "foundry release signoff"]


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def drc_report(path, top):
    database = ET.parse(path).getroot()
    if (database.tag != "report-database" or database.findtext("top-cell") != top
            or not database.findall("./categories/category")):
        raise ValueError(f"Invalid or incomplete DRC database: {path}")
    return len(database.findall("./items/item"))


def require_clean_drc(markers):
    if markers:
        raise ValueError(f"PDK main-deck DRC failed: {markers} marker(s)")


def run(args):
    results = args.results_dir.resolve()
    results.mkdir(parents=True, exist_ok=True)
    receipt = results / "physical_verification.json"
    status = {"status": "FAIL", "timestamp_utc": datetime.now(timezone.utc).isoformat(),
              "scope": "IHP main-deck DRC and strict power-aware LVS",
              "not_covered": LIMITATIONS}
    receipt.write_text(json.dumps(status, indent=2) + "\n")
    environment = os.environ.copy()
    environment["UART_CHECK_DATABASE"] = str(args.database.resolve())
    environment["UART_CHECK_RESULTS"] = str(results)

    def tool(arguments, log_name, check=True):
        command = ["igny", "run", "--env", args.env, *map(str, arguments)]
        log = results / log_name
        with log.open("w") as output:
            process = subprocess.run(command, cwd=ROOT, env=environment,
                                     stdout=output, stderr=subprocess.STDOUT)
        if check and process.returncode:
            raise RuntimeError(f"Tool failed ({process.returncode}); see {log}")
        return process.returncode, log.read_text(errors="replace")

    def klayout(arguments, log_name):
        return tool(["script", STAGE / "run_klayout.sh", "--", *arguments], log_name)

    def run_drc(layout, top, prefix):
        report = results / f"{prefix}.lyrdb"
        report.unlink(missing_ok=True)
        klayout(["-b", "-r", drc_deck, "-rd", f"input={layout}",
                 "-rd", f"topcell={top}", "-rd", f"report={report}",
                 "-rd", f"log={results / (prefix + '.rules.log')}",
                 "-rd", "run_mode=deep", "-rd", "threads=4"], prefix + ".log")
        return drc_report(report, top)

    def run_lvs(reference, prefix, check=True):
        comparison = results / f"{prefix}.log"
        comparison.unlink(missing_ok=True)
        script = results / f"{prefix}.tcl"
        # Tcl lists keep paths (including spaces) separate from commands.
        for path in (results, reference, setup):
            if any(character in str(path) for character in "{}\n\r"):
                raise ValueError(f"Unsupported Tcl path: {path}")
        script.write_text(
            f"lvs {{{{{results / 'layout.spice'}}} uart_core}} "
            f"{{{{{reference}}} uart_core}} {{{setup}}} {{{comparison}}}\n"
            'set matched [verify unique]\nputs "NETGEN_UNIQUE=$matched"\n'
            'if {$matched != 1} {exit 3}\nquit\n'
        )
        code, console = tool(["netgen", "source", script], prefix + ".console.log", check=False)
        match = re.search(r"^NETGEN_UNIQUE=(-?\d+)$", console, re.M)
        unique = int(match[1]) if match else None
        report = comparison.read_text(errors="replace") if comparison.exists() else ""
        valid = (code == 0 and unique == 1
                 and "Final result: Circuits match uniquely." in report
                 and "Cell pin lists are equivalent." in report
                 and not any(message in console for message in (
                     "Badly formed line", "Cannot find cell", "No such file")))
        if check and not valid:
            raise ValueError(f"Strict LVS failed; see {comparison} and {prefix}.console.log")
        return {"passed": valid, "returncode": code, "unique": unique}

    try:
        if os.name == "nt" or not shutil.which("igny"):
            raise RuntimeError("Run physical verification from an initialized WSL/Linux Igny shell")
        pdk = args.pdk.resolve()
        drc_deck = pdk / "libs.tech/klayout/tech/drc/ihp-sg13g2.drc"
        lvs_deck = pdk / "libs.tech/klayout/tech/lvs/sg13g2.lvs"
        setup = pdk / "libs.tech/netgen/ihp-sg13g2_setup.tcl"
        library = pdk / "libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl"
        inputs = {"gds": args.gds.resolve(), "database": args.database.resolve(),
                  "cdl": library, "netgen_setup": setup}
        for path in [*inputs.values(), drc_deck, lvs_deck]:
            if not path.is_file() or not path.stat().st_size:
                raise FileNotFoundError(f"Missing physical-verification input: {path}")
        fingerprints = {name: {"path": str(path), "sha256": sha256(path)}
                        for name, path in inputs.items()}
        deck_files = [drc_deck, lvs_deck]
        for directory in (drc_deck.parent / "rule_decks", lvs_deck.parent / "rule_decks"):
            deck_files.extend(sorted(path for path in directory.rglob("*") if path.is_file()))
        decks = {str(path.relative_to(pdk)): sha256(path) for path in deck_files}
        _, version_log = klayout(["-v"], "klayout_version.log")
        version = re.search(r"KLayout\s+(\d+\.\d+\.\d+)", version_log)
        if not version:
            raise RuntimeError("Could not identify the full KLayout application version")
        print(f"KLayout {version[1]}: executing the installed IHP main DRC deck", flush=True)
        markers = run_drc(inputs["gds"], "uart_core", "klayout_drc")
        require_clean_drc(markers)
        print("PASS IHP PDK main-deck DRC: 0 markers", flush=True)

        for name in ("reference.power.v", "reference.yosys.spice", "reference.spice"):
            (results / name).unlink(missing_ok=True)
        _, export_log = tool(["openroad", "-exit", STAGE / "export_reference.tcl"], "openroad_reference.log")
        if "PASS powered routed reference export" not in export_log:
            raise ValueError("The powered routed reference export did not complete")
        models = cell_models(library, results / "reference.blackboxes.v")
        tool(["yosys", "-c", STAGE / "reference.tcl"], "yosys_reference.log")
        reference_info = prepare_reference(results / "reference.yosys.spice", library,
                                           results / "reference.spice", models)
        layout_netlist = results / "layout.spice"
        layout_netlist.unlink(missing_ok=True)
        klayout(["-b", "-r", lvs_deck, "-rd", f"input={inputs['gds']}",
                 "-rd", "topcell=uart_core", "-rd", "run_mode=deep",
                 "-rd", "net_only=true", "-rd", f"target_netlist={layout_netlist}",
                 "-rd", f"report={results / 'layout.lvsdb'}",
                 "-rd", f"log={results / 'klayout_extract.rules.log'}"], "klayout_extract.log")
        extracted = layout_netlist.read_text()
        # Forward declarations in SPICE cause temporary Netgen placeholder
        # messages. Require actual definitions for every referenced cell.
        require_defined_layout_cells(extracted)
        if not all(model in extracted for model in ("sg13_lv_nmos", "sg13_lv_pmos")):
            raise ValueError("Layout extraction did not produce transistor-level cell models")
        lvs = run_lvs(results / "reference.spice", "netgen_lvs")
        print(f"PASS power-aware LVS: unique match, {reference_info['ports']} top ports including VDD/VSS", flush=True)

        if args.negative_controls:
            fixture = results / "negative_drc.rb"
            fixture.write_text(
                'layout = RBA::Layout.new\nlayout.dbu = 0.001\n'
                'cell = layout.create_cell("uart_core_drc_negative")\n'
                'cell.shapes(layout.layer(10, 0)).insert(RBA::Box.new(0, 0, 10, 10))\n'
                'layout.write($output)\n'
            )
            negative_gds = results / "negative_drc.gds"
            klayout(["-b", "-r", fixture, "-rd", f"output={negative_gds}"], "negative_fixture.log")
            bad_markers = run_drc(negative_gds, "uart_core_drc_negative", "negative_drc")
            try:
                require_clean_drc(bad_markers)
            except ValueError:
                pass
            else:
                raise ValueError("DRC negative control incorrectly passed")
            text = (results / "reference.spice").read_text()
            lines = text.splitlines()
            changed = False
            for index, line in enumerate(lines):
                if not line.startswith("X"):
                    continue
                tokens = line.split()
                if tokens[-1].startswith("sg13g2_fill_"):
                    continue
                pins = models[tokens[-1]]
                tokens[pins.index("VDD") + 1] = "VSS"
                lines[index] = " ".join(tokens)
                changed = True
                break
            if not changed:
                raise ValueError("No powered logic instance available for the LVS control")
            bad_reference = results / "negative_reference.spice"
            bad_reference.write_text("\n".join(lines) + "\n")
            negative_lvs = run_lvs(bad_reference, "negative_lvs", check=False)
            if (negative_lvs["passed"] or negative_lvs["returncode"] == 0
                    or negative_lvs["unique"] is None or negative_lvs["unique"] == 1):
                raise ValueError("LVS supply-disconnect control did not fail cleanly")
            controls = {"status": "PASS", "inputs": fingerprints,
                        "drc_markers": bad_markers, "lvs": negative_lvs}
            (results / "negative_controls.json").write_text(json.dumps(controls, indent=2) + "\n")
            print("PASS negative controls: violating metal and disconnected VDD rejected", flush=True)

        for name, path in inputs.items():
            if sha256(path) != fingerprints[name]["sha256"]:
                raise ValueError(f"Input changed during verification: {path}")
        status.update(status="PASS", inputs=fingerprints, pdk_root=str(pdk),
                      deck_sha256=decks, klayout_version=version[1],
                      drc={"deck": "main", "markers": markers},
                      lvs={**lvs, **reference_info, "implicit_nets": [],
                           "ignored_top_ports": False, "power_pins_removed": 0})
        print("PASS UART block physical verification; foundry release signoff is outside this check", flush=True)
        return 0
    except (OSError, ValueError, RuntimeError, KeyError, ET.ParseError) as error:
        status["error"] = str(error)
        print(f"Physical verification failed: {error}", file=sys.stderr)
        return 1
    finally:
        receipt.write_text(json.dumps(status, indent=2) + "\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--pdk", type=Path, default=Path(os.environ.get(
        "IHP_PDK_ROOT", str(Path.home() / ".ciel/ciel/ihp-sg13g2/versions" / PDK_REVISION / "ihp-sg13g2"))))
    parser.add_argument("--env", default="janestreet-uart")
    parser.add_argument("--gds", type=Path, default=ROOT / "10_gds/uart_core.gds")
    parser.add_argument("--database", type=Path, default=ROOT / "09_place_and_route/route.odb")
    parser.add_argument("--results-dir", type=Path, default=STAGE / "results")
    parser.add_argument("--negative-controls", action="store_true")
    sys.exit(run(parser.parse_args()))
