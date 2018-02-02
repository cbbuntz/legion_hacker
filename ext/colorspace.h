#pragma once
#include "color.h"

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

extern Truecolor hsv_to_rgb(float, float, float, uint32_t);
extern void print_hsv(float, float, float, uint32_t, char*);
extern void print_gradient(float, float, float, float, float, float, char*);
