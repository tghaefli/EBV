#!/bin/bash

echo "compile $1"
arm-linux-gnueabihf-gcc -c -std=gnu99 -I ~/Documents/hslu/EBV/Raspberry-Pi/git/oscar/include -DOSC_HOST -O2 $1.c

echo "link $1 to file app"
arm-linux-gnueabihf-gcc $1.o ~/Documents/hslu/EBV/Raspberry-Pi/git/oscar/library/libosc_target.a -o app

echo "transfer application"
scp app pi@192.168.0.9:/home/pi/tmp

echo "transfer index.html (we must be root to access /var/www!)"
scp index.html file1.txt file2.txt root@192.168.0.9:/var/www/.