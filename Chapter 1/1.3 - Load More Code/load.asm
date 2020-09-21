;
; Load More Code
;
; load.asm
;

[bits 16]

; Define load_sectors
;   Sector start point in bx
;   Number of sectors to read in cx
;   Destination address in dx
load_bios:
    ; Save the registers
    push ax
    push bx
    push cx
    push dx

    ; Save the number of sectors to read again, since we'll need
    ; to check against this later.
    push cx

    ; For the ATA Read bios utility, the value of ah must be 0x02
    ; See the BIOS article from Chapter 1.2 for more info
    mov ah, 0x02

    ; The number of sectors to read must be in al, but our function
    ; takes it in cl
    mov al, cl

    ; The sector to read from must be in cl, but our function takes it
    ; in bl
    mov cl, bl

    ; The destination address must be in bx, but our function takes it
    ; in dx
    mov bx, dx

    ; Next are the cylinder and cylinder head to read from. You
    ; would need to change these if reading from an actual drive, but with
    ; QEMU they're just 0
    mov ch, 0x00        ; Cylinder goes in ch
    mov dh, 0x00        ; Cylinder head goes in dh

    ; Finally, we want to load the drive to read from in dl. Remember,
    ; we stored this in the boot_drive label
    mov dl, byte[boot_drive]

    ; Perform the BIOS disk read
    ; Use an interrupt to trigger the bios function
    int 0x13

    ; Now comes a slightly weird part. If there's a read error, then the
    ; BIOS function will set the 'carry' bit in the 8086 special register.
    ; We can use the 'jc' command to 'jump if the carry bit is set'. We'll
    ; jump to the error handling function defined below
    jc bios_disk_error

    ; Now, sometimes the BIOS will not read the requested amount, but
    ; will return without error. We need to check the actual read amount
    ; (stored in al). Remember that we saved this twice earlier, so we'll
    ; pop it into bx for comparison
    pop bx
    cmp al, bl
    jne bios_disk_error

    ; If all goes well, we can now print the success message and return
    mov bx, success_msg
    call print_bios

    ; Restore the registers
    pop dx
    pop cx
    pop bx
    pop ax

    ; Return
    ret


bios_disk_error:
    ; Print out the error code and hang, since
    ; the program didn't work correctly
    mov bx, error_msg
    call print_bios

    ; The error code is in ah, so shift it down to mask out al
    shr ax, 8
    mov bx, ax
    call print_hex_bios

    ; Infinite loop to hang
    jmp $

error_msg:              db `\r\nError Loading Sectors: `, 0
success_msg:            db `\r\nAdditional Sectors Loaded Successfully`, 0