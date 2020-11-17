;
; Protected Mode
;
; print.asm
;

[bits 16]

; Define function print_bios
; Input pointer to string in bx
print_bios:
    ; Save state
    push ax
    push bx

    ; Enter Print Mode
    mov ah, 0x0E


    print_bios_loop:

        ; Null Check
        cmp byte[bx], 0
        je print_bios_end

        ; Print Character
        mov al, byte[bx]
        int 0x10

        ; Increment pointer and reenter loop
        inc bx
        jmp print_bios_loop


; End of print_bios
print_bios_end:

    ; Restore State
    pop bx
    pop ax

    ; Jump to last instruction
    ret