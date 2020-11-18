# Long Mode

## Steps to Enable Long Mode

Now that we've set up paging (but have not enabled it yet), we need to fully enable paging
and officially enter long mode. This process is very similar to the one we used to enter
protected mode. It basically boils down to the following few steps:

1. Enable Long Mode
2. Enable Paging (Remember, it's only been activated at this point)
3. Load the 64-bit GDT
4. Far jump to clear the pipeline

Now, you're probably thinking: "Another GDT? Didn't we do that already?" and the answer is
both yes and no. First, we need to understand what happens in step 2, when we actually enable
long mode. Even though it's enabled, we still won't have access to any 64-bit registers or
instructions. But why is that? The reason is that the GDT we've defined explicitly specifies
that our code section is 32-bit. This means that even though long mode is enabled, it's stuck
in a 32-bit compatibility mode. In order to disable this compatibility feature, we need a new
GDT entry which explicitly specifies a 64-bit code segment.

## Enabling Paging and Long Mode

Enabling paging and long mode are as easy as setting two bits in the CPU's control registers.
The first step is to enable Long Mode (which will put us in protected mode so not much will
change). This involves setting the 8th bit in the model-specific register. We can read and
write to the model-specific registers using the `rdmsr` and `wrmsr` commands respectively. However,
in order to get the correct register we need to provide an argument in `ecx`. For the long-mode
control register this is `0xC0000080`. This will put the MSR value in `eax`, and we can set the 
bit using the `or` command. We then write to the MSR with `eax`, so it's super simple.

The paging control bit is bit 31 in the `cr0` register. We can set this extremely easily like
we did in Chapter 1.5. To see how these steps are done, see the `protected_mode/elevate.asm`
file.

## The GDT Redux

We need to use a 64-bit GDT in order to leave compatibility mode and use our 64-bit registers
and features. However, once we actually define this GDT it won't really ever be used at all
since the page tables become the preferred form of access control. To see the GDT we're using,
see the `protected_mode/gdt.asm` file. Since it's not going to be used, we just set the base
and limit sections of the data segment to 0. Everything else doesn't need to change at all.

We can even reuse the code segment that we used in chapter 1.4, and we just need to change 2
bits in order to enable 64-bit mode. In the 2nd flags section, we just need to clear the 
32-bit segment flag and set the 64-bit segment flag. Note that we still need to keep the limit
section set since it'll be used for the last time during the long jump. After we've got our
GDT set up we just load it like in Chapter 1.4 and do a long jump to enable the fully-featured
64-bit mode.

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
