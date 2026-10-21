<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/uart/GATES.md
Created     : 2026-10-03
Description : Protocol reference integration and teaching build.
Upstream copyright and licence notices below remain applicable.
===============================================================================
-->
# Gates: UART reference RTL-to-GDS

Scope: Existing UART directories only, after SPI. SG13G2 mapped reference at 50 MHz with WSL Igny.

- [x] U1: Independent TX/RX tests cover exhaustive bytes, divisors, framing errors, backpressure and reset; mismatch injection fails.
  CHECK: node verify_build.mjs sim
  EXPECT: PASS self-checking regression evidence
  EVIDENCE: automatic-evidence=v1; definition-sha256=06e74f85338229429dfb3ac56e80ceb478ca5b231b5826ef3cb40b5672f1909d; exit=0; EXPECT=matched; output-sha256=f9a4b3f16b6def605976697bd0ac66298bceadd1d715e050123732f40dda56e2; output-bytes=39; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\uart; path=75172785e344/41 entries
- [x] U2: Mapped synthesis, routed DEF and extracted TT/slow timing are inspected.
  CHECK: node verify_build.mjs all
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=d4bdf463ef42d43ceab749606423ffd996b26160862c2544e1b9dab0f9ddd21e; exit=0; EXPECT=matched; output-sha256=6322a6a964dd610cc7ac7172ba053a5a32b3e7f94aa6835be03a0b4c7baffe47; output-bytes=361; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\uart; path=75172785e344/41 entries
- [x] U3: Binary GDS decode matches routed standard-cell placements and orientations.
  CHECK: node verify_build.mjs gds
  EXPECT: PASS current GDS validation receipt
  EVIDENCE: automatic-evidence=v1; definition-sha256=238e9efee22d5793895f0c05dbd0765d69462c1c7897e116239a2716a7d33ffe; exit=0; EXPECT=matched; output-sha256=a4a765d2bc34cafe9d7d24d398a7e0db2feacd68659306ca39930f1a79432746; output-bytes=36; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\uart; path=75172785e344/41 entries
- [x] U4: Upstream notices, tool lock, run instructions and signoff limits are recorded.
  CHECK: node verify_build.mjs docs
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=1feb37f12b0f73a6a69faeb419a1602bcf73cc93c0c6ea14cda7afe5709f7f94; exit=0; EXPECT=matched; output-sha256=05615f846aef8dfda1b2727a98ad5d520a1a5fcfd383e1bd8db3010b97c099ad; output-bytes=43; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\uart; path=75172785e344/41 entries
