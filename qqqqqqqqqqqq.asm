;Переставить слова в только в строках, где есть 6 или 7 слов – 6 слов:
;1 поменять с 6, 2-5, 3-4; 7 слов: 1-7, 2-6, 3-5, 4 остается на месте.



.386
.model flat, stdcall
option casemap : none

include includes\kernel32.inc
	includelib includes\kernel32.lib
	include includes\windows.inc
	include includes\user32.inc
	includelib includes\user32.lib
	include includes\msvcrt.inc
	includelib includes\msvcrt.lib
	
.data
    readNameFile db "in.txt", 0
    writeNameFile db "out.txt", 0
    
    txtSpace db " ", 0
    txtEnter db 10, 0
    processLineFinish db "Process end... Check file out.txt", 10,13,0
    txtStrChar db "%s", 10,13,0

.data? 
    readFileHandle dd ?
    writeFileHandle dd ?

    lineBuffer db 128 dup(?) ;Размер буфера строки
    countLineBuffer dd ?
    countByteReading dd ? ;Количество считанных символов
    countWordReading db 9 dup(?) ;Количество слов в буфере
    lenghtWord dd 9 dup(?)
    
    countLineReading dd ? 
     
    tempBuffer db 16 dup(?)
    
    
.code
  
REVERSE_WORDS_IN_LINE proc
	@ReversLineInBuf:
		push ebx
		push esi
		xor esi, esi 
		@ReversLineInBufCicl:
			dec eax
			mov dl, [ecx+eax]
			mov bl, [ecx+esi]
			mov [ecx+eax], bl
			mov [ecx+esi], dl
			inc esi
			cmp eax, esi
				jg @ReversLineInBufCicl

		pop esi
		pop ebx
		ret
REVERSE_WORDS_IN_LINE endp



PRINT_LINE_NUMBER proc
    push ebx
    push esi
    push edi

    mov edi, offset tempBuffer
    xor esi, esi 
    
	@printNumber:
		xor edx, edx
		mov ebx, 7
		div ebx 
		add edx, '0'
		mov [edi+esi], dx
		inc esi

		cmp eax, 0
			jne @printNumber
    
    mov eax, esi
    mov ecx, edi
    push eax
    push ecx
    
    call REVERSE_WORDS_IN_LINE
    
    pop ecx
    pop eax
    
    mov eax, esi
    
    pop edi
    pop esi
    pop ebx
    ret
PRINT_LINE_NUMBER endp   



PROC_SAVE_TEMPDATA_COPY proc
    push esi
    push edi
    mov esi, ecx
    mov edi, edx
    mov ecx, eax
    
    lodsb
    stosb
    
    rep movsb
  
    pop edi
    pop esi
    ret
PROC_SAVE_TEMPDATA_COPY endp



COUNT_WORDS_IN_LINE proc
	@CountWordsInInputLine:
		push esi
		mov ecx, countLineBuffer
		mov esi, offset lineBuffer
		inc ecx
		mov eax, 1
		
		@ScoreCountLine:
			cmp ecx, 0
				jg @MainSpace
				jmp @EndScoreCountLine
				
			@MainSpace:
				mov dl, [esi]
				
				cmp dl, ' '
					je @itsSpace
					jne @itsNotSpace
					
				@itsSpace:
					inc eax
					jmp @itsNotSpace
				
				@itsNotSpace:
					dec ecx
					inc esi
					jmp @ScoreCountLine
					
		@EndScoreCountLine:
		pop esi
		ret
COUNT_WORDS_IN_LINE endp



PROC_NUMERATION_LINE proc
    mov eax, countLineReading
    call PRINT_LINE_NUMBER
    mov ecx, offset tempBuffer
    
    mov dx,')'
    mov [ecx+eax], dx
    add eax, 1
    
    invoke WriteFile, writeFileHandle, ecx, eax, ADDR countByteReading, 0
    ret 
PROC_NUMERATION_LINE endp



PROC_ADD_SPLIT_INTO_LINE proc
    push ebx
    push esi
    push edi
    mov esi, offset lineBuffer 
    mov eax, esi 
    mov ecx, esi 
    xor edx, edx 
    mov bl, [esi]
    
   @validInSpace: 
    cmp bl, 0
    jne @ItEndWord
    jmp @ItNotEndWord
    
		@ItEndWord:
			cmp bl, ' '
			je @ItSpace
			jmp @ItNotSpace
			
			@ItSpace:
				mov ebx, ecx 
				sub ebx, eax
				mov edi, offset lenghtWord 
				mov [edi+edx*4], ebx
				
				push eax
				push ecx
				push edx
				
				mov ecx, eax
				shl edx, 7
				add edx, offset countWordReading
				mov eax, ebx
				call PROC_SAVE_TEMPDATA_COPY
				
				pop edx
				pop ecx
				pop eax
				mov eax, ecx 
				inc eax
				inc edx 
				jmp @ItNotSpace
				
			@ItNotSpace:
				inc ecx
				mov bl, [ecx]
				jmp @validInSpace
    
    @ItNotEndWord:	
		mov ebx, ecx
		sub ebx, eax
		mov edi, offset lenghtWord 
		mov [edi+edx*4], ebx
		
		mov ecx, eax
		shl edx, 7
		add edx, offset countWordReading
		mov eax, ebx
		call PROC_SAVE_TEMPDATA_COPY
		
		pop edi
		pop esi
		pop ebx
		ret
