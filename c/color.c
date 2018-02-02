#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include "color.h"
#include "colorspace.h"
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

void exit_cleanup(int signr)
{
    SCREEN_RESTORE
    exit(0);
}

int
main(int argc, char *argv[])
{

    signal(SIGINT, exit_cleanup);

	float h=0, s=0, v=0, l=0, x=0, y = 0, h2;

    char banner_color[32];
    truecolor_str(banner_color , 0x01243770);
    
    
    float dx = 1.f / 64.f;
    float dy = 1.f;
   
    SCREEN_STORE
        
    while(1){
        printf("\e[2J\e[H");
        printf("%s\e[K\e[1m  HSV\e[0m\n",banner_color);
        LOOP_2D(v, 0.f, 1.f, 0.1f, h, 0.f, 360.f, 6.f,
                h2 = h + y;
			    truecolor_print(fhsv2rgb_bg(h2, 1, v));
			    truecolor_print(fhsv2rgb_fg(h2, x, v));
			    printf(LOWER_HALF);
			    truecolor_print(fhsv2rgb_bg(h2, v, x));
			    truecolor_print(fhsv2rgb_fg(h2, v, x));
			    printf(LOWER_HALF);,
		        printf("\e[0m\e[K\n");
	           )
            printf("%s\e[K\e[1m  HSL\e[0m\n",banner_color);
        LOOP_2D(l, 0.f, 1.f, 0.1f, h, 0.f, 360.f, 6.f,
                h2 = h + y;
			    truecolor_print(fhsl2rgb_bg(h2, 1, l));
			    truecolor_print(fhsl2rgb_fg(h2, x, l));
			    printf(LOWER_HALF);
			    truecolor_print(fhsl2rgb_bg(h2, l, x));
			    truecolor_print(fhsl2rgb_fg(h2, l, x));
			    printf(LOWER_HALF);,
		        printf("\e[0m\e[K\n");
	           )
        sleep_ms(16);
        x += dx;
        if ((x <= 0) || (x >= 1))
            dx = -dx;
        y += dy;
        if (y >= 360.f)
            y = 0;
    };

	return 0;
}
