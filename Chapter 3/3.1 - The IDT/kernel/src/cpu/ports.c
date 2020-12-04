
#include <cpu/ports.h>

u8_t byte_in(u16_t port){
    // We're using inline assembly to read from the port

    // "=a" (result) means to put value of rax in result
    // "d" (port) means put value of port in dx

    // asm instructions use the form "command" : "output" : "input"
    // Use the "in" assembly command to read from a port
    u8_t result;
    __asm__ volatile ("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}


void byte_out(u16_t port, u8_t data){
    // Use the "out" command to write to a port
    __asm__ volatile ("out %%al, %%dx" : : "a" (data), "d" (port));
}