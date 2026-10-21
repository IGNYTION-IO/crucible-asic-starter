<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/stretch/ethernet/03_verification/README.md
Created     : 2026-10-03
Description : Actual ethernet reference stage entrypoint and claim boundary.
===============================================================================
-->
# ethernet: 03_verification

From the unit root, run make sim in WSL Igny, or bash run_flow.sh sim.
Earlier stage artifacts are required for physical stages. make flow runs
simulation, synthesis, physical stages and GDS export sequentially.
Run make lint separately, or use root make all.

The unit README.md owns interfaces, pin, coverage and reproduction commands.
GATES.md and repository .context.md own current acceptance and progress.
Generated netlist/DEF/SPEF and binary GDS retain native formats; adjacent source
headers and validation receipts record provenance. Execution is not acceptance.

Directed self-checking simulation and mismatch injection are supplied, not formal verification.

`make crc` compares the fixed CRC state transform against the preserved upstream
LFSR on 297 vectors and checks CRC32 CBF43926 for ASCII "123456789". A deliberately
corrupted expected state must fail fatally. `make sim` includes this check after
the independent MII frame regression. The unused LFSR data_out is not compared.

Foundry DRC/LVS, antenna and full-chip signoff are not performed.
