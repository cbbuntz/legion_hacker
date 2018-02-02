name='colorspace'
gcc -O3 -c -fpic "$name.c" -lm
gcc -shared -o "lib$name.so" "$name.o" -lm -O3
export LD_LIBRARY_PATH=`pwd`
# gcc -L. -o test $name.c -l$name -lm
