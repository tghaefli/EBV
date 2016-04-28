#!/bin/bash
echo "compile func_add and func_mul"
arm-linux-gnueabihf-gcc -c func_add.c
arm-linux-gnueabihf-gcc -c func_mul.c

echo "create library file libfunc.a from object "
arm-linux-gnueabihf-ar rcu libfunc.a func_add.o func_mul.o

echo "compile $1.c to give object file $1.o"
arm-linux-gnueabihf-gcc -c $1.c

echo "link $1.o and libfunc.a to file app"
arm-linux-gnueabihf-gcc $1.o libfunc.a -o app
