.data
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512
format1: .ascii "dziesietnie to bedzie : %d\n\0"
.bss
.comm textin, 512
.comm textout, 512
.text
.globl main
main:
#czytaj liczbe 7kowo
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

dec %rax #nie licz konca lini
#odwroc tekst, pisz do tekstout
movq $0,%r15
rev:
cmp %r15,%rax
je end
movq %rax, %r10
sub %r15,%r10
dec %r10
movb textin(,%r10,1), %bl
movb %bl,textout(,%r15,1)
cmp %r15,%rax
inc %r15
jne rev
end:
#end rev

mov %rax, %r10 #num, ilosc cyfr siodemkowych
xor %rcx, %rcx #zero

mov $0, %r9 #counter
mov $1, %r14 #power of 7

func:
movb textout(,%r9,1), %bl #bl - wczytana litera
xor %rax,%rax
sub $48,%bl #odejmij od kodu ascii, wartosc w int
movb %bl, %al
mul %r14# power of 7 * cyfra
add %rax, %rcx
inc %r9
mov %r14,%rax
mov $7, %rbx #domnazaj potege 7
mul %rbx
mov %rax,%r14
cmp %r9, %r10
jne func

#printf, %rcx - wynik
mov %rcx, %rsi# arg dla printf( int,adres b, format)
mov $format1, %rdi
mov $0, %rax
call printf
#end printf

#end
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
