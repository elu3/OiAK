.DEFAULT_GOAL := all
reg:	code_as
	g++ -fPIC -shared -m64 -o libout.so  code_as.o
code_as:
	as -o code_as.o code_as.s
all: reg
	g++ -fPIC -g main.c -o out -L. -lout -ldl
	
clean:
	@rm -f *.so out *.o *.out
