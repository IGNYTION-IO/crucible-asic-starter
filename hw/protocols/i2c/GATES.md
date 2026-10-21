<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/i2c/GATES.md
Created     : 2026-10-03
Description : Protocol reference integration and teaching build.
Upstream copyright and licence notices below remain applicable.
===============================================================================
-->
# Gates: Five protocol reference builds and three student lessons

Scope: The five existing protocol units and their numbered stage directories, using WSL Igny CLI tools and IHP SG13G2. I2C/SPI/UART use 50 MHz (20 ns), low-speed USB uses 12 MHz, and 10 Mbit Ethernet uses 2.5 MHz MII clocks. Three student decks live in the existing repository docs directory. Preserve upstream notices and prove generated artifacts; do not claim competition integration or foundry signoff.

User amendment: after I2C, complete the same verified flow for SPI and then UART in their existing unit directories. Shared Claude work is recorded at repository-root .context.md.

Depth Tree: tool readiness and source provenance -> decisive RTL regression -> mapped synthesis -> floorplan/placement/CTS/routing -> timing and decoded GDS -> reproducible handoff.

Implementation direction: The user explicitly confirmed proceeding with this existing I2C unit in the current conversation on 2026-10-03. No new project folder is authorized. Canonical context files are unavailable in this checkout; no canonical governance validation is claimed.

- [x] G1: Pinned source provenance and installed WSL tool versions are recorded.
  CHECK: node verify_build.mjs docs
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=1feb37f12b0f73a6a69faeb419a1602bcf73cc93c0c6ea14cda7afe5709f7f94; exit=0; EXPECT=matched; output-sha256=05615f846aef8dfda1b2727a98ad5d520a1a5fcfd383e1bd8db3010b97c099ad; output-bytes=43; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries

- [x] G2: The actual i2c_core DUT passes a self-checking I2C regression, and a deliberate failure is rejected.
  CHECK: wsl.exe bash -lic "igny init >/dev/null; cd /mnt/c/Users/ignyt/Desktop/crucible/Products-and-Dev/dev/Janes_street/crucible-asic-starter/hw/protocols/i2c; bash run_flow.sh sim"
  EXPECT: PASS I2C negative control
  EVIDENCE: automatic-evidence=v1; definition-sha256=c801f3f8d52f95381949b26c72218d192f2cbb31927d9ff26bc2ea745dded5da; exit=0; EXPECT=matched; output-sha256=50b3eb82521f566d1bc7fdd78794c261425032261de389874358bd654d0014c0; output-bytes=2144; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries

- [x] G3: Synthesis produces an SG13G2 mapped netlist with no unresolved cells or latches.
  CHECK: node verify_build.mjs synth
  EXPECT: PASS mapped synthesis evidence
  EVIDENCE: automatic-evidence=v1; definition-sha256=4d1481d0ff9545936b41f7004916670f9fd5d0fa443f051eb9ae949e424ecef8; exit=0; EXPECT=matched; output-sha256=8c2e78fdaae2f95db81433d5fb29cf8171779976a47e2ce99904bbebdd17826c; output-bytes=50; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries

- [x] G4: Placement, CTS, and detailed routing produce inspected routed DEF and timing reports.
  CHECK: node verify_build.mjs physical
  EXPECT: PASS routed DEF and timing evidence
  EVIDENCE: automatic-evidence=v1; definition-sha256=83de9adeced21e56c60a8503d309b38e0d9ae9261bd3e9175e08aeb78e29d250; exit=0; EXPECT=matched; output-sha256=ff2f3d2b73c7dd83abebd6169c6e71c352055f0607358f16773b7963c7b8bd8e; output-bytes=142; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries

- [x] G5: The new GDS is independently decoded and agrees with the routed design.
  CHECK: wsl.exe bash -lic "igny init >/dev/null; cd /mnt/c/Users/ignyt/Desktop/crucible/Products-and-Dev/dev/Janes_street/crucible-asic-starter/hw/protocols/i2c; bash run_flow.sh gds"
  EXPECT: PASS independent GDS decode and DEF placement comparison
  EVIDENCE: automatic-evidence=v1; definition-sha256=8ade9fd91ddd66c5681b8f2b230da65de211b2dd7a44df261a14c8ebd094e510; exit=0; EXPECT=matched; output-sha256=ae126bcd98475009760697be349f6ac1b3a46ae5e0e884b7e80de71d1c7e1728; output-bytes=1160; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries

