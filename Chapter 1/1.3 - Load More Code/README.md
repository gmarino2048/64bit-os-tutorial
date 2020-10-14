# Hello, BIOS

## Introducing the Build Script

From this point forward, we'll be using a shell script to automatically
build our code. As the tutorial continues to grow and become more complex,
the amount of work required to build each component will increase as well.
The shell script should run on any Linux or Mac system, and the only required
tools are the `sh` shell and the utilities discussed in Chapter 0.

The shell script will spell out each of the steps that we took to build the
code, so if you're ever curious about how each file is built, please refer
to the `build.sh` file.

## Introduction to the Hard Drive and ATA Utility

Back in the good old days of floppy disks and hard drives, information was
organized in physical rings which propagated outward from the center of the
disk. These individual rings were aptly called cylinders, and each one is
divided into multiple sectors. Each of those sectors is 512 bits long, and
indeed the boot sector we've been working on is the first sector of the first
cylinder of the disk. The final piece of a Hard Drive is the disk head, which
is the magnetic wand responsible for reading from and writing to the hard
drive. In more advanced hard drives it's possible to have more than one disk
head, but for the purposes of this tutorial we'll assume there's only one.

If we didn't have the BIOS to help us, we would have to include a full driver
to load more information within the boot sector itself. This is generally
agreed to be impossible, and so the BIOS provides us with the ATA utility.
ATA stands for "Advanced Technology Attachment", a very descriptive name which
we can thank IBM for. On a more interesting note, SATA stands for "Serial ATA"
which isn't very useful, but now you can feel that much smarter when you're
building a computer. Anyway, I'll go over the ATA utility in the next section,
but you should know that it saves us a **lot** of time and confusion.

These days, solid state drives (SSD's) no longer have such an architecture,
but for backward compatibility purposes the BIOS still treats all drives equally.
This means that even SSDs are still subdivided into cylinders and sectors.
Luckily, we're only concerned with loading a few sectors, so we can assume
that all our reading is going to take place from the 0th cylinder and the 0th
disk head. However, be warned: **the numbering of sectors begins at 1, and the
first sector of the 0th cylinder is the boot sector**. This means that if we
want to load more sectors, we'll need to start with sector 2 of cylinder 0.

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

## Try it Yourself

One of the things we'll need for the next chapter is a way to print numbers
to the console. Try creating your own `print_hex` function which prints a
16-bit number to the console in hexadecimal. Don't forget the `0x` prefix 
when you print your number to the screen!