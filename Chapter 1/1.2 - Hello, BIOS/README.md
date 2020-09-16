# Hello, BIOS

## Building

```sh
nasm boot.asm
```

```sh
qemu-system-x86_64 -drive format=raw,file=boot
```