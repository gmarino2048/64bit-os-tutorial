# Paging

## Detecting Long Mode

## Setting up the Page Table

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
