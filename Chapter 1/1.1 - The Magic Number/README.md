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
than that, but we'll get to that later.

## First Boot

For now, our bootloader will be the simplest program
known to man: the infinite loop. There are a few
special characters in NASM that we can make use of
here: `$` and `$$`.

In NASM, `$` is replaced with the address of the
**current instruction** at assemble time. Similarly,
`$$` is replaced with the address of the **previous
instruction**. This means that to make an infinite
loop, we can just use the simple instruction

```asm
jmp $
```

(or jump to current instruction) as our only
instruction.