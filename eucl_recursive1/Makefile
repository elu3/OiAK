stos:	code_stos.o
	gcc -m64 -o out_stos  code_stos.o
code_stos.o:	code_stos.s
	as -o code_stos.o code_stos.s

reg:	code_reg.o
	gcc -m64 -o out_reg  code_reg.o
code_reg.o:	code_reg.s
	as -o code_reg.o code_reg.s
	
clean:
	@rm -f out_stos out_reg *.o
