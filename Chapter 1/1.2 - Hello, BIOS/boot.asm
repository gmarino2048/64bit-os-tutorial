;
; Hello, BIOS
;
; boot.asm
;

; We didn't cover this last time because we didn't do any jumping,
; but the BIOS doesn't load the boot sector at instruction 0. Instead,
; it's loaded to 0x7C00. NASM doesn't know this though, so we need to
; tell it where the program origin is with the 'org' metacommand.
[org 0x7C00]

; All x86-type chips start in 16-bit "real mode", which
; enables backwards compatibility all the way to the Intel 8086 chip.
; Yes, even the 64-bit variants have this ability, it's just not
; commonly used. So, we'll need to tell NASM to generate 16 bit instructions.
[bits 16]

; Check out the print.asm code for the full print function. We want to store
; the pointer to the displayed string in bx, so we use the data label to do
; so. Then, we call the print function, which displays the text to the screen.
mov bx, msg_hello_world
call print_bios

; We use labels to jump to certain points in the program.
; These are not instructions, but instead are converted into
; instruction addresses at assemble time.
bootsector_hold:
jmp $               ; Infinite loop

; UTILITY FUNCTION AREA

; NASM allows us to store different parts of a program in different files,
; and include them. This helps keep our files from becoming needlessly
; cluttered. The '%include' directive works exactly like the one in C and
; C++, and just copies the content of the files verbatim.
%include "print.asm"

; DATA STORAGE AREA

; Once again, another label for our data. Since we'll need to access
; This string, we assign a label to it. Also, in NASM, the backtick '`'
; character allows C-style escapes, like '\r' or '\n' or '\t'. Finally,
; we need to know when our string stops, so we add a null terminator (or
; a zero byte at the end of the string)
msg_hello_world:                db `\r\nHello World, from the BIOS!\r\n`, 0

; Pad boot sector for magic number
times 510 - ($ - $$) db 0x00

; Magic number
dw 0xAA55