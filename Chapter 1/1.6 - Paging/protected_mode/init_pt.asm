;
; Paging
;
; init_pt.asm
;

; Initialize the page table
; 
; The Page Table has 4 components which will be mapped as follows:
;
; PML4T -> 0x1000 (Page Map Level 4 Table)
; PDPT  -> 0x2000 (Page Directory Pointer Table)
; PDT   -> 0x3000 (Page Directory Table)
; PT    -> 0x4000 (Page table)
;
; Clear the memory in those areas and then set up the page table structure

; Each table in the page table has 512 entries, all of which are 8 bytes
; (one quadword or 64 bits) long. In this step we'll be identity mapping
; ONLY the lowest 2 MB of memory, since this is all we need for now. Note
; that this only requires one page table, so the upper 511 entries in the
; PML4T, PDPT, and PDT will all be NULL.

; Once we have the zeroth address in all pointing to our page table, we
; will need to create a identity map, which will point each virtual page
; to the physical page accessed with that address. Note that in the x86_64
; architecture, a page is addressed using 12 bits, which corresponds to
; 4096 addressible bytes (4KB). Remember this, it'll be important later.

; Another thing to note is that we're in protected mode now, which grants
; us access to fancy CISC instructions like rep, stosd, and loop. I'll
; explain what each of these do a bit later in the file.

[bits 32]

init_pt_protected:
    pushad

    ; NOTE: We did not set up 32-bit paging because we wanted to jump directly
    ; into long mode. You should know that this is possible, and if you've done
    ; it before entering long mode you will need to disable it here. To do so,
    ; clear the 31st bit of the cr0 register.

    ; Clear the memory area using rep stosd
    ;
    ; rep stosd is what's known as a "repeating string command", meaning that it
    ; will write the same thing over and over until a certain criteria is met.
    ; How does it know when to stop though? We tell it with the eax, edi, and ecx
    ; registers. eax is the value to write, edi is the start address, and ecx is the
    ; number of repetitions to perform.
    ;
    ; Even the instruction has significance. The 'd' at the end of 'stosd' tells the
    ; cpu to write a "double word" or 4 bytes with each repetition (the same size as eax).
    ; It also increments edi by 4 rather than by 1 to ensure no data overlap. So let's
    ; get into the function then:
    mov edi, 0x1000         ; Set the base address for rep stosd. Our page table goes from
                            ; 0x1000 to 0x4FFF, so we want to start at 0x1000

    mov cr3, edi            ; Save the PML4T start address in cr3. This will save us time later
                            ; because cr3 is what the CPU uses to locate the page table entries

    xor eax, eax            ; Set eax to 0. Note that xor is actually faster than "mov eax, 0".

    mov ecx, 4096           ; Repeat 4096 times. Since each page table is 4096 bytes, and we're
                            ; writing 4 bytes each repetition, this will zero out all 4 page tables

    rep stosd               ; Now actually zero out the page table entries

    ; Set edi back to PML4T[0]
    mov edi, cr3

    ; Set up the first entry of each table
    ;
    ; This part can be a little confusing, and it took me a while to understand.
    ; The key is knowing that the page tables MUST be page aligned. This means
    ; the lower 12 bits of the physical address (3 hex digits) MUST be 0. Then,
    ; each page table entry can use the lower 12 bits as flags for that entry.
    ;
    ; You may notice that we're setting our flags to "0x003", because we care most
    ; about bits 0 and 1. Bit 0 is the "exists" bit, and is only set if the entry
    ; corresponds to another page table (for the PML4T, PDPT, and PDT) or a page of
    ; physical memory (in the PT). Obviously we want to set this. Bit 1 is the
    ; "read/write" bit, which allows us to view and modify the given entry. Since we
    ; want our OS to have full control, we'll set this as well.
    ;
    ; Now let's wire up our table. Note that edi is already at PML4T[0]
    mov dword[edi], 0x2003      ; Set PML4T[0] to address 0x2000 (PDPT) with flags 0x0003
    add edi, 0x1000             ; Go to PDPT[0]
    mov dword[edi], 0x3003      ; Set PDPT[0] to address 0x3000 (PDT) with flags 0x0003
    add edi, 0x1000             ; Go to PDT[0]
    mov dword[edi], 0x4003      ; Set PDT[0] to address 0x4000 (PT) with flags 0x0003

    ; Fill in the final page table
    ; NOTE: edi is at 0x3000
    ;
    ; We now want to make an Identity Mapping in our PT. We still want to have the flags
    ; set to 0x0003 as shown above, but we want to set PT[0].addr to 0x00, PT[1].addr to
    ; 0x01, etc. We'll do this using the "loop" command. In 16 bit mode, we had to program
    ; loops ourselves using comparison operators, but now we can just use a single command.
    ;
    ; The "loop" command is essentially equivalent to the following pseudocode:
    ; while (ecx > 0){
    ;   {instructions}
    ;   ecx --
    ; }
    ; Or, more simply: "Do {instructions} ecx times, and decrement ecx each time".
    ; We can use this loop command to fill in all 512 entries of the page table as follows:
    add edi, 0x1000             ; Go to PT[0]
    mov ebx, 0x00000003         ; EBX has address 0x0000 with flags 0x0003
    mov ecx, 512                ; Do the operation 512 times

    add_page_entry_protected:
        ; a = address, x = index of page table, flags are entry flags
        mov dword[edi], ebx                 ; Write ebx to PT[x] = a.append(flags)
        add ebx, 0x1000                     ; Increment address of ebx (a+1)
        add edi, 8                          ; Increment page table location (since entries are 8 bytes)
                                            ; x++
        loop add_page_entry_protected       ; Decrement ecx and loop again

    ; Set up PAE paging, but don't enable it quite yet
    ;
    ; Here we're basically telling the CPU that we want to use paging, but not quite yet.
    ; We're enabling the feature, but not using it.
    mov eax, cr4
    or eax, 1 << 5               ; Set the PAE-bit, which is the 5th bit
    mov cr4, eax

    ; Now we should have a page table that identities maps the lowest 2MB of physical memory into
    ; virtual memory!
    popad
    ret
