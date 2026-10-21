<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/stretch/usb_ls/GATES.md
Created     : 2026-10-03
Description : Stretch protocol reference acceptance, not signoff.
===============================================================================
-->
# Gates: usb_ls reference RTL to GDS

Scope: Existing usb_ls unit/stage directories only, WSL Igny, pinned licensed upstream. Low-speed USB HID host reference; 12 MHz core, 1.5 Mbit line signalling, digital pads only. Not a complete general-purpose USB emulator.
Depth Tree: source/requirements -> decisive independent line/frame tests -> mapped synthesis -> routed timing -> independently decoded GDS -> honest documentation.

- [x] T1: Pinned RTL, retained upstream notices, explicit speed and external electrical boundary are documented.
  CHECK: node verify_build.mjs docs
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=1feb37f12b0f73a6a69faeb419a1602bcf73cc93c0c6ea14cda7afe5709f7f94; exit=0; EXPECT=matched; output-sha256=05615f846aef8dfda1b2727a98ad5d520a1a5fcfd383e1bd8db3010b97c099ad; output-bytes=43; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\stretch\usb_ls; path=75172785e344/41 entries
- [x] T2: Independent protocol-level tests and a deliberately corrupted transaction prove test failure sensitivity.
  CHECK: node verify_build.mjs sim
  EXPECT: PASS self-checking regression evidence
  EVIDENCE: automatic-evidence=v1; definition-sha256=06e74f85338229429dfb3ac56e80ceb478ca5b231b5826ef3cb40b5672f1909d; exit=0; EXPECT=matched; output-sha256=f9a4b3f16b6def605976697bd0ac66298bceadd1d715e050123732f40dda56e2; output-bytes=39; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\stretch\usb_ls; path=75172785e344/41 entries
- [x] T3: SG13G2 mapped synthesis contains no unresolved cells or latches.
  CHECK: node verify_build.mjs synth
  EXPECT: PASS mapped synthesis evidence
  EVIDENCE: automatic-evidence=v1; definition-sha256=4d1481d0ff9545936b41f7004916670f9fd5d0fa443f051eb9ae949e424ecef8; exit=0; EXPECT=matched; output-sha256=1fce259fd727f9337192e38a59e66408a62ced84fdda45de978004e81dd343ae; output-bytes=50; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\stretch\usb_ls; path=75172785e344/41 entries
- [x] T4: Routed DEF/SPEF and TT/slow setup/hold reports pass stated constraints without remaining design violations.
  CHECK: node verify_build.mjs physical
  EXPECT: PASS routed DEF and timing evidence
  EVIDENCE: automatic-evidence=v1; definition-sha256=83de9adeced21e56c60a8503d309b38e0d9ae9261bd3e9175e08aeb78e29d250; exit=0; EXPECT=matched; output-sha256=1767025d9bdb07f1907a2839f5ddbd08f0756f885aee5a61aa6371a98d8c1d4a; output-bytes=143; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\stretch\usb_ls; path=75172785e344/41 entries
- [x] T5: Binary GDS decodes and matches routed placements; injected mismatch is rejected even under Python optimization.
  CHECK: node verify_build.mjs gds
  EXPECT: PASS current GDS validation receipt
  EVIDENCE: automatic-evidence=v1; definition-sha256=238e9efee22d5793895f0c05dbd0765d69462c1c7897e116239a2716a7d33ffe; exit=0; EXPECT=matched; output-sha256=a4a765d2bc34cafe9d7d24d398a7e0db2feacd68659306ca39930f1a79432746; output-bytes=36; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\stretch\usb_ls; path=75172785e344/41 entries
- [x] T6: Reproduction commands, Igny lock, actual coverage, absent DFT/foundry DRC/LVS and competition limitations are recorded.
  CHECK: node verify_build.mjs docs
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=1feb37f12b0f73a6a69faeb419a1602bcf73cc93c0c6ea14cda7afe5709f7f94; exit=0; EXPECT=matched; output-sha256=05615f846aef8dfda1b2727a98ad5d520a1a5fcfd383e1bd8db3010b97c099ad; output-bytes=43; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\stretch\usb_ls; path=75172785e344/41 entries
