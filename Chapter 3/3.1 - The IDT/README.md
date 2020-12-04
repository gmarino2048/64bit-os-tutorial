# Interrupt
An interrupt is generated from the CPU to signal the kernel of 
external hardware state changes. Interrupts are then handled by 
the interrupt handler, which is where the kernel takes action. 

# IDT
The interrupt descriptor table, or IDT, is a table populated with 
various types of interrupts indicated by an interrupt number. When 
an interrupt is received, the kernel locates the appropriate 
interrupt handler to execute according to the IDT. In our tutorial, 
the interrupt types are listed in the file `cpu/isr.c` where we 
include 32 types of interrupts with their corresponding exception 
messages. 

# ISR
An interrupt handler, formally an interrupt service routine (ISR), 
is programmed to run when the kernel detects an interrupt. Each 
interrupt type has its own defined interrupt routines. 


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
