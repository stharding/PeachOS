#ifndef CONFIG_H
#define CONFIG_H

#define KERNEL_CODE_SELECTOR 0x08
#define KERNEL_DATA_SELECTOR 0x10

#define PEACHOS_TOTAL_INTERUPTS 512

// 100MB heap size
#define PEACHOS_HEAP_SIZE_BYTES 1024 * 1024 * 100
#define PEACHOS_HEAP_BLOCK_SIZE 4096
#define PEACHOS_HEAP_ADDRESS 0x01000000
#define PEACHOS_HEAP_TABLE_ADDRESS 0x00007E00

#endif // CONFIG_H