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