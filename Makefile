
ARGS=250000 1000000

all: genprime-java genprime-c genprime-py genprime-objc genprime-cpp genprime-cs genprime-c-llvm genprime-c-clang

clean:
	rm -f genprime.pyc genprime.class genprime-objc genprime-c genprime-cpp genprime-cs.exe genprime-c-llvm gnprime-c-clang *.s

version:
	@echo
	-gmcs --version
	@echo
	-mono --version
	@echo
	-llc -version
	@echo
	-llvm-gcc-4.2 -v
	@echo
	-gcc -v
	@echo
	-g++ -v
	@echo
	-java -version
	@echo
	-perl -v | grep built\ for
	@echo
	-php --version
	@echo
	-python --version
	@echo
	-ruby --version
	@echo

run: all
	@echo "genprime (C)"
	@-./genprime-c $(ARGS)
	@echo
	@echo "genprime (C LLVM)"
	@-./genprime-c-llvm $(ARGS)
	@echo
	@echo "genprime (C Clang/LLVM)"
	@-./genprime-c-clang $(ARGS)
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
	@echo "genprime (Objective-C)"
	@-./genprime-objc $(ARGS)
	@echo
	@echo "genprime (Perl)"
	@-perl genprime.pl $(ARGS)
	@echo
	@echo "genprime (PHP)"
	@-php genprime.php $(ARGS)
	@echo
	@echo "genprime (Python)"
	@-python genprime.pyc $(ARGS)
	@echo
	@echo "genprime (Ruby)"
	@-ruby genprime.rb $(ARGS)

genprime-java: genprime.class

genprime.class: genprime.java
	-javac genprime.java

genprime-objc: genprime.m
	-gcc -O3 -pipe -pedantic -Wall -S -o genprime-objc.s genprime.m
	-gcc -O3 -pipe -framework AppKit -o genprime-objc genprime-objc.s

genprime-c: genprime.c
	-gcc -O3 -pipe -ansi -pedantic -Wall -S -o genprime-c.s genprime.c
	-gcc -O3 -pipe -o genprime-c genprime-c.s

genprime-c-llvm: genprime.c
	-llvm-gcc-4.2 -O3 -ansi -pedantic -Wall -S -o genprime-c-llvm.s genprime.c
	-gcc -O3 -pipe -o genprime-c-llvm genprime-c-llvm.s

genprime-c-clang: genprime.c
	-clang genprime.c -emit-llvm -o - | llvm-as | opt -std-compile-opts | llc > genprime-c-clang.s
	-gcc -O3 -pipe -o genprime-c-clang genprime-c-clang.s

genprime-cpp: genprime.cpp
	-g++ -O3 -pipe -std=c++98 -pedantic -Wall -S -o genprime-cpp.s genprime.cpp
	-g++ -O3 -pipe -o genprime-cpp genprime-cpp.s

genprime-cs: genprime-cs.exe

genprime-cs.exe: genprime.cs
	-gmcs -out:genprime-cs.exe -optimize+ genprime.cs

genprime-py: genprime.pyc

genprime.pyc: genprime.py
	-python -c "import py_compile; py_compile.compile(\"genprime.py\");"
