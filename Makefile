ARGS=250000 1000000

all: genprime-java genprime-c genprime-py25 genprime-py30 genprime-objc genprime-cpp genprime-cs genprime-c-llvm genprime-c-icc genprime-c-clang

clean:
	rm -f genprime.*.py *.pyc *.class genprime-* *.s *.bc *.ll

version:
	@echo
	-gmcs --version
	@echo
	-mono --version
	@echo
	-gcc -v
	@echo
	-g++ -v
	@echo
	-icc -v
	@echo
	-java -version
	@echo
	-llc -version
	@echo
	-llvm-gcc -v
	@echo
	-lua -v
	@echo
	-luajit -v
	@echo
	-perl -v | grep built\ for
	@echo
	-php --version
	@echo
	-python2.5 --version
	@echo
	-python3.0 --version
	@echo
	-ruby --version
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
	@echo "genprime (C#)"
	@-mono genprime-cs.exe $(ARGS)
	@echo
	@echo "genprime (Java)"
	@-java genprime $(ARGS)
	@echo
	@echo "genprime (Lua)"
	@-lua genprime.lua $(ARGS)
	@echo
	@echo "genprime (LuaJIT)"
	@-luajit genprime.lua $(ARGS)
	@echo
	@echo "genprime (Objective-C)"
	@-./genprime-objc $(ARGS)
	@echo
	@echo "genprime (Perl)"
	@-perl genprime.pl $(ARGS)
	@echo
	@echo "genprime (PHP)"
	@-php genprime.php $(ARGS)
	@echo
	@echo "genprime (Python 2.5)"
	@-python2.5 genprime.25.pyc $(ARGS)
	@echo
	@echo "genprime (Python 3.0)"
	@-python3.0 genprime.30.pyc $(ARGS)
	@echo
	@echo "genprime (Ruby)"
	@-ruby genprime.rb $(ARGS)

genprime-java: genprime.class

genprime.class: genprime.java
	-javac genprime.java

genprime-objc: genprime.m
	-/Developer/usr/bin/gcc -O3 -pipe -pedantic -S -o genprime-objc.s genprime.m
	-/Developer/usr/bin/gcc -O3 -pipe -framework AppKit -o genprime-objc genprime-objc.s

genprime-c: genprime.c
	-gcc -O3 -pipe -ansi -pedantic -Wall -S -o genprime-c.s genprime.c
	-gcc -O3 -pipe -o genprime-c genprime-c.s

genprime-c-icc: genprime.c
	-icc -xSSE3 -O3 -pipe -ansi -pedantic -Wall -S -o genprime-c-icc.s genprime.c
	-icc -xSSE3 -O3 -pipe -o genprime-c-icc genprime-c-icc.s

genprime-c-llvm: genprime.c
	-llvm-gcc -O3 -ansi -pedantic -Wall -emit-llvm -S -o genprime-c-llvm.ll genprime.c
	-llvm-as genprime-c-llvm.ll
	-cat genprime-c-llvm.bc | opt -std-compile-opts | llc > genprime-c-llvm.s
	-llvm-gcc -O3 -pipe -o genprime-c-llvm genprime-c-llvm.s

genprime-c-clang: genprime.c
	-clang genprime.c -emit-llvm -o genprime-c-clang.ll
	-llvm-as genprime-c-clang.ll
	-cat genprime-c-clang.bc | opt -std-compile-opts | llc > genprime-c-clang.s
	-gcc -O3 -pipe -o genprime-c-clang genprime-c-clang.s

genprime-cpp: genprime.cpp
	-g++ -O3 -pipe -std=gnu++98 -pedantic -Wall -S -o genprime-cpp.s genprime.cpp
	-g++ -O3 -pipe -o genprime-cpp genprime-cpp.s

genprime-cs: genprime-cs.exe

genprime-cs.exe: genprime.cs
	-gmcs -out:genprime-cs.exe -optimize+ genprime.cs

genprime-py25: genprime.25.pyc

genprime-py30: genprime.30.pyc

genprime.25.pyc: genprime.py
	-ln -sf genprime.py genprime.25.py
	-python2.5 -c "import py_compile; py_compile.compile(\"genprime.25.py\");"

genprime.30.pyc: genprime.py
	-ln -sf genprime.py genprime.30.py
	-python3.0 -c "import py_compile; py_compile.compile(\"genprime.30.py\");"
