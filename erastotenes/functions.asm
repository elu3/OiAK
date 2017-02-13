; Ввести максимальное число
; Результат: EAX - максимальное число
input_max_number:	
	;создать стек-фрейм,
	;4 байта для локальных переменных
	enter 4, 1

	;показываем подпись
	push str_max_number_label ;см. string_constants.asm
	call printf
	add esp, 4

	;вызываем scanf
	mov eax, ebp
	sub eax, 4
	
	push eax
	push str_max_number_input_format ;см. string_constants.asm
	call _scanf
	add esp, 8
	
	mov eax, [ebp-4]

	;проверка
	cmp eax, MIN_MAX_NUMBER
	jb .number_too_little
	cmp eax, MAX_MAX_NUMBER
	ja .number_too_big
	jmp .success

	;выход
	.number_too_little:
		mov edx, str_error_max_num_too_little ;см. string_constants.asm
		jmp .return	
		
	.number_too_big:
		mov edx, str_error_max_num_too_big ;см. string_constants.asm
		jmp .return	

	.success:
		push eax
		push str_max_number_output_format ;см. string_constants.asm
		call printf
		add esp, 4
		pop eax
		mov edx, SUCCESS
	
	.return:
		leave
		ret
		
		mov eax, ebp
        sub eax, 4
	
        push eax
        push str_max_number_input_format ;см. string_constants.asm
        call _scanf
        add esp, 8
	
        mov eax, [ebp-4]
        
        ; Выделить память для массива флагов
; Аргумент: EAX - максимальное число
; Результат: EAX - указатель на память
allocate_flags_memory:
	enter 8, 1

	;выделить EAX+1 байт
	inc eax
	mov [ebp-4], eax
	
	push eax
	call _malloc
	add esp, 4
	
	;проверка
	cmp eax, 0
	je .fail
	mov [ebp-8], eax
	
	;инициализация
	mov byte [eax], 0
	
	cld
	mov edi, eax
	inc edi
	mov edx, [ebp-4]
	add edx, eax
	
	mov al, 1
	.write_true:
		stosb
		cmp edi, edx
		jb .write_true
	
	;выход
	mov eax, [ebp-8]
	jmp .success
	
	.fail:
		mov edx, str_error_malloc_failed ;см. string_constants.asm
		jmp .return
	
	.success:
		mov edx, SUCCESS
			
	.return:
		leave
		ret

; Освободить память от массива флагов
; Аргумент: EAX - указатель на память
free_flags_memory:
	enter 0, 1
	
	push eax
	call _free
	add esp, 4
	
	leave
	ret
	
	;Найти простые числа с помощью решета Эратосфена
;Аргументы: EAX - указатель на массив флагов, EBX - максимальное число	
find_primes_with_eratosthenes_sieve:
	enter 8, 1
	mov [ebp-4], eax
		
	add eax, ebx
	inc eax
	mov [ebp-8], eax
	
	;вычеркиваем составные числа
	cld
	mov edx, 2 ;p = 2
	mov ecx, 2 ;множитель с = 2
	.strike_out_cycle:
		;x = c*p
		mov eax, edx
		push edx
		mul ecx
		pop edx
		
		cmp eax, ebx
		jbe .strike_out_number
		jmp .increase_p
		
		.strike_out_number:
			mov edi, [ebp-4]
			add edi, eax
			mov byte [edi], 0
			inc ecx ;c = c + 1
			jmp .strike_out_cycle
			
		.increase_p:
			mov esi, [ebp-4]
			add esi, edx
			inc esi
			
			mov ecx, edx
			inc ecx
			.check_current_number:
				mov eax, ecx
				mul eax
				cmp eax, ebx
				ja .return
			
				lodsb
				inc ecx
				cmp al, 0
				jne .new_p_found
				jmp .check_current_number
			
				.new_p_found:
					mov edx, ecx
					dec edx
					mov ecx, 2
					jmp .strike_out_cycle			
	
	.return:
		leave
		ret
		
		; Вывести простые числа
; Параметры: EAX - указатель на массив флагов, EBX - максимальное число
print_primes:
	enter 12, 1
	mov [ebp-4], eax
	mov [ebp-8], ebx
	
	push str_print_primes_label
	call printf
	add esp, 4
	
	cld
	mov esi, [ebp-4]
	mov edx, esi
	add edx, [ebp-8]
	inc edx
	
	mov [ebp-12], edx
	mov ecx, 0
	.print_cycle:
		lodsb
		cmp al, 0
		jne .print
		jmp .check_finish
		.print:
			push esi
			push ecx
			push str_prime ;см. string_constants.asm
			call printf
			add esp, 4
			pop ecx
			pop esi
			mov edx, [ebp-12]
		.check_finish:
			inc ecx
			cmp esi, edx
			jb .print_cycle
			
	push str_cr_lf
	call printf
	add esp, 4
			
	leave
	ret
