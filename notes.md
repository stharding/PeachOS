Links
======

 - Ralf Brown's Interrupt List: http://www.ctyme.com/rbrown.htm
 - Good resource for OS creation https://wiki.osdev.org
 - Details about BIOS FAT BIOS Parameter Block https://wiki.osdev.org/FAT
 - Details about exceptions https://wiki.osdev.org/Exceptions


gdb command
===========

target remote | qemu-system-i386 -hda ./bin/os.bin -S -gdb stdio
add-symbol-file build/kernelfull.o 0x100000