# MiniOS

### Created by Guy Marino, Noah Houpt, and Steven Nyeo

## How to Use This Tutorial

Hi everyone, this tutorial is meant to be an updated expansion on existing tutorials
which focuses more on the 64-bit x86_64 architecture. It's not meant to be an introduction
to C or Assembly, so you might want to learn those elsewhere first. We did our best to
properly document everything, so if there's something you don't understand, then you
might need to go back a few chapters.

* Chapter 1 covers the initial boot process
* Chapter 2 covers interfacing with the screen
* Chapter 3 covers CPU errors and (eventually) hardware requests

It's not complete yet, but it's gotten to a point where we felt it could be helpful.

## Who it's for

This tutorial is aimed at people who have a general understanding about C and Assembly,
but are not necessarily computer experts. It's designed to be as accessible as possible, so
it may feel at times like we over-explain some concepts (and that's okay). However, if
you find yourself hopelessly lost **please let us know.** We created this project because
we didn't like the gatekeeping seen in OS development, and we'd be happy to amend our
explanations or point you to another resource that may be more helpful.

## Contributing

If you'd like to contribute to this project, or add something of your own, please submit
a pull request. I'll try to get to them all as soon as possible :)

## What You'll Need

This tutorial uses the LLVM compiler suite, including `clang` and `ld.lld`. If you don't
have those installed, you'll need to do so and add them to your path. We also use `nasm`
for our assembler, and `qemu-system-x86_64` as our emulator. Optionally, `gdb` can be used
to debug kernel code.

You should be able to run all of the above commands in a terminal window without specifying
the full path. If you can't, you'll probably need to install them and add them to your path.
This tutorial has been tested on macOS (Catalina and Big Sur) as well as Ubuntu (20.04).
No other operating systems are officially supported, although it should run fine on most \*nix
machines.

> NOTE: macOS `gdb` has difficulty with the debug symbols from the kernel (elf64). You may need to change
  the debug output level to -glldb in the Makefiles and use that instead, or build a new `gdb` from source.

That's it! No need to install any crosscompilers or other tools, since clang has most of it
covered already. Best of luck, and if you have any trouble feel free to let us know!
