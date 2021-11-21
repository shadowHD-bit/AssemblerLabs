;Переставить слова в только в строках, где есть 6 или 7 слов – 6 слов:
;1 поменять с 6, 2-5, 3-4; 7 слов: 1-7, 2-6, 3-5, 4 остается на месте.
;При этом цифры словами не считаются. 


.386
.model flat, stdcall
option casemap :none
	include includes\kernel32.inc
	includelib includes\kernel32.lib
	include includes\windows.inc
	include includes\user32.inc
	includelib includes\user32.lib
	include includes\msvcrt.inc
	includelib includes\msvcrt.lib


	BSIZE equ 256
.data
	readNameFile db "in.txt", 0
	writeNameFile db "out.txt", 0
	str_length dd 0
	numerationLine db 31h
	


.data?
	readFileHandle dd ?
	readFileData dd BSIZE dup(?)
	countByteReading dd ?
	tempData db ?
	countByteWriting dd ?

.code
start:

	@CreateAndOpen_ReadFile:
		invoke CreateFileA, offset readNameFile, GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
		mov readFileHandle, eax ;Получение хендла файла
	
	@OpenAndReading_ReadFile:
		invoke ReadFile, readFileHandle, offset readFileData, BSIZE, countByteReading, 0
		invoke CloseHandle, readFileHandle
	
	@Create_WriteFile:
		invoke CreateFileA, offset writeNameFile, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
		mov readFileHandle, eax
	
	@LoadDataESI:
		lea esi, readFileData  ;в esi загружаются полученные данные
	
	@Str_Length:
		mov edi, offset tempData ;определение длины строки
		call PROC_STR_LENGHT
		mov str_length, eax
		
	@WriteAndClose_WriteFile:
		invoke WriteFile, readFileHandle, offset tempData, str_length, countByteWriting, 0
		invoke CloseHandle, readFileHandle
		invoke ExitProcess, 0
		

	
	PROC_SEARCH_AND_REMOVE proc
		
		mov edi, esi ;коприрование в edi полученных строк
		mov ebx, offset tempData
		
		@NumerationWriteLine:
		mov al, numerationLine ;нумерация строки начало
		add [ebx], al
		inc ebx
		
		mov al, ") "
		add [ebx], al
		inc ebx
		
		mov al, 20h
		add [ebx], al
		inc ebx
		
		inc line 
		
		
		


	PROC_SEARCH_AND_REMOVE endp


	
	PROC_STR_LENGHT proc ;определение длины строки	
		xor eax,eax
			
		@Cycle_Count_Length:
			inc eax
			cmp byte ptr[eax+edi],0
			jnz @Cycle_Count_Length	
			ret
	PROC_STR_LENGHT endp















end start
