
#include <driver/vga.h>

int main() {
    set_cursor_pos(0, 0);
    clearwin(COLOR_BLK, COLOR_CYN);

    const char *welcome = "Now we have a more advanced vga driver that does what we want!";

    putstr(welcome, COLOR_BLK, COLOR_CYN);
    
    return 0;
}