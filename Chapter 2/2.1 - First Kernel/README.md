# First Kernel

## What is a Kernel

The kernel is the portion of the operating system that facilitates tasks between hardware and software. If the bootloader is the component of an operating system that can handle CPU, memory, and devices very close to the hardware, the kernel is an abstracted layer between the bootloader and the execution of software applications.

## Goodbye Assembly!

Now that we have written our bootloader, we are able to stop writing in `*.asm` files. This is great because develop can now be much quicker through using `*.c` files instead. If you navigate to the `/kernel` folder, you should see the file named `kernel.c`, this file is our first kernel.

## Printing Text to Screen

In this exercise, our goal is to print text to the screen through the kernel. The Video Graphics Array, or VGA, is a layer between our operating system and the monitor you see this text on. In C, we must define the bit of memory where VGA resides to use later in the program. Additionally, we must define how much memory VGA has, which is defined as 80 * 25.

```c
#define VGA_START 0xB8000
#define VGA_EXTENT 80 * 25
```

The first thing we want to accomplish is clearing the text window so that we can print to the screen. This can be accomplished by creating a function that prints an empty character, or `' '` to every chunk of memory the VGA possesses. You can either implent this function yourself, or use the one we wrote for you.

```c
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
```

Finally, we must make a way to translate a string into a format that is appropriate for the VGA to read and print. It is important to note that in C, every String is an array of characters with a terminating character of `'\0'`. With this knowledge, we can write a function that takes a pointer to a String, and outputs each character in the String until we hit our terminating character. You can either write this yourself, or use the function we have written for you.

```C
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
```

Finally, we can write a `main()` method that prints a string by first clearing the window with our `clearwin()` method, and then prints a String with our `putstr()` method.

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
