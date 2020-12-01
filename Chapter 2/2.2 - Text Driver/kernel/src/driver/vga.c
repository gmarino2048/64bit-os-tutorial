
#include <cpu/ports.h>
#include <driver/vga.h>


volatile vga_char *TEXT_AREA = (vga_char*) VGA_START;


u8_t vga_color(u8_t fg_color, u8_t bg_color){
    // Put bg color in the higher 4 bits and mask those of fg
    return (bg_color << 4) | (fg_color & 0x0F);
}


void clearwin(u8_t color){
    const char space = ' ';
    u8_t clear_color = vga_color(COLOR_BLK, color);

    const vga_char clear_char = {
        .character = space,
        .style = clear_color
    };

    for(u64_t i = 0; i < VGA_EXTENT; i++) {
        TEXT_AREA[i] = clear_char;
    }
}


void hide_cursor(){
    byte_out(CURSOR_PORT_COMMAND, 0x0A);
    byte_out(CURSOR_PORT_DATA, 0x20);
}


void set_cursor_pos(u8_t x, u8_t y){
    u16_t pos = x + ((u16_t) VGA_WIDTH * y);

    byte_out(CURSOR_PORT_COMMAND, 0x0F);
    byte_out(CURSOR_PORT_DATA, (u8_t) (pos & 0xFF));

    byte_out(CURSOR_PORT_COMMAND, 0x0E);
    byte_out(CURSOR_PORT_DATA, (u8_t) ((pos >> 8) & 0xFF));
}