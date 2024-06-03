;
; The IDT
;
; isr_defs.asm
;

[bits 64]
[extern common_handler]

save_registers:
    push r15
    push r14
    push r13
    push r12
    push r11
    push r10
    push r9
    push r8
    push rbp
    push rdi
    push rsi
    push rdx
    push rcx
    push rbx
    push rax
    ; TODO: This doesn't work because you push stuff onto the stack. Figure out a workaround
    ret

restore_registers:
    pop rax
    pop rbx
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbp
    pop r8
    pop r9
    pop r10
    pop r11
    pop r12
    pop r13
    pop r14
    pop r15
    ret


%macro ISR_WITH_ERRORCODE 1
global isr_%1
isr_%1:
    cli
    push qword %1
    call save_registers
    call common_handler
    call restore_registers
    sti
    iretq
%endmacro

%macro ISR_WITH_NO_ERRORCODE 1
global isr_%1
isr_%1:
    cli
    push qword 0
    push qword %1
    call save_registers
    call common_handler
    call restore_registers
    iretq
%endmacro

; Add the IRQ definitions
ISR_WITH_NO_ERRORCODE 0
ISR_WITH_NO_ERRORCODE 1
ISR_WITH_NO_ERRORCODE 2
ISR_WITH_NO_ERRORCODE 3
ISR_WITH_NO_ERRORCODE 4
ISR_WITH_NO_ERRORCODE 5
ISR_WITH_NO_ERRORCODE 6
ISR_WITH_NO_ERRORCODE 7
ISR_WITH_ERRORCODE    8
ISR_WITH_NO_ERRORCODE 9
ISR_WITH_ERRORCODE    10
ISR_WITH_ERRORCODE    11
ISR_WITH_ERRORCODE    12
ISR_WITH_ERRORCODE    13
ISR_WITH_ERRORCODE    14
ISR_WITH_NO_ERRORCODE 15
ISR_WITH_NO_ERRORCODE 16
ISR_WITH_ERRORCODE    17
ISR_WITH_NO_ERRORCODE 18
ISR_WITH_NO_ERRORCODE 19
ISR_WITH_NO_ERRORCODE 20
ISR_WITH_NO_ERRORCODE 21
ISR_WITH_NO_ERRORCODE 22
ISR_WITH_NO_ERRORCODE 23
ISR_WITH_NO_ERRORCODE 24
ISR_WITH_NO_ERRORCODE 25
ISR_WITH_NO_ERRORCODE 26
ISR_WITH_NO_ERRORCODE 27
ISR_WITH_NO_ERRORCODE 28
ISR_WITH_NO_ERRORCODE 29
ISR_WITH_ERRORCODE    30
ISR_WITH_NO_ERRORCODE 31
