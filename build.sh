#/bin/bash

export PREFIX="$HOME/udemny/PeachOS/cross/opt/cross"
export TARGET=i686-elf
export PATH="$HOME/udemny/PeachOS/cross/opt/cross/bin/:$PATH"

mkdir -p build/idt
mkdir -p build/io
mkdir -p build/memory/heap

make clean
make all