;
; Paging
;
; detect_lm.asm
;

[bits 32]

detect_lm_protected:
    pushad
    
    ; Copy FLAGS to eax via stack
    pushfd
    pop eax

    ; Move to ecx to compare with later
    mov ecx, eax

    ; Flip the ID bit (21st bit of eax)
    xor eax, 1 << 21

    ; Copy eax back to flags via stack
    push eax
    popfd

    ; Now copy flags back to eax
    ; Bit will be flipped if long mode supported
    pushfd
    pop eax

    ; Restore eflags to the older version saved in ecx
    push ecx
    popfd

    ; Perform the comparison
    ; If equal, then the bit got flipped back during copy,
    ; and long mode is not supported
    cmp eax, ecx
    je lm_not_found_protected
    
    ; Return from the function
    popad
    ret

lm_not_found_protected:
    call clear_protected
    mov esi, lm_not_found_str
    jmp $

lm_not_found_str:                   db `Long mode unsupported`, 0