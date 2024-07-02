#!/bin/bash

rm -f os.img
(make -C kernel clean)

(cd bootloader ; nasm -o boot boot.asm)
boot_result=$?

(make -C kernel)
make_result=$?

echo Make Result: $make_result

if [ "$boot_result" = "0" ] && [ "$make_result" = "0" ]
then
    kernel_size=$(wc -c < kernel/kernel)
    kernel_sectors=$(( ($kernel_size + 511) / 512 ))
    printf %02x $kernel_sectors | xxd -r -p | dd of=bootloader/boot bs=1 seek=2 count=1 conv=notrunc

    cp bootloader/boot ./os.img
    cat kernel/kernel >> os.img

    echo "Build finished successfully"
else
    result=`expr $boot_result + $make_result`
    echo "Build failed with error code $result. See output for more info."
fi