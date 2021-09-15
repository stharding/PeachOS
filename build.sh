#/bin/bash

export PREFIX="$HOME/udemny/PeachOS/cross/opt/cross"
export TARGET=i686-elf
export PATH="$HOME/udemny/PeachOS/cross/opt/cross/bin/:$PATH"

mkdir -p build

make clean
make all