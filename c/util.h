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

void sleep_ms(int ms){
    usleep(ms * 1000);
}

