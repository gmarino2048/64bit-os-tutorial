;
; Protected Mode
;
; elevate.asm
;

[bits 16]

; This function will raise our CPU to the 32-bit protected mode
elevate_bios:
    ; We need to disable interrupts because elevating to 32-bit mode
    ; causes the CPU to go a little crazy. We do this with the 'cli'
    ; command
    cli

    ; 32-bit protected mode requires the GDT, so we tell the CPU where
    ; it is with the 'lgdt' command
    lgdt [gdt_32_descriptor]

    ; Enable 32-bit mode by setting bit 0 of the original control
    ; register. We cannot set this directly, so we need to copy the
    ; contents into eax (32-bit version of ax) and back again
    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    ; Now we need to clear the pipeline of all 16-bit instructions,
    ; which we do with a far jump. The address doesn't actually need to
    ; be far away, but the type of jump needs to be specified as 'far'
    jmp code_seg:init_pm

    [bits 32]
    init_pm:

    ; Congratulations! You're now in 32-bit mode!
    ; There's just a bit more setup we need to do before we're ready
    ; to actually execute instructions

    ; We need to tell all segment registers to point to our flat-mode data
    ; segment. If you're curious about what all of these do, you might want
    ; to look on the OSDev Wiki. We will not be using them enough to matter.
    mov ax, data_seg
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Since the stack pointers got messed up in the elevation process, and we
    ; want a fresh stack, we need to reset them now.
    mov ebp, 0x90000
    mov esp, ebp

    ; Go to the second sector with 32-bit code
    jmp begin_protected