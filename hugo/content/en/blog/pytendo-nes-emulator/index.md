---
title: "pytendo: a Python NES emulator written in C"
date: 2025-01-03T20:20:00-05:00
tags: ["games", "python", "nes", "c"]
series: ["pytendo"]
---

My holiday break project this year was to build an NES emulator in Python, sort of. Somewhere
between recently beating the [NandGame](https://nandgame.com/), feeling nostalgia after seeing the
[Pokemon Red Experiments](https://github.com/PWhiddy/PokemonRedExperiments), and getting a new graphics
card, I felt like building an NES emulator in Python that I could try to train an AI to play.

So, I humbly introduce my latest project...

<img class="flat" src="https://pianka.io/blog/pytendo-nes-emulator/pytendo.png" alt="pytendo" title="pytendo">

## The Design

I started by building a multithreaded prototype in pure Python, using [pygame](https://www.pygame.org/) to draw frames
–  it was unsurprisingly slow.  I ported it to [Cython](https://cython.org/), but it spent all its time thrashing
on the [Python GIL](https://wiki.python.org/moin/GlobalInterpreterLock), the main thread starving the emulator 
threads.  I refactored that implementation to be single-threaded as clock synchronization across threads is complex,
but the performance was simply not good enough.

Instead, I decided to rewrite it from scratch in pure C and expose it to Python with 
[extensions](https://docs.python.org/3/extending/extending.html).  It's a single-threaded tick approach that fits
cleanly into render loops, with no globals so multiple emulators can be run in threads.  It links with
[NumPy](https://numpy.org/)'s C API to expose rendered frames as byte arrays representing RGB values for each
pixel.  The pytendo C APIs are wrapped in a Pythonic API, which can then be consumed by a user-playable app, a
debugger, reinforcement learning, anything really.

Here's what the system looks like:

<img class="flat" src="https://pianka.io/blog/pytendo-nes-emulator/architecture.png" alt="pytendo" title="pytendo">

The core of the emulator, the [CPU](https://www.nesdev.org/wiki/CPU), the [PPU](https://www.nesdev.org/wiki/PPU),
and (eventually) the [APU](https://www.nesdev.org/wiki/APU) are implemented in C.  The C API exposes a Python extension
module that wraps the internal emulator functions for ticking, retrieving a rendered frame, and so on.  The Python API
is split between normal use and special functions for introspecting an emulator. Consumers of the Python API can use it
to [blit](https://www.wikiwand.com/en/articles/Bit_blit) the NumPy array to a drawn canvas such as pygame or [Dear
PyGUI](https://github.com/hoffstadt/DearPyGui), or start normalizing it for training in [PyTorch](https://pytorch.org/).

So far, I've implemented roughly half of the [MOS 6502](https://www.wikiwand.com/en/articles/MOS_Technology_6502)
instruction set, the very basics of background drawing (no sprites) and [CHR ROM](https://www.nesdev.org/wiki/CHR_ROM_vs._CHR_RAM)
in the PPU, and a simple debugger.  Audio and input are still a ways off.

## The Debugger

Using `printf` only goes so far when you're trying to figure out what's happening inside the emulator, so pretty early
on I started building a debugger.  It uses a Dear PyGUI window, draws rendered frames to a texture in the window, and
has a handful of controls and panes to the side to inspect state during a running [ROM](https://www.wikiwand.com/en/articles/ROM_image).

Here's a quick demo with a branch timing test rom:

{{< youtube id="WPPWnPSVWjA" >}}

It loads the ROM in a paused state (and is rendering junk data).  I set a [breakpoint](https://www.wikiwand.com/en/articles/Breakpoint)
at a random instruction, and press the `Run` button.  It ticks away at the emulator until the `PC` register points
to the address of the breakpoint I set.  It breaks, and I can step through some lines and watch the registers change.
Press `Run` once more and it will proceed until it hits the breakpoint again.  I remove the breakpoint, run it again,
and it spins on an infinite loop that I can interrupt.

## What's Next

There's obviously a lot more to do, but the basic skeleton of the system is up and running.  I need to round out the
6502 instruction set, run through more and more test ROMs to fill in functionality and emulate edge cases, expand the
debugger so it's net useful, and plenty more.

You can find all the [code on GitHub](https://github.com/pianka-io/pytendo).  I'll be writing more on this project as
time constraints allow.  Finally, a special thanks to the folks at [NesDev](https://www.nesdev.org/) for compiling such
a rich knowledge base on how the NES works!