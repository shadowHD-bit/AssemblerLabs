;ab + c/d + ef(g + h) + k/m - мой 8 вариант
; (a + b)/с+d + efg + hk/m - 3 вариант
.386
.model flat, stdcall
option casemap :none
include includes\windows.inc
include includes\masm32.inc
include includes\kernel32.inc
includelib includes\masm32.lib
includelib includes\kernel32.lib


BSIZE equ 10
.data

	tempOne dd 0 
	decDecimal dd 10d
	divDecimal dw 10d
	txtA db "A = ", 0
	txtB db "B = ", 0
	txtC db "C = ", 0
	txtD db "D = ", 0
	txtE db "E = ", 0
	txtF db "F = ", 0
	txtG db "G = ", 0 
	txtH db "H = ", 0
	txtK db "K = ", 0
	txtM db "M = ", 0
	txtResult db "AB + C/D + EF(G + H) + K/M = "
	txtResultTwo db "(A + B)/C+D + EFG + HK/M = "
	txtNewLine db 0ah, 0dh, 0
	countNumber dw 0
	
	
	numberA dd 0
	numberB dd 0
	numberC dd 0
	numberD dd 0
	numberE dd 0
	numberF dd 0
	numberG dd 0
	numberH dd 0
	numberK dd 0
	numberM dd 0
	temp dd 0
	
	
.data?
	access db ?
	accessEnter db ?
	outputBuffer db 0A0h dup (?) 
	inputBuffer db 0A0h dup (?)	
	STD_INPUT dd ?
	STD_OUTPUT dd ?
	INPUT_BUFFER dd ?
	OUTPUT_BUFFER dd ?
.code


start:
	invoke AllocConsole

	invoke GetStdHandle, STD_INPUT_HANDLE 
	mov STD_INPUT,eax 	
	
	invoke GetStdHandle, STD_OUTPUT_HANDLE 
	mov STD_OUTPUT,eax 

	xor eax, eax
	mov accessEnter, 1
	invoke WriteConsole, STD_OUTPUT, ADDR txtA, sizeof txtA, 0, NULL 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL 
	mov ebx, tempOne
	mov numberA, ebx
	inc di
	
	invoke WriteConsole, STD_OUTPUT, ADDR txtB, sizeof txtB, 0, NULL 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL 
	mov ebx, tempOne
	mov numberB, ebx
	inc di

	invoke WriteConsole, STD_OUTPUT, ADDR txtC, sizeof txtC, 0, NULL 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL 
	mov ebx, tempOne
	mov numberC, ebx
	inc di
	
	mov accessEnter, 0
	mov access, 1; делить на 0 нельзя
	invoke WriteConsole, STD_OUTPUT, ADDR txtD, sizeof txtD, 0, NULL 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL 
	mov ebx, tempOne
	mov numberD, ebx
	inc di
	mov access, 0
	mov accessEnter, 1
	
	invoke WriteConsole, STD_OUTPUT, ADDR txtE, sizeof txtE, 0, NULL 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL 
	mov ebx, tempOne
	mov numberE, ebx
	inc di
	
	invoke WriteConsole, STD_OUTPUT, ADDR txtF, sizeof txtF, 0, NULL 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL 
	mov ebx, tempOne
	mov numberF, ebx
	inc di
	
	invoke WriteConsole, STD_OUTPUT, ADDR txtG, sizeof txtG, 0, NULL 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL 
	mov ebx, tempOne
	mov numberG, ebx
	inc di
	
	invoke WriteConsole, STD_OUTPUT, ADDR txtH, sizeof txtH, 0, NULL
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL
	mov ebx, tempOne
	mov numberH, ebx
	inc di
	
	invoke WriteConsole, STD_OUTPUT, ADDR txtK, sizeof txtK, 0, NULL
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL
	mov ebx, tempOne
	mov numberK, ebx 	
	inc di
	
	mov accessEnter, 0
	mov access, 1
	invoke WriteConsole, STD_OUTPUT, ADDR txtM, sizeof txtM, 0, NULL 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL 
	mov ebx, tempOne
	mov numberM, ebx
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL
	mov access, 0
	mov accessEnter, 1

