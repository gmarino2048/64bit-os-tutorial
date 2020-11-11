# Protected Mode

## Setting Protected Mode

You may be wondering why we spent an entire subchapter on the GDT,
only for it to not do anything. We did this because the GDT is
**required** to enable protected mode. For the most part, you can
think of protected mode as a fancy way of saying 32-bit x86 mode
(although this doesn't always hold). Since the GDT is such a complex
data structure, we wanted to explain it as in-depth as we possibly
could.

Once you've got the GDT right (which can be extremely tricky if
you're not careful), entering protected mode is a fairly straightforward
process. We'll be using the following steps to enter protected mode:

1. Disable interrupts
2. Load the GDT into the CPU
3. Set 32-bit mode in the control register
4. Clear the processor pipeline

From this point, we should be successfully in 32-bit mode, and have
access to all of the benefits that come with it. This includes 32-bit
registers and advanced segmentation methods. However, since we're going
to enter 32-bit mode, we will probably only ever use the 32 bit registers.

## Disabling interrupts

Setting the GDT in the CPU causes the CPU to emit a large amount of interrupts,
and since we haven't set any interrupt handlers, we'll need to prevent the CPU
from reacting to these interrupts somehow. We can do this with two x86 commands,
`cli` and `sti`. The `cli` command causes the CPU to ignore all interrupts, and
stands for "clear interrupt bit". On the other hand,`sti` restores interrupts,
and stands for "set interrupt bit". To prevent our CPU from going wild and
resetting itself, we need to use the clear interrupt command. We will not restore
interrupts yet as we need to have our interrupt handlers defined before doing so.

## Long jump and pipeline clearing

## 32-bit registers

## 32-bit segmentation

## VGA Text Memory

## Building

Building this example is the same as building the previous step. To
assemble the program, use either:

```sh
./build.sh
```

or

```sh
sh build.sh
```

Then, to run the program in QEMU, use the following command:

```sh
qemu-system-x86_64 -drive format=raw,file=boot
```
