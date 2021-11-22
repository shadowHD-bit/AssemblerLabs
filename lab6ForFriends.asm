.386
.model flat,stdcall
option casemap:none
include includes\windows.inc
include includes\user32.inc
includelib includes\user32.lib
include includes\kernel32.inc
includelib includes\kernel32.lib
include includes\msvcrt.inc
includelib includes\msvcrt.lib

BUFFER_SIZE equ 1024

.data
	input_file_name db "in.txt",0	
	out_file_name db "out.txt",0	
	
	formS db "%s", 10,13,0
	formC db "%c", 10,13,0
	sortComplete db "Sorting was successful!", 10,13,0
	
	size_crt_string dw 0 
	probelAll dd 0 ;Всего пробелов в строке
	probelItog dd 0 ; Пробелов до кратчайшего слова
	cifra db 31h
	schet dd 0
	flag dd 0
	
	currentEsi dd ? 
	dlina db ?
	
	descriptor_input dd ?
	descriptor_output dd ?
	
	count_of_read db ?
	count_readen_simbols dd ? ; длина strings
	strings db BUFFER_SIZE dup(?); массив строк
	
	crnt_str db BUFFER_SIZE dup(?) ;текущая строка для анализа
	crt_shortest_word db BUFFER_SIZE dup(?) ; текущее самое короткое слово в строке
	
	pos_min_word dd ? ; позиция начала текущего минимального слова в строке
	size_min_word dd ? ; его длина
	size_min_word_w dd ? ;длина кратчайшего слова, для записи
	
	pos_crt_word dd ? ;начало текущего обрабатываемого слова
	size_crt_word dd ? ; его длина 
	
	array_sh db BUFFER_SIZE dup(?) ;массивв отсортированных строк
	
	coord_shortest dd ? ;с какого по счету символа начинается текущее минимальное
	coord_shortest_w dd ? ;с какого по счету символа начинается текущее минимальное, для записи
	
	size_read_current dd ? ;сколько прочитано символов на данный момент
		
