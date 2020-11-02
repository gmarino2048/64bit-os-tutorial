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