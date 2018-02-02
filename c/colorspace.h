#pragma once
#include <math.h>
#include "color.h"


inline Truecolor
fhsv2rgb(float h, float s, float v, uint32_t fg_bg) {
    s = fmax(0.f, fmin(s, 1.f));
    v = fmax(0.f, fmin(v, 1.f)); 
    
    float tmp = h / 120.;

	float whole = floor(tmp);
	float frac = tmp - whole;

	float a[3];
	a[0] = 1. - frac;
	a[1] = frac;
	a[2] = 0.;

	for (int i = 0; i < 3; i++) {
		/* min(2x, 1) */
		a[i] = ldexp(a[i], 1);
		a[i] = fmin(a[i], 1.);

		a[i] = v * ((1. - s) + s * a[i]);
	}

	/* set flag */
	Truecolor rgb = fg_bg << 24;

	for (int i = 0; i < 3; i++) {
		rgb |= (
			    (int)(a[i] * 255.f) & 0xFF) <<
		    (8 * WRAP_MOD((2 - whole - i), 3));
	}
	return rgb;
}

inline Truecolor
hsv2rgb(HSV hsv, uint32_t fg_bg)
{ return fhsv2rgb(hsv[0], hsv[1], hsv[2], fg_bg); }

inline Truecolor
fhsv2rgb_fg(float h, float s, float v)
{ return fhsv2rgb(h,s,v,0); }

inline Truecolor
fhsv2rgb_bg(float h, float s, float v)
{ return fhsv2rgb(h,s,v,1); }

inline Truecolor
hsv2rgb_fg(HSV hsv)
{ return fhsv2rgb(hsv[0], hsv[1], hsv[2], 0); }

inline Truecolor
hsv2rgb_bg(HSV hsv)
{ return fhsv2rgb(hsv[0], hsv[1], hsv[2], 1); }

inline Truecolor
fhsl2rgb(float h, float s, float l, uint32_t fg_bg) {
    s = fmax(0.f, fmin(s, 1.f));
    l = fmax(0.f, fmin(l, 1.f));
    
    float c = (1 - fabs(2 * l - 1)) * s;

    float hp = h / 120.;
    // fhsv2rgb accepts negative hue without fmod.
    // possibly simplify?
    float hmod = 2 * fmod((fmod(hp, 1) + 1), 1);
     
    float x = c * (1 - fabs(hmod - 1));
    float m = l - 0.5 * c;
    
	float a[3];
	if (floor(hmod) < 1.0) {
	    a[0] = c; a[1] = x;
	} else {
	    a[0] = x; a[1] = c;
	}
	
	a[2] = 0.;

    int offset = (int)floor(hp);

	/* set flag */
	Truecolor rgb = fg_bg << 24;

	for (int i = 0; i < 3; i++) {
		rgb |= (
			    (int)( (a[i] + m) * 255.f) & 0xFF) <<
		    ( 8 * WRAP_MOD((2 - offset - i), 3) );
	}
	return rgb;
}

inline Truecolor
fhsl2rgb_fg(float h, float s, float l)
{ return fhsl2rgb(h,s,l,0); }

inline Truecolor
fhsl2rgb_bg(float h, float s, float l)
{ return fhsl2rgb(h,s,l,1); }

inline Truecolor
hsl2rgb(HSL hsl, uint32_t fg_bg)
{ return fhsl2rgb(hsl[0], hsl[1], hsl[2], fg_bg); }

inline Truecolor
hsl2rgb_fg(HSL hsl)
{ return fhsl2rgb(hsl[0], hsl[1], hsl[2], 0); }

inline Truecolor
hsl2rgb_bg(HSL hsl)
{ return fhsl2rgb(hsl[0], hsl[1], hsl[2], 1); }

