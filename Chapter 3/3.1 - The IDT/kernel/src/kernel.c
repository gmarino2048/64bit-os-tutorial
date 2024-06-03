
#include <cpu/isr.h>
#include <driver/vga.h>

int main() {
    isr_install();

    set_cursor_pos(0, 0);
    clearwin(COLOR_GRN, COLOR_BLK);

    const char *first = "\n\n\n\nWe can now handle some special characters.";

    putstr(first, COLOR_GRN, COLOR_BLK);

    const char *second = "\nLike tab \t and newline.";

    putstr(second, COLOR_GRN, COLOR_BLK);

    const char *third = "\nAnd it scrolls!";
    for (u16_t i = 0; i < 18; i++){
        putstr(third, COLOR_GRN, COLOR_BLK);
    }

    putstr("\nThis interrupt is most likely NOT a double-fault,\n", COLOR_GRN, COLOR_BLK);
    putstr("but a problem with us not remapping the timer IRQ from the PIC,\n", COLOR_GRN, COLOR_BLK);
    putstr("so it shows up on Channel 8\n", COLOR_GRN, COLOR_BLK);

    return 0;
}