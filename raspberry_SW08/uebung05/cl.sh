#!/bin/bash

echo "compile $1"
arm-linux-gnueabihf-gcc -c -std=gnu99 -I ~/Documents/hslu/EBV/Raspberry-Pi/git/oscar/include -DOSC_HOST -O2 $1.c

echo "link $1 to file app"
arm-linux-gnueabihf-gcc $1.o ~/Documents/hslu/EBV/Raspberry-Pi/git/oscar/library/libosc_target.a -o app
