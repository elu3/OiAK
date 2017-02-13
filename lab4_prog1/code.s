.data
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512
format1: .ascii "wpisz ilosc poziomow polchoinki \n\0"
format2: .ascii "%d\0" # string formatujacy do scanf
.bss
.comm textin, 512
.comm textout, 512
.comm data1, 8
.text
.globl main
.global funkcja1
main:
push %rbp
mov %rsp, %rbp


#printf, %rcx - wynik
mov $0, %rcx
push %rax
push %rcx
mov %rcx, %rsi
mov $format1, %rdi
mov $0, %rax #ile dodatkowych zmiennych argumentow bedzie
call printf
pop %rcx
pop %rax
#end printf


mov $1, %rax #ile dodatkowych zmiennych argumentow bedzie
mov $format2, %rdi
mov $data1, %rsi
call scanf


movq data1, %rcx

mov %rcx, %rdi
call funkcja1

#end
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
