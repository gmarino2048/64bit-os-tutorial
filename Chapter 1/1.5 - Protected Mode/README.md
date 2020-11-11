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

## Loading the GDT

To load the GDT into our CPU we need another data structure. This structure points
to the start of the GDT and contains the entire length of the GDT. For an
implementation of this structure, please see the `gdt.asm` file. This data
structure is the one we will pass to the LGDT command. The CPU will take care of
the rest.

> NOTE: If your GDT is incorrectly formatted, your CPU will restart

To load the GDT, we pass a pointer to our secondary data structure to the `lgdt`
command. See the `elevate.asm` file for an example.

## Setting the control bit

Now, we need to set the 0th bit of the control register `cr0`. However, `cr0`
is not connected to any data manipulation logic, so we cannot set it directly.
Rather, what we can do is copy the `cr0` register to one of our manipulation
registers like `eax`, and then use the binary `or` operator to set the least
significant bit. See the `elevate.asm` file for an example of how this is
done. Once we've set the bit we must move the value back to the `cr0` register
using the `mov` command.

## Long jump and pipeline clearing

Up until this point, we have been using 16-bit instructions in our processor.
However, these instructions are largely incompatible with the 32-bit instructions
we'll be using after we elevate our processor. Even worse, the x86 processor works
using a pipeline, meaning that there may still be remnants of those 16-bit
instructions in our CPU.

What we need is a way to flush these 16-bit instructions from our CPU so that
they don't cause problems with the incoming 32-bit instructions. We can do this
with a **long jump**. A long jump is usually intended to jump across segments,
but can also be used to jump to within the same segment. A long jump is a specific
instruction with the format:

```asm
jmp segment:address
```

Where `segment` is a pointer to the entry in the GDT which we want to govern the
jump (we only have two, so we'll use the data segment for this one). The
`address` component is the address to jump to starting from the base of our
segment. Since our base for both segments is `0`, we can assume the addresses
are the same as we've been using. Just performing this kind of jump is enough
to clear the pipeline.

## 32-bit Registers and Segmentation

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
