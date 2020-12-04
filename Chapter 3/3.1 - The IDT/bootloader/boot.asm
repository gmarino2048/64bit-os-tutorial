;
; Long Mode
;
; boot.asm
;

; Set Program Origin
[org 0x7C00]

; 16-bit Mode
[bits 16]

; Initialize the base pointer and the stack pointer
; The initial values should be fine for what we've done so far,
; but it's better to do it explicitly
mov bp, 0x0500
mov sp, bp

; Before we do anything else, we want to save the ID of the boot
; drive, which the BIOS stores in register dl. We can offload this
; to a specific location in memory
mov byte[boot_drive], dl

; Print Message
mov bx, msg_hello_world
call print_bios

; Load the next sector

; The first sector's already been loaded, so we start with the second sector
; of the drive. Note: Only bl will be used
mov bx, 0x0002

; Now we want to load 3 sectors for the bootloader and kernel
mov cx, 0x000A

; Finally, we want to store the new sector immediately after the first
; loaded sector, at adress 0x7E00. This will help a lot with jumping between
; different sectors of the bootloader.
mov dx, 0x7E00

; Now we're fine to load the new sectors
call load_bios

; And elevate our CPU to 32-bit mode
call elevate_bios

; Infinite Loop
bootsector_hold:
jmp $               ; Infinite loop

; INCLUDES
%include "real_mode/print.asm"
%include "real_mode/print_hex.asm"
%include "real_mode/load.asm"
%include "real_mode/gdt.asm"
%include "real_mode/elevate.asm"

; DATA STORAGE AREA

; String Message
msg_hello_world:                db `\r\nHello World, from the BIOS!\r\n`, 0

; Boot drive storage
boot_drive:                     db 0x00

; Pad boot sector for magic number
times 510 - ($ - $$) db 0x00

; Magic number
dw 0xAA55


; BEGIN SECOND SECTOR. THIS ONE CONTAINS 32-BIT CODE ONLY

bootsector_extended:
begin_protected:

[bits 32]

; Clear vga memory output
call clear_protected

; Detect long mode
; This function will return if there's no error
call detect_lm_protected

; Test VGA-style print function
mov esi, protected_alert
call print_protected

; Initialize the page table
call init_pt_protected

call elevate_protected

jmp $       ; Infinite Loop

; INCLUDE protected-mode functions
%include "protected_mode/clear.asm"
%include "protected_mode/print.asm"
%include "protected_mode/detect_lm.asm"
%include "protected_mode/init_pt.asm"
%include "protected_mode/gdt.asm"
%include "protected_mode/elevate.asm"

; Define necessary constants
vga_start:                  equ 0x000B8000
vga_extent:                 equ 80 * 25 * 2             ; VGA Memory is 80 chars wide by 25 chars tall (one char is 2 bytes)
style_wb:                   equ 0x0F

; Define messages
protected_alert:                 db `64-bit long mode supported`, 0

; Fill with zeros to the end of the sector
times 512 - ($ - bootsector_extended) db 0x00
begin_long_mode:

[bits 64]

mov rdi, style_blue
call clear_long

mov rdi, style_blue
mov rsi, long_mode_note
call print_long

call kernel_start

jmp $

%include "long_mode/clear.asm"
%include "long_mode/print.asm"

kernel_start:                   equ 0x8200              ; Kernel is at 1MB
long_mode_note:                 db `Now running in fully-enabled, 64-bit long mode!`, 0
style_blue:                     equ 0x1F

times 512 - ($ - begin_long_mode) db 0x00