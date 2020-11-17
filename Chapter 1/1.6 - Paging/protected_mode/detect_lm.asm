;
; Paging
;
; detect_lm.asm
;

[bits 32]

; Detecting Long Mode
;
; Long mode is supported on all 64-bit CPUs, but not
; on 32-bit CPUs. However, since we've been in protected
; mode, we have no idea which type of system we're running
; on. We need to figure out if we can even use long mode so
; that we don't cause a ton of errors when trying to activate
; it.
detect_lm_protected:
    pushad

    ; In order to detect long mode, we need to use the built-in command
    ; "cpuid". However, CPUID has different modes, and some CPUS don't
    ; support the additional functionalities to check for long mode, even
    ; if they support CPUID. So this makes the check for long mode way more
    ; convoluted than it needs to be. Once again, the steps are:
    ;
    ; 1. Check for CPUID
    ; 2. Check for CPUID extended functions
    ; 3. Check for long mode support
    

    ; Checking for CPUID
    ;
    ; We can check for the existence of CPUID by using a bit in the
    ; FLAGS register. This register cannot be accessed by the mov command,
    ; so we must actually push it onto the stack and pop it off to read or
    ; write to it.
    ;
    ; The bit that tells us if CPUID is supported is bit 21. IF CPUID is
    ; NOT supported, then this bit MUST take on a certain value. However,
    ; if CPUID is supported, then it'll take on whatever value we give it.
    ; We can try this by reading from FLAGS, flipping the bit, writing to
    ; FLAGS, and then reading again and comparing to the earlier read. If
    ; they're equal, then the bit is 0

    ; Read from FLAGS
    pushfd                          ; Copy FLAGS to eax via stack
    pop eax

    ; Save to ecx for comparison later
    mov ecx, eax

    ; Flip the ID bit (21st bit of eax)
    xor eax, 1 << 21

    ; Write to FLAGS
    push eax
    popfd

    ; Read from FLAGS again
    ; Bit will be flipped if CPUID supported
    pushfd
    pop eax

    ; Restore eflags to the older version saved in ecx
    push ecx
    popfd

    ; Perform the comparison
    ; If equal, then the bit got flipped back during copy,
    ; and CPUID is not supported
    cmp eax, ecx
    je cpuid_not_found_protected        ; Print error and hang if CPUID unsupported


    ; Check for extended functions of CPUID
    ;
    ; Now that we know CPUID exists, we can use it to
    ; see whether it supports the extended functions needed
    ; to enable long mode. The CPUID function takes an argument
    ; in eax and returns the value in eax. To check for extended
    ; capabilities, we use the argument mov eax, 0x80000000. If
    ; extended capabilities exist, then the value will be set to
    ; greater than 0x80000000, otherwise it will stay the same.
    mov eax, 0x80000000             ; CPUID argument than 0x80000000
    cpuid                           ; Run the command
    cmp eax, 0x80000001             ; See if result is larger than than 0x80000001
    jb cpuid_not_found_protected    ; If not, error and hang


    ; Actually check for long mode
    ;
    ; Now, we can use CPUID to check for long mode. If long mode is
    ; supported, then CPUID will set the 29th bit of register edx. The
    ; eax code to look for long mode is 0x80000001
    mov eax, 0x80000001             ; Set CPUID argument
    cpuid                           ; Run CPUID
    test edx, 1 << 29               ; See if bit 29 set in edx
    jz lm_not_found_protected       ; If it is not, then error and hang
    
    ; Return from the function
    popad
    ret

;
; Print an error message and hang
;
cpuid_not_found_protected:
    call clear_protected
    mov esi, cpuid_not_found_str
    call print_protected
    jmp $

;
; Print an error message and hang
;
lm_not_found_protected:
    call clear_protected
    mov esi, lm_not_found_str
    call print_protected
    jmp $

lm_not_found_str:                   db `ERROR: Long mode not supported. Exiting...`, 0
cpuid_not_found_str:                db `ERROR: CPUID unsupported, but required for long mode`, 0