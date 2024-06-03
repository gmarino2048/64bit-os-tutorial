[bits 64]
[extern main]

section .text
global _start
_start:
    call main
    jmp $