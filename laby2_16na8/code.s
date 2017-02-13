.data
BUFLEN = 1024
OUTLEN = 0x559
filename1: .ascii "data\0"
filename2: .ascii "wynik8.txt\0"
fileformat1: .ascii "rb\0"
fileformat2: .ascii "wb\0"
.bss
.comm text_wczytany 1024
.comm out_ascii 0x559; #1024 * 4/3 + 4(zapas)
.text
.globl main

get_value: #zamien ascii na liczbe, dozwolone znaki : [0-9,A-F]
xor    %eax,%eax
test   %edi,%edi     #and bez zapisu, ustawia flagi        	
je zdejmij_ze_stosu	
cmp $0x39,%edi #57 czyli 9
jg litera        	
lea    -0x30(%rdi),%eax # kod binarny liczba
retq   
litera:
lea    -0x37(%rdi),%eax #kod binarny litery
zdejmij_ze_stosu:                   	
retq #zdejmij ze stosu

main:
push   %rbp #wskaznik dolu stosu     	
mov    %rsp, %rbp # wskaznik stosu rsp
sub    $0x10,%rsp #zarezerwuj troche miejsca na stosie 16 znakow
mov $filename1, %edi
mov $fileformat1, %esi
callq  fopen	#otworz plik "data" - uwaga, ma nie byc znaku konca lini ! (sprawdz w konsoli co tam siedzi tak: "xxd data")
mov    $0x1,%edx 
mov    %rax,%rbp	
mov    %rax,%rcx # rax to co zwrocilo fopen-wskaznik na plik
mov    $0x400,%esi	#1024
mov    $text_wczytany,%edi	
callq  fread
mov    %rbp,%rdi
callq  ftell	#wczytaj dlugosc pliku # aktualna pozycja wskaznika pliku
mov    %rbp,%rdi          	
mov    %rax,%rbx               	
xor    %ebp,%ebp#basepointer	
callq fclose            	
dec    %ebx
	
movl   $0x0,0xc(%rsp)# wrzuć zero do miejsca rsp+12
beginloop:
mov    %ebp,%eax
mov    %ebp,%r12d             	
neg    %eax
#rozpocznij petle, rbx - licznik, maleje co 3 liczac od konca bufora          	
#czytaj w paczkach po 3 bajty
test   %ebx,%ebx
js     l1 
movslq %ebx,%rax # mov z konwersja
movl   $0x0,0xc(%rsp) #zapisz na stos
movsbl text_wczytany(%rax),%edi	
callq get_value	
mov    0xc(%rsp),%edx #sciagnij ze stosu do edx
movsbl %al,%eax
or     %edx,%eax
test   %ebx,%ebx
mov    %eax,0xc(%rsp)
je     endloop
lea    -0x1(%rbx),%eax    # roznica   	
cltq   
movsbl text_wczytany(%rax),%edi
callq  get_value
mov    0xc(%rsp),%edx	
movsbl %al,%eax #wartosc 16-kowa ASCII do eax
shl    $0x4,%eax
or     %edx,%eax #dodawanie bitow w petli do wyjscia
cmp    $0x1,%ebx #licznik
mov    %eax,0xc(%rsp)# eax na miejsce stos +12
je    endloop
lea    -0x2(%rbx),%eax   #rbx-2	
cltq  #signed int na signed long w $rax
movsbl text_wczytany(%rax),%edi
callq  get_value
mov    0xc(%rsp),%edx	
movsbl %al,%eax	
shl    $0x8,%eax
or     %edx,%eax
mov    %eax,0xc(%rsp)
endloop:
#zapisz nasze 12 bitow do 4 znakow systemu 8-kowego
mov    0xc(%rsp),%eax
lea    0x558(%r12),%edx #najmlodszy znak - 3 bity, wez adres konca bufora
sub    $0x3,%ebx #cofnij licznik petli o 3
sub    $0x4,%rbp #przesun wskaznik bufora wyjsciowego o 4
and    $0x7,%eax #wyluskaj 3 najmlodsze bity
add    $0x30,%eax	
mov    %al,out_ascii(%rdx)   #pisz te 3 bity do bufora
mov    0xc(%rsp),%eax #przywroc oryginalna zmienna ze stosu do eax, i powtorz na nastepnej trojce bitow
shr    $0x3,%eax #3 bity w prawo
and    $0x7,%eax #wyluskaj kolejne 3 bity, itp..
add    $0x30,%eax
lea    0x557(%r12),%edx
mov    %al,out_ascii(%rdx)        	
mov    0xc(%rsp),%eax
lea    0x556(%r12),%edx	
shr    $0x6,%eax
and    $0x7,%eax
add    $0x30,%eax
mov    %al,out_ascii(%rdx)     	
mov    0xc(%rsp),%eax
lea    0x555(%r12),%edx             	
shr    $0x9,%eax
and    $0x7,%eax
add    $0x30,%eax
mov    %al,out_ascii(%rdx)
jmp   beginloop #powtorz procedure z nastepna paczka 12 bitow, itd az do konca
l1:
#koniec petli 
mov    %eax,%r12d	
mov    $out_ascii,%ebx

sub %eax, %ebx
mov $0x559,%eax
add %eax, %ebx
#zapisz wynik do pliku wynik8.txt
mov $filename2, %edi
mov $fileformat2, %esi
callq  fopen
mov    %r12,%rsi
mov    %rax,%rbp
mov    %rbx,%rdi
mov    %rax,%rcx
mov    $0x1,%edx
callq  fwrite
mov    %rbp,%rdi
callq  fclose
add    $0x10,%rsp #zwolnij miejsce ze stosu przed opuszczeniem maina
xor    %eax,%eax
pop    %rbp    #sciagnij base pointer ze stosu, zostaw adres powrotu na jego gorze         	
ret 