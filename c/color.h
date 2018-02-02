#pragma once
#include <stdint.h>

#define SCREEN_STORE printf("\e[?1049h\e[2J\e[H");
#define SCREEN_RESTORE printf("\e[?1049l");

// little endian unpack
#define UNPACK(X, I) *(((uint8_t *)&X) + (3 - I))
#define UNPACK_COLOR(X) (UNPACK(X, 0) + '3'), UNPACK(X, 1), UNPACK(X, 2), UNPACK(X, 3)
#define WRAP_MOD(X, D) (((int)(X) % (D) + (D)) % (D))

// 0000000L RRRRRRRR GGGGGGGG BBBBBBBB
typedef uint32_t Truecolor;
#define BG_MASK(X) (X) | 0x01000000
#define FG_MASK(X) (X) & 0xFEFFFFFF

typedef float HSV[3];
typedef float HSL[3];

enum HSV_ENUM { H, S, V, L = 3 };

char color256_fmt[] = "\e[%u8;5;%um";

char truecolor_fmt[] = "\e[%c8;2;%u;%u;%um";
int truecolor_print(Truecolor c);
int truecolor_str(char *s, Truecolor c);

Truecolor fhsv2rgb(float, float, float, uint32_t);
Truecolor fhsl2rgb(float, float, float, uint32_t);

Truecolor hsv2rgb(HSV, uint32_t);
Truecolor hsl2rgb(HSL, uint32_t);

Truecolor fhsv2rgb_fg(float, float, float);
Truecolor fhsv2rgb_bg(float, float, float);

Truecolor fhsl2rgb_fg(float, float, float);
Truecolor fhsl2rgb_bg(float, float, float);

Truecolor hsv2rgb_fg(HSV);
Truecolor hsv2rgb_bg(HSV);

Truecolor hsl2rgb_fg(HSL);
Truecolor hsl2rgb_bg(HSL);
// int hsv_print(char* s, Truecolor c);
// 
Truecolor blend_hsv(HSV, HSV, float);
