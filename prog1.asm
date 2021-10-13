; Новый проект masm32 успешно создан
; Заполнен демо программой «Здравствуй, мир!»
.386
.model flat, stdcall
option casemap :none
include includes\windows.inc
include includes\masm32.inc
include includes\kernel32.inc
include includes\user32.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib

BSIZE equ 8
BSIZE2 equ 256
.data
	stdout DWORD ? ;дескриптор вывода
	stdin DWORD ? ;дескриптор ввода
	buff_a db BSIZE dup (0)
	buff_b db BSIZE dup (0)
	cRead DWORD ?
	cRead2 DWORD ?
	NumberOfCharsRead dw ?
	cWritten DWORD ?
	dec_mul dw 10d
	rez dd (0)
	Mode DWORD ? ; режим работы клавиатуры
	momo dw 1234h
	Buffer db ?	
	NoRead db 256 dup (0)
;	a db 10110101b
;	b db 00110111b
;	cc db 0
.code
start:
	invoke AllocConsole ; запрашиваем у Windows консоль
	
	invoke GetStdHandle, STD_OUTPUT_HANDLE
	mov stdout,eax
	invoke GetStdHandle, STD_INPUT_HANDLE
	mov stdin,eax
	
	NewLine:

;	invoke GetConsoleMode, GetStdHandle, ADDR Mode ; сохранение флагов
;	mov eax, Mode
;	and eax, 1111111111111001B ; сброс первого бита
;	invoke SetConsoleMode, GetStdHandle, eax ; отмена режима Enter		

	
	invoke ReadConsole , stdin,ADDR buff_a, BSIZE, ADDR cRead, NULL
	
	invoke ReadConsoleInput , stdin, ADDR NoRead, BSIZE2, ADDR cRead2

	xor eax,eax
	mov cx, 0
	mov al, buff_a [0]
	sub al, 30h
	add rez, eax
	inc cx

	xor eax,eax
	mov al, buff_a [1]
	sub al, 30h
	xchg eax, rez
	mul dec_mul
	xchg eax, rez
	add rez, eax
	inc cx

	xor eax,eax	
	mov al, buff_a [2]
	sub al, 30h
	xchg eax, rez
	mul dec_mul
	xchg eax, rez
	add rez, eax
	inc cx

	xor eax,eax
	mov al, buff_a [3]
	sub al, 30h
	xchg eax, rez
	mul dec_mul
	xchg eax, rez
	add rez, eax
	inc cx

	xor eax,eax
	mov al, buff_a [4]
	sub al, 30h
	xchg eax, rez
	mul dec_mul
	xchg eax, rez
	add rez, eax
	inc cx	

	xor eax,eax
	mov al, buff_a [5]
	sub al, 30h
	xchg eax, rez
	mul dec_mul
	xchg eax, rez
	add rez, eax
	inc cx	

	xor eax,eax
	mov al, buff_a [6]
	sub al, 30h
	xchg eax, rez
	mul dec_mul
	xchg eax, rez
	add rez, eax
	inc cx	

	xor eax,eax
	mov al, buff_a [7]
	sub al, 30h
	xchg eax, rez
	mul dec_mul
	xchg eax, rez
	add rez, eax
	inc cx	
	
;	invoke FlushConsoleInputBuffer, stdout
;	invoke FreeConsole ; отключет консоль, помогает создание новой консоли
	mov ecx, offset NoRead
	invoke GetNumberOfConsoleInputEvents, stdin, ecx
	inc ecx
	invoke GetNumberOfConsoleInputEvents, stdin, ecx
	
	invoke ReadConsole,			; ожидаем ввода в консоль
                      stdin,	; хэндл ввода
                        ADDR Buffer,	; адрес буфера
                                  1,	; вводим 1 символ
             ADDR NumberOfCharsRead,	; сюда функция запишет число символов
                                  0	; lpReserved передаем, как ноль
	
	
;	not a ; инвертируем первое число и делим его на 4 
;	shr a,2 
;	shl b,1 ; второе число умножаем на 2 
;	mov al , a ; полученные результаты складываем 
;	add al , b 
;	xor al, 00001111b ; меняем первые четыре разряда на противоположные
;	mov cc,al 	
	exit
end start