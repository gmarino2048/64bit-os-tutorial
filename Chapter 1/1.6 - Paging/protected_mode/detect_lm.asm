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
    ; and CPUID is not supported
    cmp eax, ecx
    je lm_not_found_protected

    ; Check for extended functions of CPUID
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb lm_not_found_protected

    ; Actually check for long mode
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz lm_not_found_protected
    
    ; Return from the function
    popad
    ret

cpuid_not_found_protected:
    call clear_protected
    mov esi, cpuid_not_found_str
    call print_protected
    jmp $

lm_not_found_protected:
    call clear_protected
    mov esi, lm_not_found_str
    call print_protected
    jmp $

lm_not_found_str:                   db `Long mode not supported. Exiting...`, 0
cpuid_not_found_str:                db `CPUID unsupported, but required for long mode`, 0