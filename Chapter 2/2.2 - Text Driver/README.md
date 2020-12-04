# Text Driver

## Improving the VGA

We can now have some fun improving the functionality of our VGA driver. To do this, we are going to create a new folder called `driver/` and create a file in there called `vga.c`. If you open that file and take a look inside you will see the same methods we created in the previous chapter, namely `clearwin()` and `putstr`.

These methods can be improved slightly by adding additional parameters that include the foreground and background colors, `fg_color` and `bg_color`. These will change the colors of the text.

## Moving around the Cursor

We now need to be able to move the cursor around so that the VGA driver knows where to print the text the next time `putstr()` is called.

We must first be able to find the cursor. To do this we created a folder `cpu/` and within that folder `ports.c`. This file has two methods, the first is used to write to the byte_out, and the second is used to read byte_in. If we give the `byte_in` method the address of a port, it will find the position in memory that port currently resides. This is useful for finding where the cursor is in VGA memory.

In the `vga.c` file, we see the method named `get_curesor_pos()`. This uses both the `byte_out()` and `byte_in()` methods to find the position of the cursor:

```c
u16_t get_cursor_pos(){
    u16_t position = 0;

    byte_out(CURSOR_PORT_COMMAND, 0x0F);
    position |= byte_in(CURSOR_PORT_DATA);

    byte_out(CURSOR_PORT_COMMAND, 0x0E);
    position |= byte_in(CURSOR_PORT_DATA) << 8;

    return position;
}
```

With this, we can now make a suite of methods that allow us to manipulate the action the cursor is taking. These methods are `show_cursor()`, `hide_cursor()`, `advance_cursor()`, and `set_cursor_pos()`.

The first two methods, `show_cursor()`, and `hide_cursor()` will show the cursor and hide the cursor respectively and are simply to write:

```c
void show_cursor(){
    u8_t current;

    byte_out(CURSOR_PORT_COMMAND, 0x0A);
    current = byte_in(CURSOR_PORT_DATA);
    byte_out(CURSOR_PORT_DATA, current & 0xC0);

    byte_out(CURSOR_PORT_COMMAND, 0x0B);
    current = byte_in(CURSOR_PORT_DATA);
    byte_out(CURSOR_PORT_DATA, current & 0xE0);
}


void hide_cursor(){
    byte_out(CURSOR_PORT_COMMAND, 0x0A);
    byte_out(CURSOR_PORT_DATA, 0x20);
}
```

The next two methods are slightly more difficult, because we need to ensure that the position is not beyond the `VGA_EXTENT` that we defined in the previous section. This can be handled by ensure the next position, is not beyond the extent of VGA memory.

```c
  u16_t pos = get_cursor_pos();
  pos++;

  if (pos >= VGA_EXTENT){
      pos = VGA_EXTENT - 1;
  }
```

Then, similarly we can implement the rest after making this check, and advance the cursor the correct amount:

```c
void advance_cursor(){
    u16_t pos = get_cursor_pos();
    pos++;

    if (pos >= VGA_EXTENT){
        pos = VGA_EXTENT - 1;
    }

    byte_out(CURSOR_PORT_COMMAND, 0x0F);
    byte_out(CURSOR_PORT_DATA, (u8_t) (pos & 0xFF));

    byte_out(CURSOR_PORT_COMMAND, 0x0E);
    byte_out(CURSOR_PORT_DATA, (u8_t) ((pos >> 8) & 0xFF));
}


void set_cursor_pos(u8_t x, u8_t y){
    u16_t pos = x + ((u16_t) VGA_WIDTH * y);

    if (pos >= VGA_EXTENT){
        pos = VGA_EXTENT - 1;
    }

    byte_out(CURSOR_PORT_COMMAND, 0x0F);
    byte_out(CURSOR_PORT_DATA, (u8_t) (pos & 0xFF));

    byte_out(CURSOR_PORT_COMMAND, 0x0E);
    byte_out(CURSOR_PORT_DATA, (u8_t) ((pos >> 8) & 0xFF));
}
```

## Updating Printing to Utilize the Cursor

Before this section, if we printed a String twice it would simply write over the initial String because the cursor has not been moved to print in a new location. We need to update the methods that put Strings. To start, we can utilize the `advance_cursor()` and make a method that prints just a single character. We can call this method `putchar()`. This method will check where the cursor currently resides, and then print the specified character at that location:

```c
void putchar(const char character, const u8_t fg_color, const u8_t bg_color){
    u8_t style = vga_color(fg_color, bg_color);
    vga_char printed = {
        .character = character,
        .style = style
    };

    u16_t position = get_cursor_pos();
    TEXT_AREA[position] = printed;
}
```

Next, we need to update the `putstr()` method to advance the cursor after every print. This can be done by utilizing the `putchar()` method in tandem with `advance_cursor()`:

```c
void putstr(const char *string, const u8_t fg_color, const u8_t bg_color){
    while (*string != '\0'){
        putchar(*string++, fg_color, bg_color);
        advance_cursor();
    }
}
```

We can test this now by creating a main method that prints multiple strings, and ensures nothing is written over. If you checkout the `kernel.c` file you can see this in action. First include the `vga.c` file that we created:

```c
#include <driver/vga.h>
```

And now make a main method that sets the initial cursor position at (0, 0) and prints multiple Strings.

## Building

There is a package that we need to ensure is downloaded onto our computer in order for this to run. This can be installed with homebrew, or any other homebrew like package. Run the following command to install `llvm`:

```
brew install llvm
```

You will then need then add that install to the path. On mac or linux, first find where `llvm` was installed:

```
find /usr | grep 'ld.lld$'
```

Next, temporarily add the file to your path with:

```
export PATH=$PATH:[/path/to/exe]
```

In my case, the path was `/usr/local/Cellar/llvm/11.0.0/bin/`.

Building this example is the same as building the previous step. To
assemble the program, use either:

```sh
./build.sh
```

or

```sh
sh build.sh
```

Then, to run the program in QEMU, use the following command:

```sh
qemu-system-x86_64 -drive format=raw,file=boot
```