PROC_ADD_SPLIT_INTO_LINE endp   



PROC_PRINTLINE_WORD proc
    mov edx, offset lenghtWord
    mov edx, [edx+eax*4] 
    shl eax, 7
    add eax, offset countWordReading
    invoke WriteFile, writeFileHandle, eax, edx, ADDR countByteReading, 0
    invoke WriteFile, writeFileHandle, ADDR txtSpace, 1, ADDR countByteReading, 0
    ret
PROC_PRINTLINE_WORD endp
 


PROC_COUNT_AND_REVERSE proc
    mov bl, 0
    mov [eax], bl
    inc countLineReading
    call COUNT_WORDS_IN_LINE
    push eax
    call PROC_NUMERATION_LINE
    pop eax
    
    cmp eax, 7
    	je @itReverse
    cmp eax, 6
    	je @itReverse
    	
    jmp @itNotReverse
    	
    	@itReverse:
			push eax
			call PROC_ADD_SPLIT_INTO_LINE
			pop eax
			dec eax
        
        @MainReversePrint:
			cmp SDWORD PTR eax, 0
				jne @NotEndBufWord
				jmp @EndBufWord
			
			@NotEndBufWord:
				push eax
				call PROC_PRINTLINE_WORD
				pop eax
				dec eax
				jmp @MainReversePrint
    	
			@EndBufWord:
				invoke WriteFile, writeFileHandle, ADDR txtEnter, 1, ADDR countByteReading, 0
				jmp @nextType
    
        jmp @nextType
        
    @itNotReverse:
        mov eax, countLineBuffer
        mov edx, offset lineBuffer
        mov cl, 10
        mov [edx+eax], cl
        inc countLineBuffer
        invoke WriteFile, writeFileHandle, ADDR lineBuffer, countLineBuffer, ADDR countByteReading, 0
		jmp @nextType
    
    @nextType:
		mov countLineBuffer, 0
		mov lineBuffer, 0
		ret 
PROC_COUNT_AND_REVERSE endp    
    


start:
		
	;Открытие и создание файлов ввода вывода
	invoke CreateFileA, ADDR readNameFile,  GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
    mov readFileHandle, eax
    
    invoke CreateFileA, ADDR writeNameFile, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov writeFileHandle, eax
    
    invoke crt_printf, offset txtStrChar, offset processLineFinish
    
    ;Чтение строк из входного файла и их обработка
    @ReadAndProcessingString:
    	
        mov countByteReading, 0
        mov eax, offset lineBuffer
        
        add eax, countLineBuffer
        push eax
        
        invoke ReadFile, readFileHandle, eax, 1, ADDR countByteReading, 0
        pop eax
       
        
        @ReadChar:
			cmp countByteReading, 0
				je @CharCountEqualsZero
				jmp @CharCountNotEqualsZero
         
				@CharCountEqualsZero:
					cmp countLineBuffer, 0
						jne @NotEndString
						jmp @EndProcess
						
						@NotEndString:
							call PROC_COUNT_AND_REVERSE
						
					@EndProcess:
						jmp @LastProcessLine
		   
			@CharCountNotEqualsZero:
        
        
        mov bl, [eax]
        cmp bl, 10 ;Проверка на конец строке (Отступ)
			je @IndentLine
			jmp @NotIndentLine
			@IndentLine:
				call PROC_COUNT_AND_REVERSE
				jmp @Next
			@NotIndentLine:
				inc countLineBuffer
				jmp @Next	
			@Next:
				jmp @ReadAndProcessingString
				
    
		@LastProcessLine:
			
			mov bl, [eax]
			
			cmp bl, 10 ; ;Проверка на конец строке (Отступ)
				je @IndentLineLast
				jmp @NotIndentLineLast
			@IndentLineLast:
				call PROC_COUNT_AND_REVERSE
				jmp @EndedLastProcess
			@NotIndentLineLast:
				inc countLineBuffer
				jmp @EndedLastProcess
			
			@EndedLastProcess:				
		
		xor eax, eax
		ret
				
end start
