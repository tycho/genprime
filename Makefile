ARGS=25000 100000

all: genprime-c genprime-py27 genprime-py30 genprime-cpp genprime-c-llvm genprime-c-icc genprime-c-clang

clean:
	rm -f genprime.*.py *.pyc *.class genprime-* *.s *.bc *.ll *.rbc

version:
	@echo
	-uname -a
	@echo
	-gcc -v
	@echo
	-g++ -v
	@echo
	-icc -v
	@echo
	-llc -version
	@echo
	-llvm-gcc -v
	@echo
	-lua -v
	@echo
	-luajit -v
	@echo
	-cython --version
	@echo
	-python2.7 --version
	@echo
	-python3.0 --version
	@echo
	-ruby --version
	@echo
	-rbx -v
	@echo

run: all
	@echo "genprime (C GCC)"
	@-./genprime-c $(ARGS)
	@echo
	@echo "genprime (C LLVM)"
	@-./genprime-c-llvm $(ARGS)
	@echo
	@echo "genprime (C LLVM JIT)"
	@-lli genprime-c-llvm.bc $(ARGS)
	@echo
	@echo "genprime (C Clang/LLVM)"
	@-./genprime-c-clang $(ARGS)
	@echo
	@echo "genprime (C Clang/LLVM JIT)"
	@-lli genprime-c-clang.bc $(ARGS)
	@echo
	@echo "genprime (C Intel Compiler)"
	@-./genprime-c-icc $(ARGS)
	@echo
	@echo "genprime (C++)"
	@-./genprime-cpp $(ARGS)
	@echo
	@echo "genprime (Lua)"
	@-lua genprime.lua $(ARGS)
	@echo
	@echo "genprime (LuaJIT)"
	@-luajit genprime.lua $(ARGS)
	@echo
	@echo "genprime (Python 2.7)"
	@-python2.7 genprime.27.pyc $(ARGS)
	@echo
	@echo "genprime (Python 2.7 + Cython)"
	@-./genprime-pyx $(ARGS)
	@echo
	@echo "genprime (Python 2.7 + Psyco)"
	@-python2.7 genprime.27.pyc -p $(ARGS)
	@echo
	@echo "genprime (Python 3.0)"
	@-python3.0 genprime.30.pyc $(ARGS)
	@echo
	@echo "genprime (Ruby)"
	@-ruby genprime.rb $(ARGS)
	@echo
	@echo "genprime (Ruby Rubinius)"
	@-rbx genprime.rb $(ARGS)

genprime-c: genprime.c
	-gcc -O3 -pipe -ansi -pedantic -Wall -S -o genprime-c.s genprime.c
	-gcc -O3 -pipe -o genprime-c genprime-c.s -lm
	@echo

genprime-c-icc: genprime.c
	-icc -xSSE3 -O3 -pipe -ansi -pedantic -Wall -S -o genprime-c-icc.s genprime.c
	-icc -xSSE3 -O3 -pipe -o genprime-c-icc genprime-c-icc.s -lm
	@echo

genprime-c-llvm: genprime.c
	-llvm-gcc -O3 -ansi -pedantic -Wall -emit-llvm -S -o genprime-c-llvm.ll genprime.c
	-llvm-as genprime-c-llvm.ll
	-cat genprime-c-llvm.bc | opt -std-compile-opts | llc > genprime-c-llvm.s
	-llvm-gcc -O3 -pipe -o genprime-c-llvm genprime-c-llvm.s -lm
	@echo

genprime-c-clang: genprime.c
	-clang genprime.c -emit-llvm -o genprime-c-clang.ll
	-llvm-as genprime-c-clang.ll
	-cat genprime-c-clang.bc | opt -std-compile-opts | llc > genprime-c-clang.s
	-gcc -O3 -pipe -o genprime-c-clang genprime-c-clang.s -lm
	@echo

genprime-cpp: genprime.cpp
	-g++ -O3 -pipe -std=gnu++98 -pedantic -Wall -S -o genprime-cpp.s genprime.cpp
	-g++ -O3 -pipe -o genprime-cpp genprime-cpp.s -lm
	@echo

genprime-pyx: genprime.pyx
	-cython --embed -o genprime-pyx.c genprime.pyx
	-gcc -O3 -pipe $(shell pkg-config --cflags python) genprime-pyx.c -o genprime-pyx $(shell pkg-config --libs python)

genprime-py27: genprime.27.pyc

genprime-py30: genprime.30.pyc

genprime.27.pyc: genprime.py
	-ln -sf genprime.py genprime.27.py
	-python2.7 -c "import py_compile; py_compile.compile(\"genprime.27.py\");"
	@echo

genprime.30.pyc: genprime.py
	-ln -sf genprime.py genprime.30.py
	-python3.0 -c "import py_compile; py_compile.compile(\"genprime.30.py\");"
	@echo
