;
; Protected Mode
;
; print.asm
;

[bits 32]

; Simple 32-bit protected print routine
; Message address stored in esi
print_protected:
    pusha
    mov edx, vga_start

    ; Do main loop
    print_protected_loop:
        ; If char == \0, string is done
        cmp byte[esi], 0
        je  print_protected_done

        ; Move character to al, style to ah
        mov al, byte[esi]
        mov ah, style_wb

        ; Print character to vga memory location
        mov word[edx], ax

        ; Increment counter registers
        add esi, 1
        add edx, 2

        ; Redo loop
        jmp print_protected_loop

print_protected_done:
    popa
    ret

; Define necessary constants
vga_start:                  equ 0x000B8000
style_wb:                   equ 0x0F