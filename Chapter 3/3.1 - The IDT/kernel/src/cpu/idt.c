#include <cpu/idt.h>

// Provide definitions for our extern values
idt_gate main_idt[IDT_ENTRIES];
idt_register main_idt_reg;


// Implement set_idt
void set_idt(){
    main_idt_reg.base = (u64_t) &main_idt;
    main_idt_reg.limit = (IDT_ENTRIES * sizeof(idt_gate)) - 1;

    // Load the value of &main_idt_reg (pointer to IDT register)
    __asm__ volatile ("lidt (%0)" : : "r" (&main_idt_reg));
}


// Implement set_idt_gate
void set_idt_gate(u8_t gate_number, u64_t handler_address){
    u16_t low_16 = (u16_t) (handler_address & 0xFFFF);
    u16_t middle_16 = (u16_t) ((handler_address >> 16) & 0xFFFF);
    u32_t high_32 = (u32_t) ((handler_address >> 32) & 0xFFFFFFFF);

    idt_gate gate = {
        .base_low = low_16,
        .cs_selector = KERNEL_CS,
        .zero = 0,
        .attributes = INT_ATTR,
        .base_middle = middle_16,
        .base_high = high_32,
        .reserved = 0
    };

    main_idt[gate_number] = gate;
}
