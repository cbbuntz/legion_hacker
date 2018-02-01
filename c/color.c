#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "color.h"
#include "util.h"

inline int
truecolor_print(Truecolor c)
{
	return printf(truecolor_fmt, UNPACK_COLOR(c));
}

inline int
truecolor_str(char *s, Truecolor c)
{
	return sprintf(s, truecolor_fmt, UNPACK_COLOR(c));
}

// hsv2rgb(float h, float s, float v, uint32_t fg_bg) {
inline Truecolor
hsv2rgb(HSV hsv, uint32_t fg_bg)
{
	float tmp = hsv[H] / 120.;

	float whole = floor(tmp);
	float frac = tmp - whole;

	float a[3] = { 1. - frac, frac, 0. };

	for (int i = 0; i < 3; i++) {
		/* min(2x, 1) */
		a[i] = ldexp(a[i], 1);
		a[i] = fmin(a[i], 1.);

		a[i] = hsv[V] * ((1. - hsv[S]) + hsv[S] * a[i]);
	}

	/* set flag */
	Truecolor rgb = fg_bg << 24;

	for (int i = 0; i < 3; i++) {
		rgb |= (
			(int)(a[i] * 255.f) & 0xFF) <<
		       (8 * WRAP_MOD(whole + i, 3));
	}
	return rgb;
}

#define BLEND(A, B, C) ((A)-(C)*((A)-(B)))

inline Truecolor
blend_hsv(HSV a, HSV b, float c)
{
	HSV tmp;

	for (int i = 0; i < 3; i++)
		tmp[i] = BLEND(a[i], b[i], c);

	Truecolor result;
	result = hsv2rgb(tmp, 0);
	return result;
}

int
main(int argc, char *argv[])
{
	float hue, sat, val;

	for (val = 0.; val < 1.; val += 0.1) {
		for (float hue = 0.; hue < 360.; hue += 6.) {
			HSV hsv = { hue, 1., val };
			Truecolor c = hsv2rgb(hsv, 1);
			truecolor_print(c);
			printf(" ");
		}
		printf("\e[0m\n");
	}
	for (sat = 0.9; sat >= 0.; sat -= 0.1) {
		for (hue = 0.; hue < 360.; hue += 6.) {
			HSV hsv = { hue, sat, val };
			Truecolor c = hsv2rgb(hsv, 1);
			truecolor_print(c);
			printf(" ");
		}
		printf("\e[0m\n");
	}

	putchar('\n');
	puts("\e[0m");

	uint32_t color = 0x00F3F201;
	truecolor_print(color);
	print("hello there");

	return 0;
}
