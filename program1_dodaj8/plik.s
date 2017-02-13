.data
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512
.bss
.comm textin, 512
.comm textout, 512
.text
.globl _start
_start:
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall



dec %rax #rax - ilosc znakow wczytanych, bez \n
movq $0, %rcx #licznik - countup

######################per letter
begin_f:
cmp %rcx, %rax
je cont #break looping over letters

movb textin(,%rcx,1), %bl #bl - wczytana litera, pobranie wartosci i zapis w bl

cmp $65, %bl
jl func_end

cmp $90, %bl
jg check_for_small
add $8, %bl #mamy wielka litere
jmp func_end

check_for_small:
cmp $97, %bl
jl func_end
cmp $122, %bl
jg func_end
add $6, %bl #mamy mala litere

func_end:
movb %bl, textout(,%rcx,1)
inc %rcx
jmp begin_f
############################ per letter

cont:
movb $'\n', textout(, %rcx, 1) #dodaj znak konca lini

inc %rax # include /n in result

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

#duze litery [65,90]  +8
#male litery [97,122] +6
