.data
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512
format1: .ascii "Najwiekszy wspolny dzielnik to : %d\n\0"
.bss
.comm textin, 512
.comm textout, 512
.text
.globl main


gcd_external:# w r9 wartosc powrotu
pop %r9 #sciagnij adres powrotu ze stosu
pop %rdi# drugi
pop %rsi# pierwszy
callq gcd
push %r9 #przywroc adres powrotu na stos
retq

gcd:
push   %rbp
mov    %rsp,%rbp
sub    $0x10,%rsp
mov    %edi,-0x4(%rbp)
mov    %esi,-0x8(%rbp)
cmpl   $0x0,-0x8(%rbp)
jne    l1 
mov    -0x4(%rbp),%eax
jmp    l2 
l1:	
mov    -0x4(%rbp),%eax
mov    $0x0,%edx
divl   -0x8(%rbp)
mov    -0x8(%rbp),%eax
mov    %edx,%esi
mov    %eax,%edi
callq  gcd 
l2:
leaveq 
retq

read_num:
#czytaj liczbe 10kowo
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
mov $1, %r14 #power of 10

func:
movb textout(,%r9,1), %bl #bl - wczytana litera
xor %rax,%rax
sub $48,%bl #odejmij od kodu ascii
movb %bl, %al
mul %r14
add %rax, %rcx
inc %r9
mov %r14,%rax
mov $10, %rbx #domnazaj potege 10
mul %rbx
mov %rax,%r14
cmp %r9, %r10
jne func
retq


main:
push %rbp
mov %rsp, %rbp

callq read_num #czytaj pierwsza liczbe
push %rcx #zapisz jako pierwszy argument
callq read_num
push %rcx #zapisz jako drugi argument

xor %rax, %rax
callq gcd_external
movq %rax, %rcx

#printf, %rcx - wynik
push %rax
push %rcx
mov %rcx, %rsi
mov $format1, %rdi
mov $0, %rax
call printf
pop %rcx
pop %rax
#end printf

#end
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
