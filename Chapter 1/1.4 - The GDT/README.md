# The GDT

## GDT Overview

The GDT, or Global Descriptor Table, is absolutely key to the CPU
setup process. However, it is hardly ever used in 64-bit long mode.
Why would the engineers include the GDT at all if it's not going to
be used?

The answer is backwards compatibility. The predecessor to the x86_64
architecture, x86, used **segmentation** as its main form of hardware-
accelerated access control. This segmentation scheme was later replaced
with **paging** in the 64-bit successor.

While paging is generally seen as a much better alternative, 32-bit
applications still rely on global and local descriptor tables to
provide access control. To read more about the GDT, you can refer
to the entry in the OSDev Wiki
[here](https://web.archive.org/web/20200806145801/https://wiki.osdev.org/Global_Descriptor_Table).

## Access Control: Segmentation vs. Paging

One of the key components of computer security is memory access control.
Early microprocessors (the 8086, for example) did not have any built-in
memory protection. This meant that a program could theoretically access
**any** location in system memory, including that used for the OS.

Obviously, allowing every program to access all locations isn't ideal when
it comes to viruses and other malicious software. Thus, the concept of
[protection levels](https://web.archive.org/web/20200709033841/https://wiki.osdev.org/Security)
was born. Historically, the protection levels have been divided into 4 "rings".
Ring 0 has access to all hardware, and is the least restrictive of the three.
Rings 1 and 2 were intended to be used for device drivers, though these rings
are rarely used in any modern operating systems. Finally, ring 3 is intended
for "user" level applications, and is the most restrictive of the three.

Protection levels allow the CPU hardware to know when an application from a higher
ring (e.g. 3) attempts to access memory allocated to a lower ring (e.g. 0).
This is done by assigning an access level to a series of hardware addresses. For
example, addresses `0x00000000` to `0x0000FFFF` could be assigned ring level 3 to
let the CPU know that the application running within is ring level 0. In x86
processors, this assignment is done in the GDT. The GDT allows other configurations
as well including:

* Read, write, and execute permissions
* Code and Data configurations
* Memory block granularity
* Stack Growth Direction

## Handling Improper Access

How exactly does the CPU help with memory access though? The answer lies in system
interrupts. If a process running in ring 3 attempts to access memory in tiers 0-2,
then the CPU will detect a descrepency in the protection levels and throw an
interrupt which can then be handled by the Operating System. (In most cases, the
offending process is killed.)

## GDT Structure

Each entry in the GDT is 64 bits wide. The breakdown of each component is described
in the following list and in the `gdt.asm` file.

* (0-15) Segment Base (bits 0-15)
* (16-31) Segment Limit (bits 0-15)
* (32-39) Segment Base (bits 16-23)
* (40-43) 1st flags: Present (1 bit), Protection (2 bits), and Descriptor (1 bit)
* (44-47) Type Flags: Code(1 bit), Expand Down (1 bit), Writeable (1 bit), Accessed (1 bit)
* (48-51) 2nd flags: Granularity (1 bit), 32-bit default (1 bit), 64-bit segment (1 bit), AVL (1 bit)
* (52-55) Segment Limit (bits 16-19)
* (56-63) Segment Base (bits 24-31)

Note that the segment limit is 20 bits instead of 32. This is where the "Granularity"
bit comes in handy. If "Granularity" is `0`, then the segment limit is interpreted as
individual bits for a maximum segment size of 2^20 bits. However, if "Granularity"
is set to `1`, then the limit is interpreted in 4096-bit pages, meaning that the max
size of a gdt segment is 2^32 bits, or the full 4GB of addressable memory.

One additional component of the GDT which needs to be mentioned is the "Null" entry.
The CPU requires that the first entry of the GDT is all 0's, or a 64-bit value of 0.
This was done as an error-checking measure to ensure that the GDT is correct, as
setting a GDT to the wrong value could have potentially catastrophic results.

Finally, the GDT has a subcomponent known as the "GDT Descriptor". This is a smaller
data structure which contains the start and end addresses of the GDT. The GDT descriptor
is what the CPU actually uses to load the GDT, and its address is the one passed into
the `LGDT` command used to load the GDT.

## "Flat" Configuration

While the GDT is a valid option for access control, paging will allow us to use the
concept of "Virtual Memory" (which we'll review later) and its better or equivalent
to this segmentation control in almost every way. However, due to backward-compatibility
reasons, we still need to define a valid GDT for our processor before enabling paging.

To avoid conflicting access control schemes, we want the GDT to allow us to read, write,
and execute data at every single memory address. This means that we won't have to worry
about potentially violating GDT rules when setting up paging. Additionally, all memory
should be defined in Ring 0 to allow unfettered access to the CPU hardware. This configuration
is generally known as the "Flat" configuration, as it is the simplest and least restrictive
GDT configuration possible.

We'll be using the flat configuration for our setup since we want to enable paging later.
The flat configuration requires two entries in the GDT in addition to the null descriptor:
one for code and one for data. The configuration options are slightly different for each,
and we need to use both in order to get full read, write, and execute permissions on all
addresses. To see an example of the flat configuration, see the `real_mode/gdt.asm` file.

Once we have the flat mode configuration ready to go, we'll be able to elevate our
processor to 32-bit mode.

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
