ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
    jmp short start
    nop

; to make room for BIOS Parameter Block
times 33 db 0

start:
    jmp 0:step2

step2:
    cli ; clear interupts
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ; enables interupts

.load_protected:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:load32

; GDT

gdt_start:
gdt_null:
    dd 0x00
    dd 0x00

; offset 0x8
gdt_code:     ; cs should point to this
    dw 0xffff ; Segment limit first 0-15 bits
    dw 0      ; base first 0-15
    db 0      ; base 16-23 bits
    db 0x9a   ; addess byte
    db 11001111b ; high 4 bit flags and the low 4 bit flags
    db 0      ; base 24-31 bits

; offest 0x10
gdt_data:     ; ds, ss, es, fs, gs
    dw 0xffff ; Segment limit first 0-15 bits
    dw 0      ; base first 0-15
    db 0      ; base 16-23 bits
    db 0x92   ; addess byte
    db 11001111b ; high 4 bit flags and the low 4 bit flags
    db 0      ; base 24-31 bits

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

[BITS 32]
load32:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp
    jmp $

times 510-($ - $$) db 0
dw 0xAA55
