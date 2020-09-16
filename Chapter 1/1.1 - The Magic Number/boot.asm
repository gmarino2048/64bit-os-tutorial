;
; The Magic Number
;


; In NASM, the '$' character refers to the
; current command, while '$$' refers to the previous
; command.

jmp $                   ; Jump to the current instruction, aka infinite loop


; The magic number must come at the end of the boot
; sector. We need to fill the space with zeros to ensure that
; the magic number comes at the end. Remember, since the magic
; number is 2 bytes, the rest of the boot sector is 510.

; We use the 'times' command to repeat the 'db' or "define byte" command
; to pad the rest. Remeber, we will use the '$' and '$$' commands to 
; determine how much space is left sin

times 510 - ($ - $$) db 0x00

; The 'dw' command stands for "define word", and puts
; a 16-bit literal integer at that specific location in the file.
; We use 'dw' here to define the magic number, 'AA55'
dw 0xAA55