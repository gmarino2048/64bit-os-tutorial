
#include <driver/vga.h>

int main() {
    set_cursor_pos(0, 0);
    clearwin(COLOR_BLK, COLOR_YEL);

    const char *first = "Our driver can now handle special characters.\n";

    putstr(first, COLOR_BLK, COLOR_YEL);

    const char *second = "Like tab \t and newline.\n";

    putstr(second, COLOR_BLK, COLOR_YEL);
    
    return 0;
}