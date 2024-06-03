
#include <cpu/isr.h>

#include <cpu/idt.h>
#include <driver/vga.h>

static const char *interrupt_descriptions[32] = {
    "Divide Error",
    "Debug",
    "NMI Interrupt",
    "Breakpoint",
    "Overflow",
    "BOUND Range Exceeded",
    "Invalid Opcode (Undefined Opcode)",
    "Device Not Available (No Math Coprocessor)",
    "Double Fault",

    "Coprocessor Segment Overrun",
    "Invalid TSS",
    "Segment Not Present",
    "Stack Segment Fault",
    "General Protection",
    "Page Fault",
    "Reserved",
    "Floating-Point Error (Math Fault)",
    "Alignment Check",
    "Machine Check",
    "SIMD Floating-Point Exception",
    "Virtualization Exception",
    "Control Protection Exception",

    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved",
    "Reserved"
};

void common_handler(interrupt_stack_frame stack_frame) {
    u8_t interrupt_no = stack_frame.int_no;

    putstr("Interrupt Received: ", COLOR_WHT, COLOR_RED);
    putstr(interrupt_descriptions[interrupt_no], COLOR_WHT, COLOR_RED);
}

void setup_idt_gates() {
    set_idt_gate(0, (u64_t) isr_0);
    set_idt_gate(1, (u64_t) isr_1);
    set_idt_gate(2, (u64_t) isr_2);
    set_idt_gate(3, (u64_t) isr_3);
    set_idt_gate(4, (u64_t) isr_4);
    set_idt_gate(5, (u64_t) isr_5);
    set_idt_gate(6, (u64_t) isr_6);
    set_idt_gate(7, (u64_t) isr_7);
    set_idt_gate(8, (u64_t) isr_8);
    set_idt_gate(9, (u64_t) isr_9);
    set_idt_gate(10, (u64_t) isr_10);
    set_idt_gate(11, (u64_t) isr_11);
    set_idt_gate(12, (u64_t) isr_12);
    set_idt_gate(13, (u64_t) isr_13);
    set_idt_gate(14, (u64_t) isr_14);
    set_idt_gate(15, (u64_t) isr_15);
    set_idt_gate(16, (u64_t) isr_16);
    set_idt_gate(17, (u64_t) isr_17);
    set_idt_gate(18, (u64_t) isr_18);
    set_idt_gate(19, (u64_t) isr_19);
    set_idt_gate(20, (u64_t) isr_20);
    set_idt_gate(21, (u64_t) isr_21);
    set_idt_gate(22, (u64_t) isr_22);
    set_idt_gate(23, (u64_t) isr_23);
    set_idt_gate(24, (u64_t) isr_24);
    set_idt_gate(25, (u64_t) isr_25);
    set_idt_gate(26, (u64_t) isr_26);
    set_idt_gate(27, (u64_t) isr_27);
    set_idt_gate(28, (u64_t) isr_28);
    set_idt_gate(29, (u64_t) isr_29);
    set_idt_gate(30, (u64_t) isr_30);
    set_idt_gate(31, (u64_t) isr_31);
}
