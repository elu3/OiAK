zadanie:	code.o lib
	g++ -m64 -o zadanie  code.o -L. -lmylib -Wl,-rpath,'$$ORIGIN'
code.o:	code.s
	as -o code.o code.s
clean:
	rm *.o zadanie libmylib.so
lib: mylib.c
	gcc -fPIC -shared mylib.c -o libmylib.so