// ===============================================================================
// Ignytion IO - CRUCIBLE CORE
// Copyright (c) 2026 Ignytion IO. All rights reserved.
// Author      : IGNYTION_TECH
// File        : hw/protocols/spi/verify_build.mjs
// Created     : 2026-10-03
// Description : Inspect live RTL, mapped, timing and GDS reference-build evidence.
// ===============================================================================
import fs from 'node:fs';
import path from 'node:path';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import {fileURLToPath} from 'node:url';
const root=path.dirname(fileURLToPath(import.meta.url));
const unit=path.basename(root), top=unit+'_core';
const read=p=>fs.readFileSync(path.join(root,p),'utf8');
const mode=process.argv[2]??'all';
function lint(){
 const log=read('00_lint/lint_report.txt');
 assert(!log.includes('%Error')&&log.includes('Verilator: Walltime'));
 console.log('PASS complete RTL lint evidence (warnings retained)');
}
function sim(){
 assert(read('02_sim/simulation.log').includes('PASS '+unit.toUpperCase()+' regression:'));
 const cases=unit==='i2c'? [['negative_control.log','Expected a5'],['negative_control_5a.log','Expected 5a']]:[['negative_control.log',unit==='spi'?'SPI injected mismatch rejected':'UART RX mismatch']];
 for(const [file,message] of cases){const log=read('02_sim/'+file);assert(log.includes('FATAL:')&&log.includes(message));}
 console.log('PASS self-checking regression evidence');
}
function synth(){
 const module=JSON.parse(read('04_synthesis/synth.json')).modules[top];
 const types=Object.values(module.cells).map(c=>c.type).filter(t=>t!=='$scopeinfo');
 assert(types.length>0&&types.every(t=>t.startsWith('sg13g2_')&&!/^sg13g2_dl/.test(t)), 'Unmapped or latch cells');
 const log=read('04_synthesis/synthesis.log');
 assert(log.includes('Found and reported 0 problems.')&&log.includes('PASS SG13G2 synthesis'));
 console.log('Mapped cells: '+types.length);
 console.log('PASS mapped synthesis evidence');
}
function physical(){
 const def=read('09_place_and_route/route.def');
 assert(def.includes('DESIGN '+top)&&def.includes('END DESIGN')&&def.includes('ROUTED'));
 for(const file of ['06_floorplanning/openroad_floorplan.log','07_placement/openroad_placement.log','09_place_and_route/openroad_cts.log','09_place_and_route/openroad_route.log']){const log=read(file);assert(log.includes('PASS ')&&!log.includes('[ERROR'));}
 for(const file of ['timing_report.txt','timing_slow.txt']){
  const log=read('08_sta/'+file);
  const setup=Number(/worst slack max\s+(-?[\d.]+)/.exec(log)?.[1]);
  const hold=Number(/worst slack min\s+(-?[\d.]+)/.exec(log)?.[1]);
  assert(log.includes('PASS openroad_sta.tcl')&&!log.includes('VIOLATED'));
  assert(Number.isFinite(setup)&&Number.isFinite(hold)&&setup>=0&&hold>=0);
  console.log(file+': setup/hold '+setup+'/'+hold+' ns');
 }
 assert(fs.statSync(path.join(root,'09_place_and_route/route.spef')).size>1000);
 assert(read('09_place_and_route/route_drc.rpt').trim()==='', 'Router violations remain');
 const units=Number(/UNITS DISTANCE MICRONS (\d+)/.exec(def)[1]);
 const die=/DIEAREA\s*\(\s*(-?\d+)\s+(-?\d+)\s*\)\s*\(\s*(-?\d+)\s+(-?\d+)\s*\)/.exec(def).slice(1).map(Number);
 console.log('Die area: '+((die[2]-die[0])*(die[3]-die[1])/units**2)+' um2');
 console.log('PASS routed DEF and timing evidence');
}
function gds(){
 const data=JSON.parse(read('10_gds/validation.json'));
 const bytes=fs.readFileSync(path.join(root,'10_gds/'+top+'.gds'));
 assert(data.top===top&&data.bytes===bytes.length&&data.placed_instances>0);
 assert(data.sha256===crypto.createHash('sha256').update(bytes).digest('hex'));
 assert(data.status.includes('PASS structural export')&&data.raw_sha256_scope.includes('Run-specific'));
 assert(read('10_gds/negative_control.log').includes('DEF/GDS placement mismatch'), 'Missing exercised GDS failure control');
 console.log('PASS current GDS validation receipt');
}
function docs(){
 const hash={i2c:'3b067f00ccced753b0502024766a51f58f3e04bc',spi:'1ab581969f8ea2f794072a144b55cd74e5a54f34',uart:'1b867e53af738e4a8bc7c839ca2f1c07f40382dc'}[unit];
 const text=read('README.md');
 assert(text.includes(hash)&&text.includes('not a Tiny Tapeout submission')&&text.includes('not performed')&&text.includes('klayout-stream'));
 const lock=read('crucible.lock');assert(lock.includes('verilator')&&lock.includes('klayout-stream'));
 console.log('PASS reproduction and limitations recorded');
}
const checks={lint,sim,synth,physical,gds,docs};
assert(mode==='all'||Object.hasOwn(checks,mode));
if(mode==='all')for(const check of Object.values(checks))check();else checks[mode]();
