ifdef SystemRoot
   format = win32
   rm = del
   ext = .exe
else
   format = elf
   rm = rm -f
   ext = 
endif

all: primes.o
	g++ primes.o -o primes$(ext)
	$(rm) primes.o

primes.o:
	nasm -f $(format) main.asm -o primes.o 
