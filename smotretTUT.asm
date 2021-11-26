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

MAX_LINE equ 1024
MAX_WORD equ 1024
MAX_WORDS equ 8

.data
    str_input_file db "in.txt", 0
    str_output_file db "out.txt", 0
    str_space db " ", 0
    str_lf db 10, 0
    processLineFinish db "Process ended... Check file out.txt", 10,13,0
    txtStr db "%s", 10,13,0
    

    gInputFile dd 0
    gOutputFile dd 0

    gLineBuf db MAX_LINE dup(0)
    gLineBufPos dd 0
    
    gWords db MAX_WORDS dup(0)
    gWordLen dd MAX_WORDS dup(0)
    
    gReadCharCount dd 0
    gLineCounter dd 0
    
    gIntBuf db 16 dup(0)

.code

print_int:
    push ebx
    push esi
    push edi

    mov edi, offset gIntBuf
    xor esi, esi ; string len
    
print_int_loop:
	; разделить eax на 10
    xor edx, edx
    mov ebx, 10
    div ebx ; eax /= 10, edx = eax % 10
    ; put the char into the buffer
    add edx, '0'
    mov [edi+esi], dx
    inc esi
    ; loop
    cmp eax, 0
    jne print_int_loop
    
    mov eax, esi ; len
    mov ecx, edi ; buffer
    push eax
    push ecx
    call reverse_buffer
    pop ecx
    pop eax
    
    mov eax, esi
    
    pop edi
    pop esi
    pop ebx
    ret

; Reverses a buffer
; eax - len
; ecx - the buffer
; Preserves: ebx, esi
reverse_buffer:
    push ebx
    push esi
    xor esi, esi ; 0 .. len
reverse_buffer_loop:
    dec eax
    mov dl, [ecx+eax]
    mov bl, [ecx+esi]
    mov [ecx+eax], bl
    mov [ecx+esi], dl
    inc esi
    cmp eax, esi
    jg reverse_buffer_loop

    pop esi
    pop ebx
    ret

; ecx - src
; edx - dst
; eax - size
my_memcpy:
    push esi
    push edi
    
    mov esi, ecx
    mov edi, edx
    mov ecx, eax
    
    rep movsb
    
    pop edi
    pop esi
    ret

count_words:
    push esi
    mov ecx, gLineBufPos
    mov esi, offset gLineBuf
    inc ecx
    mov eax, 1
    
    count:
    	
    	cmp ecx, 0
			jne probel
			jmp endcount
			
		probel:
			mov dl, [esi]
			cmp dl, ' '
				je uvel
				jne last
				
			uvel:
				inc eax
				jmp last
			
			last:
				dec ecx
				inc esi
				jmp count
    endcount:
    
    pop esi
    ret

print_line_number:
    mov eax, gLineCounter
    call print_int
    mov ecx, offset gIntBuf
    
    mov dx, ')'
    mov [ecx+eax], dx
    mov dx, ' '
    mov [ecx+eax+1], dx
    add eax, 2
    
    invoke WriteFile, gOutputFile, ecx, eax, ADDR gReadCharCount, 0
    ret
    
split_into_words:
    push ebx
    push esi
    push edi

    mov esi, offset gLineBuf ; the string
    mov eax, esi ; begin ptr
    mov ecx, esi ; i ptr
    xor edx, edx ; word idx
    
    mov bl, [esi]
    
   eestart: 
    cmp bl, 0
    jne step1
    jmp ee
    
		step1:
			cmp bl, 32
			je step21
			jmp step22
			
			step21:
				
				mov ebx, ecx ; len
				sub ebx, eax
				mov edi, offset gWordLen ; gWordLen[word] = len;
				mov [edi+edx*4], ebx
				
				push eax
				push ecx
				push edx
				
				; src
				mov ecx, eax
				; dst
				shl edx, 10 ; MAX_WORD == 1024, *= MAX_WORD
				add edx, offset gWords
				; size
				mov eax, ebx
				call my_memcpy
				
				pop edx
				pop ecx
				pop eax
				
				mov eax, ecx ; begin = i + 1;
				inc eax
				inc edx ; word++;
				
				
			step22:
    inc ecx
    mov bl, [ecx]
    jmp eestart
    ee:
    	
    
    
    mov ebx, ecx ; len
    sub ebx, eax
    mov edi, offset gWordLen ; gWordLen[word] = len;
    mov [edi+edx*4], ebx
    
    ; src
    mov ecx, eax
    ; dst
    shl edx, 10 ; MAX_WORD == 1024, *= MAX_WORD
    add edx, offset gWords
    ; size
    mov eax, ebx
    call my_memcpy
    
    pop edi
    pop esi
    pop ebx
    ret
    
