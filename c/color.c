#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <custom/print.h>
#include "color.h"

inline int
truecolor_print(Truecolor c) {
    return printf(truecolor_fmt, UNPACK_COLOR(c));
}

inline int
truecolor_str(char* s, Truecolor c) {
    return sprintf(s, truecolor_fmt, UNPACK_COLOR(c));
}

inline Truecolor
hsv2rgb(float h, float s, float v, uint32_t fg_bg){
    float tmp = h / 120.;
    
    float whole = floor(tmp);
    float frac = tmp - whole;
    
    float a[3] = {1. - frac, frac, 0.};
    
    for (int i = 0; i < 3; i++) {
        // min(2x, 1) 
        a[i] = ldexp(a[i], 1);
        a[i] = fmin(a[i], 1.);
        
        a[i] = v * ((1. - s) + s * a[i]);
    }
    
    // set flag
    Truecolor rgb = fg_bg << 24;
    
    for (int i = 0; i < 3; i++) {
        rgb |= (
                (int)(a[i] * 255.f) & 0xFF) <<
                (8 * WRAP_MOD(whole + i,3));
        
    }
    return rgb;
}

#define AUTO_FORMAT(X) _Generic((X)       , \
uint8_t:          "%u"   ,\
uint16_t:         "%u"   ,\
uint32_t:         "%u"   ,\
uint64_t:         "%u"   ,\
int8_t:           "%i"   ,\
int16_t:          "%i"   ,\
int32_t:          "%i"   ,\
int64_t:          "%i"   ,\
float:            "%g"   ,\
double:           "%lg"  ,\
char*:            "%s"   ,\
void*:            "%p"   ,\
default:          "(unknown type)"\
)
#define PRINT_LABEL(X) printf("%s: ", #X)
#define WATCH(X) PRINT_LABEL(X);\
    printf(AUTO_FORMAT((X)), (X));\
    putchar('\n');

// printf("%s: %i\n", val);
inline float
blend_float(float a, float b, float c){
    return a - c * (a - b);
}
float c = 0.5
HSV blend(HSV a, HSV b, float c){
    HSV result;
    for (int k = 0; k < 3; k++) 
        result[k] = blend_float(a[k], b[k], c);
    
    return result;
}

enum HSV_ENUM{hue, sat, val, H = 0, S = 1, V = 2};
int main(int argc, char *argv[]){
    for (int i = -6; i < 36; i++){
        Truecolor color = hsv2rgb(12*i, 1, 1, 1);
        truecolor_print(color);
        printf("X");
          
    }
    
    putchar('\n');
    puts("\e[0m");
    
    hsv new_color = {60, 1, 1};

    WATCH(new_color[H]);
    WATCH(new_color[S]);
    WATCH(new_color[V]);
    
    uint32_t color = 0x00F3f201;
    truecolor_print(color);
    print("hello there");
    int32_t x = -5;
    // x = x & (1 << 31);
    
    printf("%u\n\%i",x,x);
    return 0;
}


/*int grayscale(unsigned char i, int layer) {*/
  /*return printf(ColorFormat256[layer], i + 232);*/
/*} // 0 <= i < 24*/

/*int rgb(unsigned char* c, int layer) {*/
  /*return printf(ColorFormat256[layer], 16 + (c[0] * 36) + (c[1] * 6) + c[2]);*/
/*} // 0 <= r,g,b <= 5*/

/*void _rgb(unsigned char* c) {*/
    /*printf("\e[38;5;%um", */
    /*(16 + (c[0] * 36) + (c[1] * 6) + c[2])*/
    /*);*/
    

