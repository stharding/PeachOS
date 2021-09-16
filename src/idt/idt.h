#ifndef ITD_H
#define ITD_H

#include <stdint.h>

struct idt_desc
{
    uint16_t offset_1; // Offset bits 0 - 15
    uint16_t selector; // Selector that's in our GDT
    uint8_t zero;      // Does nothing, set to 0
    uint8_t type_attr; // Descriptor type and attributes # TODO: this could be a bitfield?
    uint16_t offset_2; // offset bits 16 - 31
} __attribute__((packed));

struct idtr_desc
{
    uint16_t limit; // size of descriptor table -1
    uint32_t base;  // base address of the start of the interrupt descriptor table
} __attribute__((packed));

void idt_init();

#endif // ITD_H