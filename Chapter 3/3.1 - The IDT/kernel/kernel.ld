ENTRY(_start);

SECTIONS {
    . = 0x8200;

    .startup : {
        _start = .;
        *(.startup)
    }

    .text : { *(.text) }

    .rodata : { *(.rodata) }

    .data : { *(.data) }

    .bss : { *(.bss) }
}