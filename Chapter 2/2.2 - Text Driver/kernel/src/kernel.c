#define VGA_START 0xB8000
#define VGA_EXTENT 80 * 25

#define STYLE_WB 0x0F

typedef struct __attribute__((packed)) {
    char character;
    char style;
} vga_char;

volatile vga_char *TEXT_AREA = (vga_char*) VGA_START;

void clearwin(){
    vga_char clear_char = {
        .character=' ',
        .style=STYLE_WB
    };

    for(unsigned int i = 0; i < VGA_EXTENT; i++){
        TEXT_AREA[i] = clear_char;
    }
}

void putstr(const char *str){
    for(unsigned int i = 0; str[i] != '\0'; i++){
        if (i >= VGA_EXTENT)
            break;

        vga_char temp = {
            .character=str[i],
            .style=STYLE_WB
        };

        TEXT_AREA[i] = temp;
    }
}

int main(){
    clearwin();
    const char *welcome_msg = "Welcome to the kernel! We can program in C and do debugging now";
    putstr(welcome_msg);

    return 0;
}