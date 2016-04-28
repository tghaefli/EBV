#!/bin/bash

echo "get original app-template"
git clone git://github.com/scs/app-template.git

cd app-template

echo "pull version for Raspberry Pi"
git pull git://github.com/klaus-zahn/app-template.git release

cd ..
