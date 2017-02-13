.data
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512
format1: .ascii "najwiekszy wspolny dzielnik to : %d\n\0"
.bss
.comm textin, 512
.comm textout, 512
.text
.globl main


gcd:# algorytm
push   %rbp
mov    %rsp,%rbp
sub    $0x10,%rsp # 16 bajtow odlicza na zmienne
mov    %edi,-0x4(%rbp)# druga
mov    %esi,-0x8(%rbp)# pierwsza
cmpl   $0x0,-0x8(%rbp)# czy esi wieksze od zera
jne    l1 
mov    -0x4(%rbp),%eax #wczytanie to eax
jmp    l2 
 l1:	#liczba nie jest zerem
mov    -0x4(%rbp),%eax # druga
mov    $0x0,%edx       # tu bedzie reszta
divl   -0x8(%rbp)    # druga/pierwsza
mov    -0x8(%rbp),%eax #pierwsza 
mov    %edx,%esi #reszta
mov    %eax,%edi # pierwsza staje sie druga liczba
callq  gcd # rekursywna
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
cmp %r15,%rax# r15-licznik
je end
movq %rax, %r10 # dl w r10
sub %r15,%r10   #dl-licznik
dec %r10        # ostatni nieprzerobiony
movb textin(,%r10,1), %bl # pobieramy ostatni
movb %bl,textout(,%r15,1) # zapisujemy jako na odpowiednim miejscu od 0 
cmp %r15,%rax  
inc %r15 # zwiekszamy licznik
jne rev 
end:
#end rev

mov %rax, %r10 #num, ilosc cyfr dziesietnych
xor %rcx, %rcx #zero

mov $0, %r9 #counter
mov $1, %r14 #power of 10, na poczatku 1

func:# usyskujemy liczby z ASCII
movb textout(,%r9,1), %bl #bl - wczytana litera
xor %rax,%rax
sub $48,%bl #odejmij od kodu ascii
movb %bl, %al
mul %r14 #mnoz przez potege na poczatku -1
add %rax, %rcx # dodaj do wyniku, wynik w rcx
inc %r9# licznik
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
push %rcx #zapisz jako pierwszy argument, bo by sie dublowalo
callq read_num
movq %rcx, %rdi #zapisz jako drugi argument przekazywanie przez rejestry
pop %rsi # rsi-pierwszy

xor %rax, %rax
callq gcd
movq %rax, %rcx # z gdc

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