.code

	SortStringProcedure PROC
		cmp flag,0
			jne Search
		
		;Ставим номер строки	
		mov al,cifra 
		mov ecx,schet
		add [array_sh+ecx], al
		inc schet
		mov ecx,schet
		mov [array_sh+ecx], '.'
		inc schet
		inc cifra
		
		Search:
		mov coord_shortest,0
		mov size_read_current,0
		mov probelItog,0
		mov probelAll,0
		
		mov eax, 0
		mov esi, OFFSET crnt_str; исходный массив
		mov edi, OFFSET crt_shortest_word; целевой массив
		cld ;DF 0
		
		mov eax, count_readen_simbols
		inc eax
		mov size_min_word, eax
		mov size_crt_word, 0
		
		mov pos_crt_word, OFFSET crnt_str
		SortLoop:	
			lodsb
			
			cmp al,32;  конец слова, проверяем самое ли оно короткое сейчас
				je SelectShortestWord

			cmp al,0;  конец строки?
				je SelectShortestWord

			;нет, тогда добавить символ к текущему обрабатываему слову
			stosb;
			
			inc size_crt_word
			inc size_read_current 
			jmp SortLoop
			
			
			SelectShortestWord:
				inc probelAll		
				mov eax, size_crt_word
				cmp eax,size_min_word 			  ; crt_word.size < min_word.size ? 	
					jge SkipSpacesAndClearCrtWord ;нет чистим и ищем новое слово 
				
				; да, запоминаем новое самое короткое слово
				mov eax,probelAll
				mov probelItog,eax
				
				mov eax, pos_crt_word	;начало этого слова			
				mov pos_min_word, eax
					
				mov eax, size_read_current ; с какого по счету символа начинается
				sub eax, size_crt_word
				mov coord_shortest, eax
				
				mov eax, size_crt_word ;его длину
				mov size_min_word, eax
				
				SkipSpacesAndClearCrtWord:
					lodsb;
					cmp al,0
						je PushShortestWord
					
					cmp al,32
						jne NoNull
					inc size_read_current
					jmp SkipSpacesAndClearCrtWord
					
					NoNull:
					;пропустили все пробелы	задаем параметры текущего word
					dec esi
					mov pos_crt_word, esi
					mov size_crt_word,0				
					
				jmp SortLoop	
								
			PushShortestWord:
				mov eax, offset crt_shortest_word
				call Obnyl
				mov edi, OFFSET crt_shortest_word;
				cmp coord_shortest,0 ;Проверяем кратчайшее слово в начале строки
					jne Plus
				jmp Next
				
				Plus: ;Если наименьшее слово не сначала строки
					dec probelItog ;вычитаем пробел
					mov eax,coord_shortest ; в eax норм (без учета пробелов) с которого начинается кратч слово
					add eax,probelItog ; добавляем колво пробелов
					mov coord_shortest,eax ;получаем итоговый порядковый номер символа, с которого начинается кратч слово
					jmp Next
				
				Next:
				inc size_min_word ;увеличиваем длину кратчайшего слова, чтобы убрать лишний пробел при записи
				Call Recording
				Call DeleteShortest
				Call Dlina
				cmp dlina,0 ;если символов не осталось, то выходим
					je Perenos
				jmp Search ;если остались, то находим следующее кратчайшее
				
				Perenos:
				mov ecx,schet
				mov [array_sh+ecx],10
				inc schet
				jmp Exit1
				
				Exit1:
					ret
	SortStringProcedure ENDP


	;Запись в файл кратчайшего слова
	Recording PROC
		mov eax,coord_shortest
		mov coord_shortest_w,eax ; с какого по счету символа начинается кратч слово
		mov eax,size_min_word
		mov size_min_word_w,eax ;длина кратч слова
		
		Rec:
		cmp size_min_word_w,0 ;Длина равна нулю
			je Exit2
		mov ecx,schet ; нет, в ecx на какое место по счету записывать букву
		mov ebx,coord_shortest_w ; в ebx с какого по счету символа начинается кратч слово
		mov al,[crnt_str+ebx] ;в al записываем символ кратч слова
		mov [array_sh+ecx],al ;из al записывваем в итоговый массив символ кратч слова 
		inc schet
		inc coord_shortest_w
		dec size_min_word_w
		jmp Rec
		
		Exit2:		
		ret
	Recording ENDP
	
	
	;Удаление из исходного массива кртачайшего слова
	DeleteShortest PROC
		Del: ;заменяем кратчайшее слово на -
			cmp size_min_word,0 
				je Exit3
			mov eax,coord_shortest
			mov [crnt_str+eax], '-'
			dec size_min_word
			inc coord_shortest
			jmp Del
			
		Exit3: ;Переписываем без - в crt_shortest_word
			mov esi, offset crnt_str 
			mov edi, offset crt_shortest_word
			cld
			Perepisat1:
			lodsb
			cmp al,45
				je Perepisat1
			
			cmp al,0
				je @Exit4
			
			stosb
			jmp Perepisat1

		@Exit4: ;Переписываем из crt_shortest_word в crnt_str
			mov eax, offset crnt_str
			call Obnyl
			mov edi, OFFSET crnt_str;
			mov esi, offset crt_shortest_word 
			cld
			Perepisat2:
			lodsb
			cmp al,0
				je Exit5
			stosb
			jmp Perepisat2
			
		Exit5:
			ret
	DeleteShortest ENDP

	
	;Проверяем, остались ли символы в строке, кроме пробелов
	Dlina PROC
		cld
		mov esi, offset crnt_str
		mov dlina,0
		PodschetDdlin:
			lodsb
			cmp al,32 ; не пробел, то проверяем на конец строки, если пробел, то считываем следующий символ
				jne Simv
			jmp PodschetDdlin
			
			Simv:
			cmp al,0 ; Если конец строки, то выходим
				je Exit6
			inc dlina
			jmp PodschetDdlin
		Exit6:
			ret
	Dlina ENDP
	
	;Очистка массива
	Obnyl PROC
		xor al, al
		mov edi, eax
		mov ecx, 1024
		cld
		rep stosb
		ret
	Obnyl ENDP
		
	start:
		
	invoke CreateFileA,offset input_file_name,GENERIC_READ,0,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0	
	mov descriptor_input,eax	
	
	invoke ReadFile,descriptor_input,ADDR strings, sizeof strings, ADDR count_readen_simbols,0 
	invoke CloseHandle,descriptor_input
	
	mov al, strings
	
	; ОБРАБОТКА СТРОК	
	mov esi, OFFSET strings; исходный массив
	mov edi, OFFSET crnt_str; целевой массив
	cld
	CopyStringLoop:
		lodsb
		
		cmp al,13;  13 конец строки
			je SortString ;Обработка текущей строки

		cmp al,10;  10 перенос
			je Clear

		stosb
		inc size_crt_string
		
		;помещение временной строки в исходную
		cmp al,0; Считали последнюю строку?
			jne CopyStringLoop; нет, считываем следующий символ
			je SortLastString;да, обрабатываем последнюю строку
		
		SortString: ;обработка текущей строки
			mov currentEsi,esi
			call SortStringProcedure
			mov esi, currentEsi
			JMP CopyStringLoop				
		
		Clear: ;очищаем целевой массив
			mov eax, offset crnt_str
			call Obnyl
			mov edi, OFFSET crnt_str; заполняем по новой
			mov size_crt_string, 0
			JMP CopyStringLoop
			
	;Обработка последней строки    
	SortLastString: 
		inc flag
		call SortStringProcedure
	
	;Запись
	invoke CreateFileA,offset out_file_name,GENERIC_WRITE,0,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0	
	mov descriptor_output,eax
	
	invoke SetFilePointer,descriptor_output,0,0,FILE_BEGIN
	invoke WriteFile,descriptor_output,offset array_sh,sizeof array_sh,offset count_of_read,0			
	invoke CloseHandle,descriptor_output
	
	invoke crt_printf, offset formS, offset sortComplete
	invoke ExitProcess,0
end start



	
