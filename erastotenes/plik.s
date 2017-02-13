%define SUCCESS 0
%define MIN_MAX_NUMBER 3
%define MAX_MAX_NUMBER 4294967294

global _main
extern _printf
extern _scanf
extern _malloc
extern _free

;подписи ввода-вывода, форматы
str_max_number_label: db "Max number (>=3): ", 0
str_max_number_input_format: db "%u", 0
str_max_number_output_format: db "Using max number %u", 0xD, 0xA, 0

str_print_primes_label: db "Primes:", 0xD, 0xA, 0
str_prime: db "%u", 0x9, 0
str_cr_lf: db 0xD, 0xA, 0
	
;сообщения выхода
str_exit_success: db "Success!", 0xD, 0xA, 0
str_error_max_num_too_little: db "Max number is too little!", 0xD, 0xA, 0
str_error_max_num_too_big: db "Max number is too big!", 0xD, 0xA, 0
str_error_malloc_failed: db "Can't allocate memory!", 0xD, 0xA, 0


SECTION .text
_main:
	enter 0, 0
	
	;ввод максимального числа
	call input_max_number
	cmp edx, SUCCESS
	jne .custom_exit
	mov [max_number], eax
	
	;выделяем память для массива флагов
	mov eax, [max_number]
	call allocate_flags_memory
	cmp edx, SUCCESS
	jne .custom_exit
	mov [primes_pointer], eax
	
	;отсеять составные числа
	mov eax, [primes_pointer]
	mov ebx, [max_number]
	call find_primes_with_eratosthenes_sieve
	
	;вывести числа
	mov eax, [primes_pointer]
	mov ebx, [max_number]
	call print_primes
	
	;освободить память от массива флагов
	mov eax, [primes_pointer]
	call free_flags_memory
	
	;выход
	.success:
		push str_exit_success
		call _printf
		jmp .return
			
	.custom_exit:
		push edx
		call _printf
		
	.return:
		mov eax, SUCCESS
		leave
		ret
	
	%include "functions.asm"

SECTION .data
	max_number: dd 0
	primes_pointer: dd 0
	
	%include "string_constants.asm"