- [x] G6: Reproduction instructions and physical-verification status match measured evidence.
  CHECK: node verify_build.mjs docs
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=1feb37f12b0f73a6a69faeb419a1602bcf73cc93c0c6ea14cda7afe5709f7f94; exit=0; EXPECT=matched; output-sha256=05615f846aef8dfda1b2727a98ad5d520a1a5fcfd383e1bd8db3010b97c099ad; output-bytes=43; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries

- [x] G7: SPI completes the same verified RTL-to-GDS flow in its existing protocol directory after I2C.
  CHECK: node ../spi/verify_build.mjs all
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=9efbade31410b1b5c01d132a6f3b0daaa3044c63866fb5137a47c2914d6498cc; exit=0; EXPECT=matched; output-sha256=e8dc82c0a390f6eefc074f4ade0be5c016f924c38339edb163b30e60d9c84092; output-bytes=361; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries

- [x] G8: UART completes the same verified RTL-to-GDS flow in its existing protocol directory after SPI.
  CHECK: node ../uart/verify_build.mjs all
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=f564c76acf937111949bc0ad8aefb3b9f21cf7bed86178f8cc3f212235092825; exit=0; EXPECT=matched; output-sha256=6322a6a964dd610cc7ac7172ba053a5a32b3e7f94aa6835be03a0b4c7baffe47; output-bytes=361; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries

- [x] G9: The repository-root .context.md records actual progress, a Claude assignment, and received feedback or the concrete communication blocker.
  EVIDENCE: 2026-10-03 Codex inspected append-only C001/C002 returned Claude findings and reconciliation, C003 assignment and actual HTTP 429 reset time 07:40 Asia/Calcutta; pending work and ownership remain explicit.

- [x] G10: Detailed student PPTX decks cover I2C, SPI and UART in that order, match the APB reference, and pass rendered review.
  EVIDENCE: 2026-10-03 Codex reviewed all 78 individual v2 slide renders at full size against APB reference furniture/fonts/colors. Three finalization receipts report 26 slides each, zero package/layout findings, first-party import passed. Native PowerPoint runtime is not claimed. docs/verify_student_decks.py checks live hashes, notes, citations, native tables and measured results.

- [x] G11: Confirmed low-speed USB and 10 Mbit Ethernet complete the requested reference workflow after the first three and decks.
  CHECK: node ../stretch/usb_ls/verify_build.mjs all && node ../stretch/ethernet/verify_build.mjs all
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=e8ccbf45fa828f8aeaa036ca4af170bd599f98ef534153aa2432af0615bf798a; exit=0; EXPECT=matched; output-sha256=baf69eb87865362f12e0d93309853f26fc7826ae548452f0c0f664fa6fd3267c; output-bytes=725; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries

- [x] G12: A recurring continuation heartbeat is created for this thread without claiming usage-limit bypass.
  EVIDENCE: 2026-10-03 Codex read back the saved automation.toml: id continue-protocol-builds-and-student-decks, heartbeat ACTIVE, FREQ=HOURLY;INTERVAL=1, target_thread_id 01a0fe7f-32f5-75b3-ad7d-e5e8d5765dc3. Future successful quota recovery is not claimed. Restart constraints and Claude retry ownership recorded in root .context.md.

- [x] G13: All three finalized lesson packages have live matching hashes, sourced notes, editable tables, complete renders and current measured build claims.
  CHECK: python ../../../docs/verify_student_decks.py --revision v11 --detailed
  EXPECT: PASS three detailed student decks
  EVIDENCE: automatic-evidence=v1; definition-sha256=5d20a7ac822f3d9901ac875e66856501aa1f437fcea1d2e70e908ef69e1e297f; exit=0; EXPECT=matched; output-sha256=4cb106a6701a8179c16254f63d17513e11168bffec992efb14833dd5bdccd8a1; output-bytes=297; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries

- [x] G14: Human feedback that the v2 PPTX lessons are too basic is addressed by the detailed three-deck revision.
  CHECK: node C:/Users/ignyt/.codex/skills/unlazy/scripts/gate-check.mjs --status ../../../docs/GATES.md
  EXPECT: ALL MET
  EVIDENCE: automatic-evidence=v1; definition-sha256=39edeb9623fd41f95b47056e9210f7f319ade39816b9ab8935da67e7f6bd03b1; exit=0; EXPECT=matched; output-sha256=813fff2388ece4afd15578fd4a102768b406970bc344515be8d65a496eccef97; output-bytes=34; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\i2c; path=75172785e344/41 entries
