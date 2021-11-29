;ab + c/d + ef(g + h) + k/m

.386
.model flat, stdcall
option casemap :none
include includes\windows.inc
include includes\masm32.inc
include includes\kernel32.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib


BSIZE equ 10
.data

	rez dd 0 
	mn_dec dd 10d
	mn_div dw 10d
	aa dd BSIZE dup (?) 
	soob_1 db "A = ", 0
	soob_2 db "B = ", 0
	soob_3 db "C = ", 0
	soob_4 db "D = ", 0
	soob_5 db "E = ", 0
	soob_6 db "F = ", 0
	soob_7 db "G = ", 0
	soob_8 db "H = ", 0
	soob_9 db "K = ", 0
	soob_10 db "M = ", 0
	soob_res db "AB + C/D + EF(G + H) + K/M = "
	soob_otst db 0ah, 0dh, 0
	kol db 10
	num dw 0
	index dd 11
	
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
	stdout DWORD ? 
	stdin DWORD ? 
	
	cdkey DWORD ? 

	buffer_key_2 db 0A0h dup (0) 
	
.data?
	
	buffer_key_1 db 0A0h dup (?) 
		
.code


start:
	invoke AllocConsole

	invoke GetStdHandle, STD_INPUT_HANDLE 
	mov stdin,eax 	
	
	invoke GetStdHandle, STD_OUTPUT_HANDLE 
	mov stdout,eax 

	xor eax, eax
	
	invoke WriteConsole, stdout, ADDR soob_1, sizeof soob_1, 0, 0 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	mov ebx, rez
	mov numberA, ebx
	inc di
	
	invoke WriteConsole, stdout, ADDR soob_2, sizeof soob_1, 0, 0 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	mov ebx, rez
	mov numberB, ebx
	inc di

	invoke WriteConsole, stdout, ADDR soob_3, sizeof soob_1, 0, 0 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	mov ebx, rez
	mov numberC, ebx
	inc di
	
	invoke WriteConsole, stdout, ADDR soob_4, sizeof soob_1, 0, 0 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	mov ebx, rez
	mov numberD, ebx
	inc di
	
	invoke WriteConsole, stdout, ADDR soob_5, sizeof soob_1, 0, 0 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	mov ebx, rez
	mov numberE, ebx
	inc di
	
	invoke WriteConsole, stdout, ADDR soob_6, sizeof soob_1, 0, 0 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	mov ebx, rez
	mov numberF, ebx
	inc di
	
	invoke WriteConsole, stdout, ADDR soob_7, sizeof soob_1, 0, 0 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	mov ebx, rez
	mov numberG, ebx
	inc di
	
	invoke WriteConsole, stdout, ADDR soob_8, sizeof soob_1, 0, 0 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	mov ebx, rez
	mov numberH, ebx
	inc di
	
	invoke WriteConsole, stdout, ADDR soob_9, sizeof soob_1, 0, 0 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0
	mov ebx, rez
	mov numberK, ebx 	
	inc di
	
	invoke WriteConsole, stdout, ADDR soob_10, sizeof soob_1, 0, 0 
	call PROC_VALID_ENTER_NUMBER
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	mov ebx, rez
	mov numberM, ebx
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0



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
	

	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	
	invoke WriteConsole, stdout, ADDR soob_res, sizeof soob_res, 0, 0 
	invoke WriteConsole, stdout, ADDR buffer_key_2, 27d, 0, 0 ; вывод числа	
	invoke WriteConsole, stdout, ADDR soob_otst, 2d, 0, 0 
	
	
	
	
	
PROC_VALID_ENTER_NUMBER proc
	

@1:
		
	invoke ReadConsoleInput, stdin, ADDR buffer_key_1, BSIZE, ADDR cdkey 
	cmp [buffer_key_1+10d], 0dh 
	je @2 
	
	cmp [buffer_key_1+14d], 0 
	je @1
	cmp [buffer_key_1+14d], 30h 
	jl @1 
	cmp [buffer_key_1+14d], 40h 
	jnc @1  
	
	cmp [buffer_key_1+04d], 1h 
	jne @1 
	invoke WriteConsole, stdout, ADDR [buffer_key_1+14d], 1, 0, 0
	
	mov eax, temp 
	mul mn_dec
	mov temp, eax 
	
	xor eax, eax 
	mov al, [buffer_key_1+14d] 
	sub al, 30h 
	add temp, eax 
	
	jmp @1 
	
	
@2:	
	invoke ReadConsoleInput, stdin, ADDR buffer_key_1, BSIZE, ADDR cdkey 
	
	xor edi, edi
	mov di, num
	mov eax, temp
	mov temp, 0
	mov [aa + edi*4], eax
	mov rez, eax
	xor eax, eax
	ret	
PROC_VALID_ENTER_NUMBER endp


PROC_SAVE_RESULT proc

	xor ecx, ecx ; подготовка счетчика - обнуление
	xor edx, edx ; будет использоввн для приведения значения к размерности чисел
@51:	
	div mn_div 	; деление числа на 10, чтобы представить его в десятичной системе счиления
				; будет браться остаток от деления и к нему прибавляться 30h, чтобы найти ASCII- код числа для вывода на экран
				; при делении первый остаток от деления дает нам правую цифру, которая должна быть выведена поседней
	add dl, 30h	; добавление 30h для нахождения кода числа (преобразвание в букву)
	push edx	; временное сохранение в стеке всех чисел - чтобы их перевернуть - сделать парвильный порядок символов
	xor edx, edx; обнуление edx, так как будет использовать у него только dl для записи только одной цифры
	inc ecx		; увеличение счетчика - сколько цифр- столько раз будет увеличен счетчик
	cmp eax, 0	; если делимое равно нулю (все остатки от деления найдены) то значить все цифры обработыны
	jne @51		; переход на обработку следующей цифры, если в регистре еще есть значение
				; если не равно, то переход
	
	mov edi, 0	; обнуление edi, который будет использоваться как счетчик для доступа к ячейкам
				; памяти куда будут записаны символы выводимых цифр для числа
@61:	
	pop edx		; чтение ASCII-кода цифры из стека (читается сначала старший разряд, так как он был помещен последним в стек)
	mov [buffer_key_2 + edi], dl ; по адресу буфера вывода сохраняем только один байт, соотвутствующий цифре
	inc edi		; переходим к следующему байту
	dec ecx		; уменьшаем счетчик-количество цифр в числе (был получен в предыдушщем цикле)
	jnz @61		; пока не обработаны все цифры чистаем из стека следующую цифру и ложем в буфер
				; пока не ноль - пока ecx больше нуля
	
ret
PROC_SAVE_RESULT endp	
	
	
	
	
	
	
	
	
exit	
			 
end start
