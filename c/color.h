#pragma once

#include <stdint.h>

// little endian unpack
#define UNPACK(X, I) *(((uint8_t *)&X) + (3 - I))
#define UNPACK_COLOR(X) (UNPACK(X, 0) + '3'), UNPACK(X, 1), UNPACK(X, 2), UNPACK(X, 3)
#define WRAP_MOD(X, D) (((int)(X) % (D) + (D)) % (D))

// 0000000L RRRRRRRR GGGGGGGG BBBBBBBB
typedef uint32_t Truecolor;
#define BG_MASK(X) (X) | 0x01000000
#define FG_MASK(X) (X) & 0xFEFFFFFF

typedef float HSV[3];

enum HSV_ENUM { hue, sat, val, H = 0, S = 1, V = 2 };

char color256_fmt[] = "\e[%u8;5;%um";

char truecolor_fmt[] = "\e[%c8;2;%u;%u;%um";
int truecolor_print(Truecolor c);
int truecolor_str(char *s, Truecolor c);

Truecolor hsv2rgb(HSV, uint32_t);
// int hsv_print(char* s, Truecolor c);
Truecolor blend_hsv(HSV, HSV, float);
