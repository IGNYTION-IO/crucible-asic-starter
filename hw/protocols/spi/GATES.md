<!--
===============================================================================
Ignytion IO - CRUCIBLE CORE
Copyright (c) 2026 Ignytion IO. All rights reserved.
Author      : IGNYTION_TECH
File        : hw/protocols/spi/GATES.md
Created     : 2026-10-03
Description : Protocol reference integration and teaching build.
Upstream copyright and licence notices below remain applicable.
===============================================================================
-->
# Gates: SPI reference RTL-to-GDS

Scope: Complete only in the existing SPI stage directories after I2C, WSL Igny, SG13G2 50 MHz. Hardening is mode 0, simulation covers all four modes.

- [x] S1: All four SPI modes pass exhaustive byte checks and the deliberate mismatch is rejected.
  CHECK: node verify_build.mjs sim
  EXPECT: PASS self-checking regression evidence
  EVIDENCE: automatic-evidence=v1; definition-sha256=06e74f85338229429dfb3ac56e80ceb478ca5b231b5826ef3cb40b5672f1909d; exit=0; EXPECT=matched; output-sha256=f9a4b3f16b6def605976697bd0ac66298bceadd1d715e050123732f40dda56e2; output-bytes=39; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\spi; path=75172785e344/41 entries
- [x] S2: SG13G2 mapped synthesis, routed DEF and post-route timing are inspected.
  CHECK: node verify_build.mjs all
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=d4bdf463ef42d43ceab749606423ffd996b26160862c2544e1b9dab0f9ddd21e; exit=0; EXPECT=matched; output-sha256=e8dc82c0a390f6eefc074f4ade0be5c016f924c38339edb163b30e60d9c84092; output-bytes=361; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\spi; path=75172785e344/41 entries
- [x] S3: GDS is independently decoded and placed cells agree with DEF.
  CHECK: node verify_build.mjs gds
  EXPECT: PASS current GDS validation receipt
  EVIDENCE: automatic-evidence=v1; definition-sha256=238e9efee22d5793895f0c05dbd0765d69462c1c7897e116239a2716a7d33ffe; exit=0; EXPECT=matched; output-sha256=a4a765d2bc34cafe9d7d24d398a7e0db2feacd68659306ca39930f1a79432746; output-bytes=36; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\spi; path=75172785e344/41 entries
- [x] S4: Source notices, Igny lock, reproduction commands and signoff limitations are recorded.
  CHECK: node verify_build.mjs docs
  EXPECT: PASS reproduction and limitations recorded
  EVIDENCE: automatic-evidence=v1; definition-sha256=1feb37f12b0f73a6a69faeb419a1602bcf73cc93c0c6ea14cda7afe5709f7f94; exit=0; EXPECT=matched; output-sha256=05615f846aef8dfda1b2727a98ad5d520a1a5fcfd383e1bd8db3010b97c099ad; output-bytes=43; shell=C:\Windows\system32\cmd.exe; cwd=C:\Users\ignyt\Desktop\crucible\Products-and-Dev\dev\Janes_street\crucible-asic-starter\hw\protocols\spi; path=75172785e344/41 entries
