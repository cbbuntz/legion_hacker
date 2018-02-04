#include <time.h>
/* using for testing */
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

#define LOOP_2D(X, X0, X1, XI, Y, Y0, Y1, YI, CODE, ...)  \
    for (X = X0; X <= X1; X += XI){ for (Y = Y0; Y <= Y1; Y += YI){ CODE ;} __VA_ARGS__ ; }

#define LEFT_HALF  "\u258C"
#define RIGHT_HALF "\u2590"
#define LOWER_HALF "\u2584"
#define UPPER_HALF "\u2580"

void sleep_ms(int ms){
    usleep(ms * 1000);
}

