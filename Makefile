ARGS=50000 500000

all: genprime-java genprime-c genprime-py

clean:
	rm -f genprime.pyc genprime.class genprime

version:
	gcc -v
	java -version
	perl -v | grep built\ for
	php --version
	python --version
	ruby --version

run: all
	@echo "genprime (C)"
	@./genprime $(ARGS)
	@echo
	@echo "genprime (Java)"
	@java genprime $(ARGS)
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

genprime-c: genprime

genprime: genprime.c
	gcc -O3 -ansi -pedantic -Wall -o genprime genprime.c

genprime-py: genprime.pyc

genprime.pyc: genprime.py
	python -c "import py_compile; py_compile.compile(\"genprime.py\");"
