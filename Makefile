all: genprime-c

clean:
	rm -f *.s *.o *.exe genprime-*

version:
	@echo
	-uname -a
	@echo
	-gcc -v

run: all
	@echo "genprime (C GCC)"
	@-./genprime-c $(ARGS)
	@echo

genprime-c: genprime.c
	-gcc -O3 -pipe -std=gnu99 -pedantic -Wall -S -o genprime-c.s genprime.c
	-gcc -O3 -pipe -o genprime-c genprime-c.s
	@echo
