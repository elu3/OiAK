.data
newline: .ascii "\n\0"
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 1024
.bss
.comm textin, 1024
.comm textin2,1024
.comm texta1,1024
.comm texta2,1024
.comm textout, 1024
.comm textout2,1024
.comm out, 1026
.text





daj_ascii:
lea    0x30(%rdi),%eax #48 dodawanie
lea    0x37(%rdi),%edx #55
cmp    $0x9,%edi # dla liczb, 9 liczb
cmovg  %edx,%eax
retq   

daj_num:
xor    %eax,%eax
test   %dil,%dil#do
je     r
cmp    $0x40,%dil
movsbl %dil,%eax
jg     f
sub    $0x30,%eax
retq   
f:
sub    $0x37,%eax
r:
retq 


#void dodaj16(char* out, char* in1, char* in2, char* al1, char* al2, int len1, int len2){
dodaj16:
push   %r15 # out
push   %r14 #len1
push   %r13 #len2
push   %r12 #al1
mov    %rdi,%r12
push   %rbp
push   %rbx
movslq %r9d,%rbx
mov    %rbx,%r13
sub    $0x10,%rsp      # rezerwuje miejsce na stosie
mov    0x48(%rsp),%edi # aby uzyskac liczby
cmp    %edi,%r9d      
mov    %edi,%r11d
movslq %edi,%r15
cmovge %r9d,%r11d
sub    %r15,%r13
sub    %rbx,%r15

mov    %r11d,%r10d

mov    %r11d,%r14d

  
xor    %eax,%eax

sub    %r9d,%r10d
add    %rsi,%r13
sub    %edi,%r14d
add    %rdx,%r15

  etykieta6:	
cmp    %r11d,%eax    #porownanie dlugosci len1 i len2
mov    %eax,%ebx
jge    etykieta_10   
cmp    %edi,%r9d
jne    etykietka 
mov    (%rsi,%rax,1),%bl # dla rownych przepisuje bufory ( nie wstawia zer)
mov    %bl,(%rcx,%rax,1)
mov    (%rdx,%rax,1),%bl
mov    %bl,(%r8,%rax,1)
jmp    etykieta4 

  etykietka:	
jle    etykieta2 # l1 wieksze
mov    (%rsi,%rax,1),%bpl
mov    %bpl,(%rcx,%rax,1)#    
xor    %ebp,%ebp
cmp    %r14d,%ebx
jl     etykieta3
mov    (%r15,%rax,1),%bpl

  etykieta3:	
mov    %bpl,(%r8,%rax,1)
jmp    etykieta4;

  etykieta2:	# len2 wieksze
mov    (%rdx,%rax,1),%bpl
mov    %bpl,(%r8,%rax,1)#      
xor    %ebp,%ebp
cmp    %r10d,%ebx
jl     etykieta5 
mov    0x0(%r13,%rax,1),%bpl
etykieta5:	
mov    %bpl,(%rcx,%rax,1)
#
 etykieta4:	
 movb   $0x0,(%r12,%rax,1)
inc    %rax
jmp    etykieta6

etykieta_10:
lea    -0x1(%r11),%r14  # uzpelnia zerami
movslq %r11d,%rax
xor    %ebx,%ebx
movb   $0x0,(%r12,%rax,1)
movb   $0x0,0x1(%r12,%rax,1)
xor    %ebp,%ebp
movslq %r14d,%r14
lea    (%rcx,%r14,1),%rax
lea    (%r8,%r14,1),%r13
add    %r12,%r14
mov    %rax,(%rsp)
  etykieta8:
dec    %rbx
mov    %r11d,%eax
add    %ebx,%eax
js     etykieta7
mov    (%rsp),%rax
mov    %r11d,0xc(%rsp)
movsbl 0x1(%rax,%rbx,1),%edi
callq  daj_num
movsbl 0x1(%r13,%rbx,1),%edi
mov    %eax,%r15d#
callq  daj_num # overflow
add    %eax,%r15d
lea    (%r15,%rbp,1),%edi#    overflow = (w >> 4);
mov    %edi,%ebp#    out[i+2] = daj_ascii(w & 0xF);
and    $0xf,%edi    #
callq  daj_ascii
sar    $0x4,%ebp
mov    %al,0x3(%r14,%rbx,1)
mov    0xc(%rsp),%r11d
jmp    etykieta8

 etykieta7: #rowne dlugosci	
test   %ebp,%ebp
je     etykieta9# rowne dlugosci
mov    %ebp,%edi
callq  daj_ascii
mov    %al,0x1(%r12)
  etykieta9:	add    $0x10,%rsp
pop    %rbx
pop    %rbp
pop    %r12
pop    %r13
pop    %r14
pop    %r15
retq   
nop



.globl _start
_start:
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall
movq %rax, %r9 #zaladuj dlugosc jako przedostatni argument
dec %r9 #zmniejsz dlugosc o 1 - nie liczymy znaku konca linii

movq %rax,%rcx # dlugosc text1
movq %rdx,%rbx


movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin2, %rsi
movq $BUFLEN, %rdx
syscall
dec %rax #zmniejsz dlugosc o 1 - nie liczymy znaku konca linii
push %rax # ostatni, 7-my argument na stos

#wczytano text
# x86_64 caling convention nakazuje kolejnosc argumentow : rdi, rsi, rdx, rcx, r8, r9, dalsze ewentualne na stos
movq $out, %rdi #zaladuj 6 pierwszych argumentow
movq $textin, %rsi
movq $textin2, %rdx
movq $texta1, %rcx
movq $texta2, %r8
callq dodaj16

pop %rax

#przesun poczatek out bufora na pierwsza niezerowa wartosc

xor   %rbx, %rbx
dec   %rbx
aa:
inc %rbx
movq $out, %r9
add %rbx, %r9
movb   (%r9),%al
cmp   $0,%al # sprawdza czy zero na ov
je aa
movq $out, %rcx
add %rbx, %rcx #teraz %rcx ma realny adres bufora

#drukuj bufor
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq %rcx, %rsi
movq $BUFLEN, %rdx
syscall

#drukuj koniec linii
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $newline, %rsi
movq $1, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
