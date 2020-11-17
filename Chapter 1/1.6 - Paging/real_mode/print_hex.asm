;
; Protected Mode
;
; print_hex.asm
;

[bits 16]

; Define Function print_hex_bios
; Input in bx
print_hex_bios:
    ; Save state
    push ax
    push bx
    push cx

    ; Enable print mode
    mov ah, 0x0E

    ; Print prefix
    mov al, '0'
    int 0x10
    mov al, 'x'
    int 0x10

    ; Initialize cx as counter
    ; 4 nibbles in 16-bits
    mov cx, 4

    ; Begin loop
    print_hex_bios_loop:
        ; If cx==0 goto end
        cmp cx, 0
        je print_hex_bios_end

        ; Save bx again
        push bx

        ; Shift so upper four bits are lower 4 bits
        shr bx, 12

        ; Check to see if ge 10
        cmp bx, 10
        jge print_hex_bios_alpha

            ; Byte in bx now < 10
            ; Set the zero char in al, add bl
            mov al, '0'
            add al, bl

            ; Jump to end of loop
            jmp print_hex_bios_loop_end

        print_hex_bios_alpha:
            
            ; Bit is now greater than or equal to 10
            ; Subtract 10 from bl to get add amount
            sub bl, 10
            
            ; Move 'A' to al and add bl
            mov al, 'A'
            add al, bl


        print_hex_bios_loop_end:

        ; Print character
        int 0x10

        ; Restore bx
        ; Shift to next 4 bits
        pop bx
        shl bx, 4

        ; Decrement cx counter
        dec cx

        ; Jump to beginning of loop
        jmp print_hex_bios_loop

print_hex_bios_end:
    ; Restore state
    pop cx
    pop bx
    pop ax

    ; Jump to calling point
    ret