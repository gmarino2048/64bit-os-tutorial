;
; The IDT
;
; isr.asm
;

%macro PUSHALL 0
    push rax
    push rbx
    push rcx
    push rdx
    push rsp
    push rbp
    push rsi
    push rdi
%endmacro

%macro POPALL 0
    pop rdi
    pop rsi
    pop rbp
    pop rsp
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro


; Load the interrupt handler
[extern isr_handler]


; ISR common stub which all routines jump back to
isr_common:
    PUSHALL

    ; Save CPU State
    mov ax, ds
    push rax

    ; Set the segdefs to kernel segment descriptor
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Call the isr handler
    call isr_handler

    pop rax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    POPALL

    add rsp, 8          ; Removes the pushed error code and ISR number
    sti
    iretq


%macro ISR_NOERRCODE 1
  global isr_%1
  isr_%1:
    cli
    push byte 0
    push byte %1
    jmp isr_common
%endmacro

%macro ISR_ERRCODE 1
  global isr_%1
  isr_%1:
    cli
    push byte %1
    jmp isr_common
%endmacro

ISR_NOERRCODE 0
ISR_NOERRCODE 1
ISR_NOERRCODE 2
ISR_NOERRCODE 3
ISR_NOERRCODE 4
ISR_NOERRCODE 5
ISR_NOERRCODE 6
ISR_NOERRCODE 7
ISR_ERRCODE   8
ISR_NOERRCODE 9
ISR_ERRCODE   10
ISR_ERRCODE   11
ISR_ERRCODE   12
ISR_ERRCODE   13
ISR_ERRCODE   14
ISR_NOERRCODE 15
ISR_NOERRCODE 16
ISR_NOERRCODE 17
ISR_NOERRCODE 18
ISR_NOERRCODE 19
ISR_NOERRCODE 20
ISR_NOERRCODE 21
ISR_NOERRCODE 22
ISR_NOERRCODE 23
ISR_NOERRCODE 24
ISR_NOERRCODE 25
ISR_NOERRCODE 26
ISR_NOERRCODE 27
ISR_NOERRCODE 28
ISR_NOERRCODE 29
ISR_NOERRCODE 30
ISR_NOERRCODE 31