"""Convert the powered routed netlist to a CDL-backed LVS reference."""

import re


def cell_models(library, destination):
    text = re.sub(r"\n\+\s*", " ", library.read_text())
    models = {
        match.group(1): match.group(2).split()
        for match in re.finditer(r"^\.SUBCKT\s+(\S+)\s+([^\n]+)", text, re.M | re.I)
    }
    if not models:
        raise ValueError("No standard-cell interfaces found in the PDK CDL")
    destination.write_text("\n".join(
        f"(* blackbox *) module {name} ({', '.join(pins)}); "
        f"inout {', '.join(pins)}; endmodule"
        for name, pins in models.items()
    ) + "\n")
    return models


def prepare_reference(raw, library, destination, models):
    text = raw.read_text()
    headers = [line.split()[2:] for line in text.splitlines()
               if line.startswith(".SUBCKT uart_core ")]
    if len(headers) != 1:
        raise ValueError("Expected exactly one uart_core reference subcircuit")
    ports = set(headers[0])
    if not {"VDD", "VSS"} <= ports:
        raise ValueError("Reference has no explicit VDD/VSS ports")
    aliases = {}
    instances = 0
    for line in text.splitlines():
        tokens = line.split()
        if line.startswith("X"):
            instances += 1
            pins = models[tokens[-1]]
            if len(tokens) != len(pins) + 2:
                raise ValueError(f"Reference pin count mismatch: {line}")
            for supply in ("VDD", "VSS"):
                if tokens[pins.index(supply) + 1] != supply:
                    raise ValueError(f"Disconnected or incorrect {supply}: {line}")
        elif line.startswith("V"):
            # Yosys represents wire aliases as zero-volt sources. The PDK's
            # device reader does not accept these; merge the equivalent names.
            if (len(tokens) != 5 or tokens[3:] != ["DC", "0"]
                    or tokens[2] not in ports or tokens[1] in ports):
                raise ValueError(f"Unsupported reference wire alias: {line}")
            aliases[tokens[1]] = tokens[2]
    if not instances:
        raise ValueError("Reference contains no cell instances")
    names = {name: re.sub(r"\.(\d+)$", r"[\1]", name) for name in ports}
    lines = ["* Powered UART routed reference", f'.include "{library}"']
    for line in text.splitlines():
        if line.startswith("V"):
            continue
        if line.startswith("X"):
            tokens = line.split()
            line = " ".join([tokens[0]] + [
                names.get(aliases.get(node, node), aliases.get(node, node))
                for node in tokens[1:-1]
            ] + [tokens[-1]])
        elif line.startswith(".SUBCKT uart_core "):
            line = " ".join(names.get(token, token) for token in line.split())
        lines.append(line)
    destination.write_text("\n".join(lines) + "\n")
    return {"instances": instances, "ports": len(ports),
            "wire_aliases_resolved": len(aliases), "power_pins_removed": 0}


def require_defined_layout_cells(text):
    expanded = re.sub(r"\n\+\s*", " ", text)
    definitions = {match.group(1).lower() for match in re.finditer(
        r"^\.SUBCKT\s+(\S+)", expanded, re.M | re.I)}
    for line in expanded.splitlines():
        if not line.startswith("X"):
            continue
        tokens = [token for token in line.split() if "=" not in token]
        if tokens[-1].lower() not in definitions:
            raise ValueError(f"Undefined extracted subcircuit: {tokens[-1]}")
