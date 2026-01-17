#ifndef MD5_H
#define MD5_H

#include <stdint.h>
#include <string.h>

typedef struct
{
    uint32_t state[4];    // MD5状态 (A, B, C, D)
    uint32_t count[2];    // 位计数器
    uint8_t buffer[64];   // 输入缓冲区
} MD5_CTX;

// 函数声明
void md5_init(MD5_CTX *context);
void md5_update(MD5_CTX *context, const uint8_t *input, uint32_t length);
void md5_final(uint8_t digest[16], MD5_CTX *context);
void md5_hash(const uint8_t *input, uint32_t length, uint8_t digest[16]);

#endif
