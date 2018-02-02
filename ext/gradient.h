#include "color.h"
#define BLEND(A, B, C) ((A)-(C)*((A)-(B)))

Truecolor blend_hsv(HSV, HSV, float);

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

#undef BLEND

