ARGS=50000 500000

all: genprime-java genprime-c genprime-py genprime-objc genprime-cpp genprime-cs

clean:
	rm -f genprime.pyc genprime.class genprime-objc genprime-c genprime-cpp genprime-cs.exe

version:
	gmcs --version
	mono --version
	gcc -v
	g++ -v
	java -version
	perl -v | grep built\ for
	php --version
	python --version
	ruby --version

run: all
	@echo "genprime (C)"
	@./genprime-c $(ARGS)
	@echo
	@echo "genprime (C++)"
	@./genprime-cpp $(ARGS)
	@echo
	@echo "genprime (C#)"
	@mono genprime-cs.exe $(ARGS)
	@echo
	@echo "genprime (Java)"
	@java genprime $(ARGS)
	@echo
	@echo "genprime (Objective-C)"
	@./genprime-objc $(ARGS)
	@echo
	@echo "genprime (Perl)"
	@perl genprime.pl $(ARGS)
	@echo
	@echo "genprime (PHP)"
	@php genprime.php $(ARGS)
	@echo
	@echo "genprime (Python)"
	@python genprime.pyc $(ARGS)
	@echo
	@echo "genprime (Ruby)"
	@ruby genprime.rb $(ARGS)

genprime-java: genprime.class

genprime.class: genprime.java
	javac genprime.java

genprime-objc: genprime.m
	gcc -O3 -pedantic -Wall -framework AppKit -o genprime-objc genprime.m

genprime-c: genprime.c
	gcc -O3 -ansi -pedantic -Wall -o genprime-c genprime.c

genprime-cpp: genprime.cpp
	g++ -O3 -std=c++98 -pedantic -Wall -o genprime-cpp genprime.cpp

genprime-cs: genprime-cs.exe

genprime-cs.exe: genprime.cs
	gmcs -out:genprime-cs.exe -optimize+ genprime.cs

genprime-py: genprime.pyc

genprime.pyc: genprime.py
	python -c "import py_compile; py_compile.compile(\"genprime.py\");"
