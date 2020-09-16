;
; Hello, BIOS
;
; boot.asm
;

jmp $               ; Infinite loop

; Pad boot sector for magic number
times 510 - ($ - $$) db 0x00

; Magic number
dw 0xAA55