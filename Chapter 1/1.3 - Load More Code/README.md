# Load More Code

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

## Using the ATA Utility

The ATA Utility allows us to use an interrupt to make a call down to the BIOS
so that we can load additional sectors without writing our own drivers. This
not only saves us time, but also helps us to consolidate our initialization
code to a single sector. The ATA Utility actually uses all four of the
Real-Mode registers (`ax`, `bx`, `cx`, and `dx`). Each register's usage is
described below:

* `ah`: `0x02`, the code for the BIOS read utility
* `al`: the number of sectors to read from the disk. Must be less than 128.
* `bx`: The destination of the loaded segments in RAM. This value is offset
by segment register `es`
* `ch`: The cylinder number. This will most likely be cylinder 0.
* `cl`: Sector number. Remember that the first sector is 1 (the boot sector),
so the next sector we should read from is 2.
* `dh`: The cylinder head. Unless you really know what you're doing this
should probably be 0.
* `dl`: The disk to read from. For the boot disk this is `0x80`

To execute the read, we must interrupt the CPU with `int 0x13`. Once this
happens, the number of sectors that were successfully read will be stored
in `al`. If there was an error, the `carry` bit in the 8086 special register
will be set, and the error code will be stored in `ah`. We can then notice
and react to any of these potential errors accordingly.

For a more in-depth description of the BIOS ATA utility, see the entry from
the OSDev Wiki [here](https://web.archive.org/web/20201021171813/https://wiki.osdev.org/ATA_in_x86_RealMode_%28BIOS%29).

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