#ifndef __CPU_ISR
#define __CPU_ISR

#include <types.h>

// Define the ISR's for CPU exceptions
extern void isr_0();
extern void isr_1();
extern void isr_2();
extern void isr_3();
extern void isr_4();
extern void isr_5();
extern void isr_6();
extern void isr_7();
extern void isr_8();
extern void isr_9();
extern void isr_10();
extern void isr_11();
extern void isr_12();
extern void isr_13();
extern void isr_14();
extern void isr_15();
extern void isr_16();
extern void isr_17();
extern void isr_18();
extern void isr_19();
extern void isr_20();
extern void isr_21();
extern void isr_22();
extern void isr_23();
extern void isr_24();
extern void isr_25();
extern void isr_26();
extern void isr_27();
extern void isr_28();
extern void isr_29();
extern void isr_30();
extern void isr_31();


// Function to install the ISR's to the IDT and
// load the IDT to the CPU
void isr_install();


// Structure to push registers when saving for ISR
typedef struct {
    u64_t ds;
    u64_t rdi, rsi, rbp, rsp, rdx, rcx, rbx, rax;
    u64_t int_no, err_code;
    u64_t rip, cs, eflags, useresp, ss;
} registers;


// One handler for all ISR's
void isr_handler(registers regs);

#endif