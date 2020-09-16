# The Magic Number

The magic number is the most important part of the
bootloader. Without it, the BIOS would have no idea
which drives it could (and could not) load from. This
could potentially lead to data corruption or loss, or
even potential hardware failure.

## 0xAA55

To prevent this, the BIOS looks for `0xAA55` at the
end of the boot sector. A "sector" is defined by the
BIOS as the first 512 bytes of each drive. This means
that we only have 512 bytes to store all our bootloader
code! Obviously, a modern bootloader is more complex
than that, but we'll figure that out later.

## Building

Before we get started, make sure you can build the
`boot.asm` example. You should be able to do so using
the command:

```sh
nasm boot.asm
```

Next, you should be able to load the example into
QEMU and run it with the following command:

```sh
qemu-system-x86_64 -drive format=raw,file=boot
```

It won't do much to begin with, but that's alright!
As long as QEMU doesn't crash and the screen isn't
flickering, then the bootloader is working as
expected. When you finish writing yours, it should
look the same.

## First Boot

For now, our bootloader will be the simplest program
known to man: the infinite loop. There are a few
special characters in NASM that we can make use of
here: `$` and `$$`.

In NASM, `$` is replaced with the address of the
**current instruction** at assemble time. Similarly,
`$$` is replaced with the address of the **previous
instruction**.

Before you move on, try implementing this simple boot
sector yourself. See if you can get it working with the
magic number too.

This means that to make an infinite loop, we can just
use the simple instruction

```asm
jmp $
```

(or jump to current instruction) as our only
instruction. Then, we'll need to pad the rest of our
boot sector and write the magic number.

## Raw Data

In order to get the magic number working, we'll need
to be able to write raw data directly to the file.
There are a few functions in NASM to do this:

* `db` (Define Byte)
* `dw` (Define Word)
* `dd` (Define Doubleword)
* `dq` (Define Quadword)

These functions will write raw data with length 8,
16, 32, and 64 bits, respectively. (This is also
1, 2, 4, and 8 bytes). Since the magic number is 16
bits long, we'll use `dw` to define it:

```asm
dw 0xAA55
```

Now, we'll need to pad the rest of the file with zero
bytes to make sure that our magic number is the last two
bytes of the boot sector. You may find the 
[times](https://nasm.us/doc/nasmdoc3.html) command 
especially useful for this. If you get stuck, there's a
detailed explanation in the source file, so just look
there!

Good Luck!
