# Scrolling

## Why Do We Need To Scroll

Should the available memory to the VGA driver be full, it is unclear how this will affect the next thing to be printed depending on implementation. To avoid this, scrolling is necessary to ensure there is room for more text to be output.

This chapter details how to implement scrolling, as well as how to account for special characters user might imput.

## Implementing Scrolling

We should create a new method that scrolls a line of text in our file `driver/vga.c'`. We can do this by creating a method named `scroll_line()` and updating our print methods to utilize it.

We first need to determine the height and width of the VGA. This is defined in our header file with a default value of 25 `VGA_HEIGHT`. We must also do the same for the width with a default value of 80, `VGA_WIDTH`. These are standard limits for our VGA, but can be changed programmatically with window resizing in the future if we want.

Our `scroll_line()` method should begin by copying the data in the memory buffer upward so that the final chunk of the memory buffer becomes empty. This can be accomplished utilizing two for-loops:

```c
for(u16_t i = 1; i < VGA_HEIGHT; i++){
    for(u16_t j = 0; j < VGA_WIDTH; j++){
        u16_t to_pos = j + ((i - 1) * VGA_WIDTH);
        u16_t from_pos = j + (i * VGA_WIDTH);

        TEXT_AREA[to_pos] = TEXT_AREA[from_pos];
    }
}
```

We will also need to clear the final row so that more data can be input. This can be done by setting the characters in the final row to a space, or `' '`:

```c
u16_t i = VGA_HEIGHT - 1;
for(u16_t j = 0; j < VGA_WIDTH; j++){
    u16_t pos = j + (i * VGA_WIDTH);

    vga_char current = TEXT_AREA[pos];
    vga_char clear = {
        .character=' ',
        .style = current.style
    };

    TEXT_AREA[pos] = clear;
}
```

finally, we set the cursor to be at the position:

```c
set_cursor_pos(0, VGA_HEIGHT - 1);
```

## Using the `scroll_line()` Method

We must now update the `advance_cursor()` method to scroll the line if the current position is greater than the available memory to the VGA. This can be done with an addition of an if-statement in the `advance_cursor()` method:

```c
if (pos >= VGA_EXTENT){
    scroll_line();
}
```

Additionally, we also know that should a user give us a newline character, `'\n'`, we should scroll the line once. In the `putchar()` method, we can place this functionality.

```c
if (character == '\n'){
    u8_t current_row = (u8_t) (position / VGA_WIDTH);

    if (++current_row >= VGA_HEIGHT){
        scroll_line();
    }
    else{
        set_cursor_pos(0, current_row);
    }
}

else if (character == '\r'){
    u8_t current_row = (u8_t) (position / VGA_WIDTH);

    set_cursor_pos(0, current_row);
}
```

## Accounting For Special Characters

There are many escaped characters that are used to perform special functionality, such as the carriage return character, `'\r'`, or the newline character, `'\n'`. Our VGA driver should account for each. However, as they are relatively simply to implement around the functionality we have already built, we will only implement two additional for the tutorial.

If you take a look at our `putchar()` method, we have added functionality for tabs, `'\t'`, and the carriage return character, `'\r'`. This can be done simply be handling each case should you run into that special character as an input:

```c
else if (character == '\r'){
    u8_t current_row = (u8_t) (position / VGA_WIDTH);

    set_cursor_pos(0, current_row);
}

else if (character == '\t'){
    // Turn tab to 4 spaces
    for (u8_t i = 0; i < 4; i++){
        putchar(' ', fg_color, bg_color);
    }
    advance_cursor();
}
```

Finally, we can use our main method in `kernel.c` to test everything we've done!

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
