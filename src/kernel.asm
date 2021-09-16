[BITS 32]
global _start
extern kernel_main

CODE_SEG equ 0x08
DATA_SEG equ 0x10

_start:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp

    ; enable the A20 line (https://wiki.osdev.org/A20_Line#Fast_A20_Gate)
    in al, 0x92
    or al, 2
    out 0x92, al

    ; remap the master PIC (Programmable Interrupt Controller)
    mov al, 00010001b
    out 0x20, al ; tell master PIC

    mov al, 0x20 ; interrupt -x20 is where master IST should start
    out 0x21, al

    mov al, 00000001b
    out 0x21, al
    ; end remap of the master PIC

    ; enable interrupts
    sti

    call kernel_main
    jmp $

times 512-($ - $$) db 0
