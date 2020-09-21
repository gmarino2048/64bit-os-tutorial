;
; Load More Code
;
; boot.asm
;

; Set Program Origin
[org 0x7C00]

; 16-bit Mode
[bits 16]

; Print Message
mov bx, msg_hello_world
call print_bios

; Infinite Loop
bootsector_hold:
jmp $               ; Infinite loop

; INCLUDES
%include "print.asm"

; DATA STORAGE AREA

; String Message
msg_hello_world:                db `\r\nHello World, from the BIOS!\r\n`, 0

; Pad boot sector for magic number
times 510 - ($ - $$) db 0x00

; Magic number
dw 0xAA55