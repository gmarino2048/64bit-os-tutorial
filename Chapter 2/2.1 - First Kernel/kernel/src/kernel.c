#define VGA_START 0xB8000
#define VGA_EXTENT 80 * 25

#define STYLE_WB 0x0F

typedef struct __attribute__((packed)) {
    char character;
    char style;
} vga_char;

int main(){
    vga_char *text_area = (vga_char*) VGA_START;
    vga_char test = {
        'H',
        STYLE_WB
    };

    text_area[0] = test;
    return 0;
}