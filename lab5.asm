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
	
	endl db 10
	
	num db ?
	newNum db ?
	buff dd ?
	
	STD_INPUT dd ?
	STD_OUTPUT dd ?
	INPUT_BUFFER dd ?
	OUTPUT_BUFFER dd ?
	
	count dd 8
	
	
	
.code
	start:
		invoke GetStdHandle, -10
		mov STD_INPUT, eax
		invoke GetStdHandle, -11
		mov STD_OUTPUT, eax
		
		invoke WriteConsole, STD_OUTPUT, addr text_entered, sizeof text_entered, addr OUTPUT_BUFFER, 0
		invoke SetConsoleMode, STD_INPUT, 0
		
		@check_entered:
			
			invoke ReadConsole, STD_INPUT, addr buff, 1, addr INPUT_BUFFER, 0
			mov eax, buff
			
			cmp eax, 13
			je interruptionDoneNum
			
			sub eax, 30h
			jz @if_number_zero
			
			cmp eax, 1
			jne @if_number_unknow
			
			invoke WriteConsole, STD_OUTPUT, addr buff, 1, addr OUTPUT_BUFFER, 0
			add num, 1
			shl num, 1
			jmp doneNum
			
			@if_number_zero:
				invoke WriteConsole, STD_OUTPUT, addr buff, 1, addr OUTPUT_BUFFER, 0
				shl num, 1
				jmp doneNum
				
			@if_number_unknow:
				jmp @check_entered
				
			interruptionDoneNum:
				mov count, 1
				
			doneNum:
				dec count
				mov eax, count
				jnz @check_entered
				
			rcr num, 1
			
			invoke WriteConsole, STD_OUTPUT, addr text_retry_entered, sizeof text_retry_entered, addr OUTPUT_BUFFER, 0
			
			
			mov al, num
			mov newNum, al
			
			mov count, 0
			printNum:
				inc count
				cmp count, 9
				je exitOfPrint
				shl newNum, 1
				jc oneBit
				invoke WriteConsole, STD_OUTPUT, addr text_zero, 1, addr OUTPUT_BUFFER, 0
				jmp printNum
			
			oneBit:
				invoke WriteConsole, STD_OUTPUT, addr text_one, 1, addr OUTPUT_BUFFER, 0
				jmp printNum
			
			exitOfPrint:
			
			invoke WriteConsole, STD_OUTPUT, addr text_reverse, sizeof text_reverse, addr OUTPUT_BUFFER, 0 
			mov al, num
			mov ah, num
			and al, 00001111b
			and ah, 11110000b
			rcl al, 4
			rcr ah, 4
			or al, ah
			mov num, al
			mov al, num
			mov newNum, al
			
			mov count, 0
			afterSwapPrintNum:
				inc count
				cmp count, 9
				je afterSwapExitOfPrint
				shl newNum, 1
				jc afterSwapOneBit
				invoke WriteConsole, STD_OUTPUT, addr text_zero, 1, addr OUTPUT_BUFFER, 0
				jmp afterSwapPrintNum
			
			afterSwapOneBit:
				invoke WriteConsole, STD_OUTPUT, addr text_one, 1, addr OUTPUT_BUFFER, 0
				jmp afterSwapPrintNum
			
			afterSwapExitOfPrint:
				
			invoke WriteConsole, STD_OUTPUT, addr text_division, sizeof text_division, addr OUTPUT_BUFFER, 0
			
			
			
			shr num, 5
			
			mov al, num
			mov num, al
			mov newNum, al
			
			mov count, 0
			afterDivPrintNum:
				inc count
				cmp count, 9
				je afterDivExitOfPrint
				shl newNum, 1
				jc afterDivOneBit
				invoke WriteConsole, STD_OUTPUT, addr text_zero, 1, addr OUTPUT_BUFFER, 0
				jmp afterDivPrintNum
			
			afterDivOneBit:
				invoke WriteConsole, STD_OUTPUT, addr text_one, 1, addr OUTPUT_BUFFER, 0
				jmp afterDivPrintNum
			
			afterDivExitOfPrint:
				
			invoke WriteConsole, STD_OUTPUT, addr text_inverted, sizeof text_inverted, addr OUTPUT_BUFFER, 0
				
			not num
			
			mov al, num
			mov newNum, al
			
			mov count, 0
			afterNegPrintNum:
				inc count
				cmp count, 9
				je afterNegExitOfPrint
				shl newNum, 1
				jc afterNegOneBit
				invoke WriteConsole, STD_OUTPUT, addr text_zero, 1, addr OUTPUT_BUFFER, 0
				jmp afterNegPrintNum
			
			afterNegOneBit:
				invoke WriteConsole, STD_OUTPUT, addr text_one, 1, addr OUTPUT_BUFFER, 0
				jmp afterNegPrintNum
			
			afterNegExitOfPrint:
				
			invoke WriteConsole, STD_OUTPUT, addr endl, sizeof endl, addr OUTPUT_BUFFER, 0
		
	end start
