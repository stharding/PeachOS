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
    mov eax, 1
    mov ecx, 100
    mov edi, 0x0100000
    call ata_lba_read
    jmp CODE_SEG:0x0100000

ata_lba_read:
    mov ebx, eax ; backup the LBA
    ; send the highest 8 bits of the lba to the hard disk controller
    shr eax, 24
    or eax, 0xe0 ; select the master drive
    mov dx, 0x1F6
    out dx, al
    ; Finished sending the highest 8 bits of the lba

    ; send the total sectors to read
    mov eax, ecx
    mov dx, 0x1F2
    out dx, al
    ; finished sending the total sectors to read

    ; send more bits of the LBA
    mov eax, ebx ; restore the backup LBA
    mov dx, 0x1F3
    out dx, al
    ; finished sending more bits of the LBA

    mov dx, 0x1F4
    mov eax, ebx ; restore the backup LBA
    shr eax, 8
    out dx, al
    ; finished sending more bits of the LBA

    ; send upper 16 bits of the LBA
    mov dx, 0x1F5
    mov eax, ebx ; restore the backup LBA
    shr eax, 16
    out dx, al
    ; finished sending upper 16 bits of the LBA

    mov dx, 0x1f7
    mov al, 0x20
    out dx, al

; read all sectors into memory
.next_sector:
    push ecx

; checking if we need to read
.try_again:
    mov dx, 0x1f7
    in al, dx
    test al, 8
    jz .try_again

; we need to read 256 words at a time
    mov ecx, 256
    mov dx, 0x1f0
    rep insw
    pop ecx
    loop .next_sector
    ; end of reading sectors into memory
    ret


times 510-($ - $$) db 0
dw 0xAA55
