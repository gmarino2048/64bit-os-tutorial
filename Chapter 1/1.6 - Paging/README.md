# Paging

## Detecting Long Mode

Before we can enter long mode, we need to make sure that it's actually
supported. Since we've been working mostly in protected mode, we could
either be on a 64-bit CPU in compatibility mode or a 32-bit native CPU.
If we try to enter long mode on a native 32-bit CPU then we'll have a
ton of errors, so it's best not to try if we can avoid it. Luckily, the
built-in CPU Identifier function can tell us if we have long mode on our
CPU. Unfortunately, not all versions of the CPU identifier support this.
Even worse, not all x86 CPUs support the CPU Identifier function. So,
our long mode identification must be done in 3 steps:

1. Check for CPUID
2. Check for CPUID extended functionality
3. Check for long mode

This check is done in the `protected_mode/detect_lm.asm` file, and it's
completely explained through comments in that file, so I won't go into
it much here. If you want to know how it works, check it out!

## Setting up the Page Table

### Paging Explained

Paging is a form of access control, similar to the segmentation described
in Chapter 1.4. However, segmentation controls physical memory, while paging
introduces the concept of Virtual memory. Virtual memory allows us to have
continuous memory addresses without requiring those addresses to be
continuous in physical memory. This has several benefits, but for a simple
example consider the following example:

Say I want to allocate a million-element list, which would take up about 4MB.
If I was going to do this in physical memory, I would need to find actual
addresses in RAM that are empty for 4 whole megabytes, which isn't an easy task.
However, if I used virtual memory I could use addresses 0-4million, then split
this monolith into chunks and store it in physical memory wherever I have space.

The page table is what gives our CPU a translation from virtual memory to
actual physical memory. Rather than have one monolithic page table though, the
architects of the x86_64 architecture broke the page tables into 4 hierarchical
tables, with each table having only 512 entries.

### Page Hierarchy

The page hierarchy consists of 4 tables:

* PML4T (Page Map Level 4 Table)
* PDPT (Page Directory Pointer Table)
* PDT (Page Directory Table)
* PT (Page Table)

Entries in the PML4T point to an individual PDPT, entries in the PDPT point to
an individual PDT, and entries in the PDT point to an individual PT. This means
that there is only **one** PML4T, 512 possible PDPT's, 262,144 possible PDT's,
and 134,217,728 possible PT's.

In addition, an entry in the page table points to a specific page in physical memory,
which is addressed by 12 bits and is equal to 4KB. For example, page 0 in physical
memory covers addresses 0x0000 to 0x0FFF. This means that fully-realized page table can
address a whopping 256TB of RAM.

### Identity Mapping

The page table allows a huge amount of fine-grained control over memory, but
it can get a little unwieldy for human use. Luckily, we don't need that much memory
for our simple operating system, so one page table (which can address 2MB!) will
suffice. To do this, we'll create one of each PML4T, PDPT, and PDT and only fill in
the first entry. Then, we'll also create our sole page table and set it to the first
entry in the PDT.

For the PT, each entry should correspond to the same page in physical memory, so:

```c
PT[0] = 0
PT[1] = 1
...
```

To see how we do this, check out the `protected_mode/init_pt.asm` file, which
sets up and initializes the 2MB identity-mapped page table!

### Locating the Page Table

You may be wondering: How does the CPU find the page table? Well, the answer is
really simple. The address of the PML4T is just stored in the cr3 register of the
processor! That's it!

## Try it yourself

Up until this point, the code we've been writing has been compatible
with both x86_64 and i386 systems (64 and 32-bit)! However, we want
to avoid trying to activate long mode on a 32-bit system, so we've
put safeguards in place to prevent this.

Try running the following commands and see how the output on the screen
changes!

32-bit:

```sh
qemu-system-i386 -drive format=raw,file=boot
```

64-bit:

```sh
qemu-system-x86_64 -drive format=raw,file=boot
```

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
