# The IDT

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