; eax- word idx
print_word:
    mov edx, offset gWordLen
    mov edx, [edx+eax*4] ; word size
    shl eax, 10 ; *= 1024
    add eax, offset gWords
    invoke WriteFile, gOutputFile, eax, edx, ADDR gReadCharCount, 0
    invoke WriteFile, gOutputFile, ADDR str_space, 1, ADDR gReadCharCount, 0
    ret

; eax = gLineBuf + gLineBufPos 


process_line:
    ; Null-terminate
    mov bl, 0
    mov [eax], bl
    
    inc gLineCounter
    call count_words
    ; eax = word count
    
    push eax
    call print_line_number
    pop eax
    
    
    
    
    
    startifif:
    	cmp eax, 7
    	je nextifif
    	
    	cmp eax, 6
    	je nextifif
    	jmp elseifif
    	
    	nextifif:
    		
    		push eax
			call split_into_words
			pop eax
			
			dec eax
    	
			whileifif:
				cmp SDWORD PTR eax, 0
				jge mainwhileifif
				
				jmp endd	;Посмотреть что с отступом
			
			mainwhileifif:
				push eax
				call print_word
				pop eax
				dec eax
				jmp whileifif
    	
			endmainwhileifif:
				
				invoke WriteFile, gOutputFile, ADDR str_lf, 1, ADDR gReadCharCount, 0
				
    	
  elseifif:  	
    	mov eax, gLineBufPos
        mov edx, offset gLineBuf
        mov cl, 10
        mov [edx+eax], cl
        inc gLineBufPos
        invoke WriteFile, gOutputFile, ADDR gLineBuf, gLineBufPos, ADDR gReadCharCount, 0
        jmp endd
        
   endd:
    mov gLineBufPos, 0
    mov gLineBuf, 0
    ret
 
    

start:
	
	invoke crt_printf, offset txtStr, offset processLineFinish
	
	;Открытие и создание файлов ввода вывода
	invoke CreateFileA, ADDR str_input_file,  GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
    mov gInputFile, eax
    
    invoke CreateFileA, ADDR str_output_file, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov gOutputFile, eax
    
    
    ;Чтение строк из входного файла и их обработка
    @ReadAndProcessingString:
    	
        mov gReadCharCount, 0
        mov eax, offset gLineBuf
        
        add eax, gLineBufPos ; eax = gLineBuf + gLineBufPos
        push eax
        
        invoke ReadFile, gInputFile, eax, 1, ADDR gReadCharCount, 0
        pop eax
       
        
        @ReadChar:
			cmp gReadCharCount, 0
				je @CharCountEqualsZero
				jmp @CharCountNotEqualsZero
         
				@CharCountEqualsZero:
					cmp gLineBufPos, 0
						jne @NotEndString
						jmp @EndProcess
						
						@NotEndString:
							call process_line
						
					@EndProcess:
						jmp @LastProcessLine
		   
			@CharCountNotEqualsZero:
        
        
        mov bl, [eax]
        cmp bl, 10 ;Проверка на конец строке (Отступ)
			je @IndentLine
			jmp @NotIndentLine
			@IndentLine:
				call process_line
				jmp @Next
			@NotIndentLine:
				inc gLineBufPos
				jmp @Next	
			@Next:
				jmp @ReadAndProcessingString
				
    
		@LastProcessLine:
			
			mov bl, [eax]
			
			cmp bl, 10 ; ;Проверка на конец строке (Отступ)
				je @IndentLineLast
				jmp @NotIndentLineLast
			@IndentLineLast:
				call process_line
				jmp @EndedLastProcess
			@NotIndentLineLast:
				inc gLineBufPos
				jmp @EndedLastProcess
			
			@EndedLastProcess:
		
		xor eax, eax
		ret
		
end start
