;Вариант №3
;Дано число в двоичном виде. Поменять местами старшую и младшую
;части числа. Полученное значение разделить на 32 и проинвертировать. 

.386
.model flat, stdcall
option casemap :none
include includes\masm32.inc
include includes\kernel32.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib

.data
	text_zero db "0"
	text_one db "1"
	text_entered db "Enter BiNumber: "
	text_retry_entered db 10, "You entered the number: "
	text_reverse db 10, "Reverse BiNumber: "
	text_division db 10, "Reverse BiNumber/32: "
	text_inverted db 10, "Inverted BiNumber: "
	
	minBit dd 0
	maxBit dd 8
	
	index dd 8
	
.data?
	bit_buffer dd ?
	enter_binumber db ?
	result_enter_binumber db ?
	
	STD_INPUT dd ?
	STD_OUTPUT dd ?
	INPUT_BUFFER dd ?
	OUTPUT_BUFFER dd ?
	
	
.code
	start:
		invoke GetStdHandle, -10
		mov STD_INPUT, eax
		invoke GetStdHandle, -11
		mov STD_OUTPUT, eax
		
		invoke WriteConsole, STD_OUTPUT, addr text_entered, sizeof text_entered, addr OUTPUT_BUFFER, 0
		invoke SetConsoleMode, STD_INPUT, 0
		
		@check_entered:
			
				invoke ReadConsole, STD_INPUT, addr bit_buffer, 1, addr INPUT_BUFFER, 0
				mov eax, bit_buffer
				
				cmp eax, 13
					je @press_enter
					
				cmp eax, 1h
					je @check_entered
				
				cmp eax, 30h
					je @if_number_zero
				
				cmp eax, 31h
					je @if_number_one
				
				cmp eax, 1
					jg @check_entered
				
				cmp eax, 0
					jl @check_entered
				
				@press_enter:
					mov maxBit, 1
					jmp @result
							
				@if_number_zero:
					invoke WriteConsole, STD_OUTPUT, addr bit_buffer, 1, addr OUTPUT_BUFFER, 0
					shl enter_binumber, 1
					jmp @result
					
				@if_number_one:
					invoke WriteConsole, STD_OUTPUT, addr bit_buffer, 1, addr OUTPUT_BUFFER, 0
					add enter_binumber, 1
					shl enter_binumber, 1
					jmp @result
					
				@result:
					dec maxBit
					mov eax, maxBit
					jnz @check_entered
					rcr enter_binumber, 1
			 
			 	
		@input_result:
			
				invoke WriteConsole, STD_OUTPUT, addr text_retry_entered, sizeof text_retry_entered, addr OUTPUT_BUFFER, 0
				
				mov ah, enter_binumber
				mov result_enter_binumber, ah
				mov index, 0
				
				@input_bits_binumber:
					inc index
					cmp index, 9
						je @end_input_bits_binumber
					
					shl result_enter_binumber, 1
						jc @bit_one
						jnc @bit_zero
					
				@bit_one:
					invoke WriteConsole, STD_OUTPUT, addr text_one, 1, addr OUTPUT_BUFFER, 0
					jmp @input_bits_binumber
					
				@bit_zero:
					invoke WriteConsole, STD_OUTPUT, addr text_zero, 1, addr OUTPUT_BUFFER, 0
					jmp @input_bits_binumber
				
				@end_input_bits_binumber:
					 
			
			
		invoke WriteConsole, STD_OUTPUT, addr text_reverse, sizeof text_reverse, addr OUTPUT_BUFFER, 0
			
		@reverse_binumber:
			
			mov al, enter_binumber
			mov ah, enter_binumber
			
			and al, 00001111b
			and ah, 11110000b
			
			rcl al, 4
			rcr ah, 4
			or al, ah
			
			mov enter_binumber, al
			mov al, enter_binumber
			mov result_enter_binumber, al
			
			mov index, 0
			
			@input_result_reverse:
				inc index
				cmp index, 9
					je @end_input_result_reverse
					
				shl result_enter_binumber, 1
					jc @reverse_bit_one
					jnc @reverse_bit_zero
			
				@reverse_bit_one:
					invoke WriteConsole, STD_OUTPUT, addr text_one, 1, addr OUTPUT_BUFFER, 0
					jmp @input_result_reverse
					
				@reverse_bit_zero:
					invoke WriteConsole, STD_OUTPUT, addr text_zero, 1, addr OUTPUT_BUFFER, 0
					jmp @input_result_reverse
				
			@end_input_result_reverse:
				
				
			
			
		invoke WriteConsole, STD_OUTPUT, addr text_division, sizeof text_division, addr OUTPUT_BUFFER, 0
			
		@division_reverse_binumber:
		;для деления двоичного числа на 2^n необходимо произвести сдвиг его содержимого на n разрядов в правую сторону
				shr enter_binumber, 5
				
				mov al, enter_binumber
				mov enter_binumber, al
				mov result_enter_binumber, al
				
				mov index, 0
				@input_division_binumber:
					inc index
					cmp index, 9
						je @end_input_division_binumber
						
					shl result_enter_binumber, 1
						jc @division_bit_one
						jnc @division_bit_zero
					
				
				@division_bit_one:
					invoke WriteConsole, STD_OUTPUT, addr text_one, 1, addr OUTPUT_BUFFER, 0
					jmp @input_division_binumber
					
				@division_bit_zero:
					invoke WriteConsole, STD_OUTPUT, addr text_zero, 1, addr OUTPUT_BUFFER, 0
					jmp @input_division_binumber
				
			@end_input_division_binumber:			
				
					
					
				
				
		invoke WriteConsole, STD_OUTPUT, addr text_inverted, sizeof text_inverted, addr OUTPUT_BUFFER, 0
					
		@inverted_binumber:
					
				not enter_binumber
				
				mov al, enter_binumber
				mov result_enter_binumber, al
				mov index, 0
				
				@input_inverted_binumber:
					inc index
					cmp index, 9
					je @end_inverted_binumber
					
					shl result_enter_binumber, 1
						jc @inverted_bit_one
						jnc @inverted_bit_zero
					
				
				@inverted_bit_one:
					invoke WriteConsole, STD_OUTPUT, addr text_one, 1, addr OUTPUT_BUFFER, 0
					jmp @input_inverted_binumber
					
				@inverted_bit_zero:
					invoke WriteConsole, STD_OUTPUT, addr text_zero, 1, addr OUTPUT_BUFFER, 0
					jmp @input_inverted_binumber
				
			@end_inverted_binumber:
				
		
	end start
