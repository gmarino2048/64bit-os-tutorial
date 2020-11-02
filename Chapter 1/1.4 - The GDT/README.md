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
provide access control.

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