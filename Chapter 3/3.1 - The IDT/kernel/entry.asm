[bits 64]
[extern main]

global _start

section .startup
_start:
    call main
    jmp $