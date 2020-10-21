#!/bin/bash

(nasm boot.asm)
result=$?

if [ $result -eq "0" ]
then
    echo "Build finished successfully"
else
    echo "Build failed with error code $result. See output for more info."
fi