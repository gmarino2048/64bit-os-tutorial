;
; Paging
;
; init_pt.asm
;

;
; Initialize the page table
; 
; The Page Table has 4 components which will be mapped as follows:
;
; PML4T -> 0x1000
; PDPT  -> 0x2000
; PDT   -> 0x3000
; PT    -> 0x4000
;
; Clear the memory in those areas and then set up the page structure
; 

[bits 32]

init_pt_protected:
    pushad

    ; Clear the memory area
    mov edi, 0x1000
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd
    mov edi, cr3

    ; Set up the first entry of each page
    mov dword[edi], 0x2003
    add edi, 0x1000
    mov dword[edi], 0x3003
    add edi, 0x1000
    mov dword[edi], 0x4003

    ; Fill in the final page
    ; NOTE: edi is at 0x3000
    add edi, 0x1000
    mov ebx, 0x00000003
    mov ecx, 512

    add_page_entry_protected:
        mov dword[edi], ebx
        add ebx, 0x1000
        add edi, 8
        loop add_page_entry_protected

    popad
    ret