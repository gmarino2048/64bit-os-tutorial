# Chapter 3.1: The IDT

## What is an interrupt?

An interrupt is a built-in hardware feature of many Modern CPUs which allows an external device to interrupt the
processor's execution and perform some other task.
Most of the "modern" features you may take for granted on today's computers are interrupt-driven.
Most USB peripherals like keyboards and mice make use of interrupts to make typing and interacting with the display
more fluid and responsive.
Modern Operating Systems make use of interrupts driven by a timer circuit to perform task-switching and prevent the
Operating System from freezing.

Interrupts have existed for almost as long as the CPU itself, with even the earliest consumer processors allowing for
one to two hardware interrupts.
Modern processors have only expanded on this capability, expanding the number of interrupts available as well as
allowing the User/Operating System to configure the behavior and driver for these interrupts.

## The IDT

The modern x64 computer allows for 256 hardware interrupts, with the first 32 of those being reserved for use by the
processor itself.
I'll include an appendix with a list of these interrupts at the end of this section.
The behavior of each of these interrupts is controlled by a processor structure known as the Interrupt Descriptor
Table (IDT).
Each entry in the IDT points to the memory address of an Interrupt Service Routine (ISR).
The Interrupt Service Routine is just a method which will be called once the interrupt is triggered.

> [!WARNING]
> The CPU registers are not saved automatically during an ISR, and are left in the same state as they were when the
> interrupt occurred. To avoid interfering with program operation, these registers will need to be restored before
> returning from the interrupt context.

In this chapter, we will configure the layout of the IDT, and configure the table to handle the 32 reserved System
Interrupts.

### IDT Entries

Each entry in the 64-bit IDT follows the following convention:

* Low Address of ISR (16 bits): Bits 0-15 of the ISR address
* Code Segment Selector (16 bits): With Virtual Memory and Paging enabled, use the Code Segment from the existing GDT
* Zero (8 bits): Must always be zero
* Attributes (8 bits): Configuration for the listed ISR. Refer to `idt.h` for more details.
* Middle Address of ISR (16 bits): Bits 16-31 of the ISR address
* High Address of ISR (32 bits): Bits 32-63 of the 64-bit ISR address
* Reserved (32 bits): Reserved for system use. Must always be initialized to 0.

### Notifying the CPU of the Current IDT

Once the IDT has been configured with the Interrupt Service Routines, we will need to notify the CPU that the IDT is
configured and where in memory it exists.
This is done by using the LIDT command, which sets the memory address of the IDT register.
The IDT register contains two 64-bit values: the Base Address of the IDT and the uppermost address of the IDT.
Be sure to use LIDT with the *address* of the IDT register, and not its value.

## Building

There is a package that we need to ensure is downloaded onto our computer in order for this to run.
This can be installed with homebrew, or any other homebrew like package. Run the following command to install `llvm`:

```
brew install llvm
```

You will then need then add that install to the path. On mac or linux, first find where `llvm` was installed:

```
find /usr | grep 'ld.lld$'
```

Next, temporarily add the file to your path with:

```
export PATH=$PATH:[/path/to/exe]
```

In my case, the path was `/usr/local/Cellar/llvm/11.0.0/bin/`.

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
qemu-system-x86_64 -drive format=raw,file=os.img
```
