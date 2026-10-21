<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/stretch/usb_ls/07_placement/README.md
Created     : 2026-10-03
Description : Actual usb_ls reference stage entrypoint and claim boundary.
===============================================================================
-->
# usb_ls: 07_placement

From the unit root, run make place in WSL Igny, or bash run_flow.sh place.
Earlier stage artifacts are required for physical stages. make flow runs
simulation, synthesis, physical stages and GDS export sequentially.
Run make lint separately, or use root make all.

The unit README.md owns interfaces, pin, coverage and reproduction commands.
GATES.md and repository .context.md own current acceptance and progress.
Generated netlist/DEF/SPEF and binary GDS retain native formats; adjacent source
headers and validation receipts record provenance. Execution is not acceptance.



Foundry DRC/LVS, antenna and full-chip signoff are not performed.
