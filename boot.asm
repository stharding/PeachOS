ORG 0x0000
BITS 16

_start:
    jmp short start
    nop

; to make room for BIOS Parameter Block
times 33 db 0

start:
    jmp 0x7c0:step2

step2:
    cli ; clear interupts
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00

    sti ; enables interupts
    mov si, message
    call print
    jmp $

print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret


print_char:
    mov ah, 0eh
    int 0x10
    ret

message: db 'Hello World!', 0

times 510-($ - $$) db 0
dw 0xAA55