;ab + c/d + ef(g + h) + k/m
	;numA = AB
	mov ebx, numberA
	mov eax, numberB
	mul ebx
	mov numberA, eax
	
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	;numC = c/d
	mov eax, numberC
	mov ebx, numberD
	idiv ebx
	mov numberC, eax

	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	;numE = ef
	mov ebx, numberE
	mov eax, numberF
	mul ebx
	mov numberE, eax
	
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	;numG = g+h
	mov eax, numberG
	add eax, numberH
	mov numberG, eax
	
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	;numK = k/m
	mov eax, numberK
	mov ebx, numberM
	idiv ebx
	mov numberK, eax

	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	;numE=ef(g+h)
	mov ebx, numberE
	mov eax, numberG
	mul ebx
	mov numberE, eax
	
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	;numA = ab + c/d + ef(g + h) + k/m
	mov eax, numberA
	add eax, numberC
	add eax, numberE
	add eax, numberK
	
	call PROC_SAVE_RESULT
				
	xor eax, eax
	
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL 
	
	invoke WriteConsole, STD_OUTPUT, ADDR txtResult, sizeof txtResult, 0, NULL 
	invoke WriteConsole, STD_OUTPUT, ADDR inputBuffer, sizeof inputBuffer, 0, NULL ; вывод числа	
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL
	
	;---------------------------------------------------------------------------------------------------------------------------
	
	;(a + b)/с+d + efg + hk/m - 3 вариант
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	;numA = a+b
	mov eax, numberA
	add eax, numberB
	mov numberA, eax
	
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	;numA = (a+b)/c
	mov eax, numberA
	mov ebx, numberC
	idiv ebx
	mov numberA, eax

	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	;numE = efg
	mov ebx, numberE
	mov eax, numberF
	mul ebx
	mov numberE, eax
	
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	mov ebx, numberE
	mov eax, numberG
	mul ebx
	mov numberG, eax
	
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	;numH=hk/m
	mov ebx, numberH
	mov eax, numberK
	mul ebx
	mov numberH, eax
	
	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	mov eax, numberH
	mov ebx, numberM
	idiv ebx
	mov numberH, eax

	xor eax,eax
	xor ebx,ebx
	xor edx,edx
	
	mov eax, numberA
	add eax, numberD
	add eax, numberE
	add eax, numberH
	
	call PROC_SAVE_RESULT
				
	xor eax, eax
	
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL 
	
	invoke WriteConsole, STD_OUTPUT, ADDR txtResultTwo, sizeof txtResultTwo, 0, NULL 
	invoke WriteConsole, STD_OUTPUT, ADDR inputBuffer, sizeof inputBuffer, 0, NULL ; вывод числа	
	invoke WriteConsole, STD_OUTPUT, ADDR txtNewLine, 1, 0, NULL
	
			
PROC_VALID_ENTER_NUMBER proc
	

@EntererNumber:
		
	invoke ReadConsoleInput, STD_INPUT, ADDR outputBuffer, BSIZE, ADDR INPUT_BUFFER 
	
	cmp accessEnter, 0
		je @itsZeroEnter
		jmp @itsNotZeroEnter
		@itsZeroEnter:
			cmp [outputBuffer+10d], 0dh
			je @EntererNumber 
		@itsNotZeroEnter:
			
	cmp [outputBuffer+14d], 30h 
	jge @giveAccessEnter
	jmp @notGiveAccessEnter
	@giveAccessEnter:
		mov accessEnter, 1
	@notGiveAccessEnter:

	cmp access, 1
		je @itsZero
		jmp @itsNotZero
		@itsZero:
			cmp [outputBuffer+14d], 30h
			je @EntererNumber 
		@itsNotZero:
		
		
	cmp [outputBuffer+10d], 0dh 
	je @ReadAndConvertNumber
	
	cmp [outputBuffer+14d], 0 
	je @EntererNumber
	cmp [outputBuffer+14d], 30h 
	jl @EntererNumber
	cmp [outputBuffer+14d], 40h 
	jnc @EntererNumber 
	
	cmp [outputBuffer+04d], 1h 
	jne @EntererNumber
	invoke WriteConsole, STD_OUTPUT, ADDR [outputBuffer+14d], 1, 0, NULL
	
	mov eax, temp 
	mul decDecimal
	mov temp, eax 
	
	xor eax, eax 
	mov al, [outputBuffer+14d] 
	sub al, 30h 
	add temp, eax 
	
	jmp @EntererNumber
	
	
@ReadAndConvertNumber:	
	invoke ReadConsoleInput, STD_INPUT, ADDR outputBuffer, BSIZE, ADDR INPUT_BUFFER 
	
	xor edi, edi
	mov di, countNumber
	mov eax, temp
	mov temp, 0
	mov tempOne, eax
	xor eax, eax
	ret	
PROC_VALID_ENTER_NUMBER endp


PROC_SAVE_RESULT proc
	mov edi, 0
	xor ecx, ecx 
	mov cx, countNumber 

	xor ecx, ecx 
	xor edx, edx ; будет использоввн для приведения значения к размерности чисел
@CyclConvertDecimal:	
	div divDecimal 	; /10, чтобы представить в десятичной cc
					
	add dl, 30h	; нахождения кода числа
	push edx	
	xor edx, edx
	inc ecx		
	cmp eax, 0	
	jne @CyclConvertDecimal		
				
	mov edi, 0	
				
@CyclRecordNumber:	
	pop edx		
	mov [inputBuffer + edi], dl 
	inc edi		
	dec ecx		
	jnz @CyclRecordNumber	
				
ret
PROC_SAVE_RESULT endp	
					 
end start
