---
title: "pytendo: 6502 CPU progress"
date: 2025-01-19T18:15:00-05:00
tags: ["games", "python", "nes", "c"]
series: ["pytendo"]
---

This is a quick update, my pytendo CPU implementation hit a small milestone: it's passing the
[nestest ROM](http://nickmass.com/images/nestest.nes) from [NesDev's emulator tests](https://www.nesdev.org/wiki/Emulator_tests)!
I've implemented 149 of the [151 official instructions](https://www.nesdev.org/wiki/Instruction_reference) in the
[MOS 6502](https://www.wikiwand.com/en/articles/MOS_Technology_6502) (sans `brk` and `cli`), and none of the [unofficial 
ones](https://www.nesdev.org/wiki/CPU_unofficial_opcodes). I also ported it to run on my Windows 11 machine 😊

<img class="flat" src="https://pianka.io/blog/pytendo-6502-cpu/nestest.png" alt="pytendo" title="pytendo">

I also got the very basics of sprite rendering working:

{{< youtube id="fHUD39jUHQg" >}}

There are some small updates to the debugger, but I'll save those for later – that's all for now.