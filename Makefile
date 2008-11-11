ARGS=50000 500000

all: genprime-java genprime-c genprime-py genprime-objc

clean:
	rm -f genprime.pyc genprime.class genprime-objc genprime-c

version:
	gcc -v
	java -version
	perl -v | grep built\ for
	php --version
	python --version
	ruby --version

run: all
	@echo "genprime (C)"
	@./genprime-c $(ARGS)
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

genprime-py: genprime.pyc

genprime.pyc: genprime.py
	python -c "import py_compile; py_compile.compile(\"genprime.py\");"
