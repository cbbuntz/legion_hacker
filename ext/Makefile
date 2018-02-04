name = color
src = color.c
obj = $(src:.c=.o)
CFLAGS = -O3 -march=native
LDFLAGS = -lm

$(name): $(obj)
	$(CC) -o $@ $^ $(LDFLAGS)

.PHONY: clean
clean:
	rm -f $(obj) $(name)
