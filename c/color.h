#pragma once

#include <stdint.h>

// little endian unpack
#define UNPACK(X, I) *(((uint8_t*) &X) + (3 - I))
#define UNPACK_COLOR(X) (UNPACK(X,0) + '3') ,UNPACK(X,1),UNPACK(X,2),UNPACK(X,3)
#define WRAP_MOD(X,D) (((int)(X) % (D) + (D)) % (D))

// 0000000L RRRRRRRR GGGGGGGG BBBBBBBB
typedef uint32_t Truecolor;
typedef float hsv[3];

typedef struct _HSV{
    float h;
    float s;
    float v;
}HSV;

char color256_fmt[] = "\e[%u8;5;%um";

char truecolor_fmt[] = "\e[%c8;2;%u;%u;%um";
int truecolor_print(Truecolor c);
int truecolor_str(char* s, Truecolor c);
    
Truecolor hsv2rgb(float h, float s, float v, uint32_t fg_bg);
// int hsv_print(char* s, Truecolor c);
float blend_float(float, float, float);


