#ifndef __CPU_ISR
#define __CPU_ISR

#include <types.h>

// Define the ISR's for CPU exceptions
extern void isr_00();
extern void isr_01();
extern void isr_02();
extern void isr_03();
extern void isr_04();
extern void isr_05();
extern void isr_06();
extern void isr_07();
extern void isr_08();
extern void isr_09();
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
    u64_t int_no, errCode;
    u64_t rip, cs, eflags, useresp, ss;
} registers;


// One handler for all ISR's
void isr_handler(registers regs);

#endif