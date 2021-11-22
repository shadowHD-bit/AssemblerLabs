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

.const
	readingFileName db "in.txt", 0
	writingFileName db "out.txt", 0

BSIZE equ 256
.data
	i dd 0
	len dd 0
	line db 31h
	@bool db 0
	example dd "gni"
	
	hFile dd ?
	wasReading dd ?
	wasWriting dd ?

	readingData dd BSIZE dup(?)
	
	temp db ?

.code
start:
	invoke CreateFileA, offset readingFileName, GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov hFile, eax
	
	invoke ReadFile, hFile, offset readingData, BSIZE, wasReading, 0
	invoke CloseHandle, hFile
	
	invoke CreateFileA, offset writingFileName, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
	mov hFile, eax
	
	lea esi, readingData ;в esi загружаются полученные данные
	call search
	
	mov edi, offset temp ;определение длины строки
	call _strlen
	mov len, eax
	
	invoke WriteFile, hFile, offset temp, len, wasWriting, 0
	
	invoke CloseHandle, hFile
	invoke ExitProcess, 0
	
	search proc
		mov edi, esi ;коприрование в edi полученных строк
		mov ebx, offset temp
		
		mov al, line ;нумерация строки начало
		add [ebx], al
		inc ebx
		
		mov al, "."
		add [ebx], al
		inc ebx
		
		mov al, 20h
		add [ebx], al
		inc ebx
		
		inc line ;нумерация строки конец
		
		lp:			
			mov eax, 0
			lodsb
			cmp al, ' '
			je probel
			
			cmp al, 13
			je ent
			
			add [ebx], al
			inc i
			inc ebx
			
			jmp next
			
			probel:
				sub ebx, 3
				mov eax, [ebx]
				add ebx, 3
				mov edx, example
				cmp eax, edx
				jne @delete
				
				mov eax, 20h ;добавление пробела
				mov [ebx], eax
				inc ebx
				mov i, 0
				
				jmp next
				
			@delete:
				dec i
				dec ebx
				mov al, 0
				mov [ebx], al
				cmp i, 0
				jne @delete
				jmp next
				
			ent:
				lodsb
				stosb
				
				inc i
				sub ebx, 3
				mov eax, [ebx]
				add ebx, 3
				mov edx, example
				cmp eax, edx
				jne deleteEnt
				
				mov eax, 0Dh ;добавление переноса
				mov [ebx], eax
				inc ebx
				
				mov al, line ;нумерация строки начало
				add [ebx], al
				inc ebx
				
				mov al, "."
				add [ebx], al
				inc ebx
				
				mov al, 20h
				add [ebx], al
				inc ebx
				
				inc line ;нумерация строки конец
				
				mov i, 0
				
				jmp next
				
		deleteEnt:
				dec i
				dec ebx
				mov al, 0
				mov [ebx], al
				cmp i, 0
				jne deleteEnt
				
				mov eax, 0Dh ;добавление переноса
				mov [ebx], eax
				inc ebx
				
				mov al, line ;нумерация строки начало
				add [ebx], al
				inc ebx
				
				mov al, "."
				add [ebx], al
				inc ebx
				
				mov al, 20h
				add [ebx], al
				inc ebx
				
				inc line ;нумерация строки конец
				
				jmp next
				
			next:
				stosb
				cmp eax, 0
				jne lp
				je last
				
				vihod:
				ret
				
			last: ; последняя итерация перед завершением процедуры
				inc i
				sub ebx, 4
				mov eax, [ebx]
				add ebx, 4
				mov edx, example
				cmp eax, edx
				jne lastDel
				jmp vihod
				
			lastDel:
				dec i
				dec ebx
				mov al, 0
				mov [ebx], al
				cmp i, 0
				jne lastDel
				jmp vihod
				
			search endp

	_strlen proc  ;определение длины строки	
		xor eax,eax
		
		@1:
			inc eax
			cmp byte ptr[eax+edi],0
			jnz @1	
			ret
	_strlen endp
	
end start
