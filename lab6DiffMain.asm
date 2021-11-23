.386
.model flat, stdcall
option casemap : none

include masm32.inc
include kernel32.inc
includelib masm32.lib
includelib kernel32.lib

MAX_LINE equ 1024
MAX_WORD equ 1024
MAX_WORDS equ 8

; EAX, ECX, and EDX, return in EAX

.data
    str_input_file db "D:/in.txt", 0
    str_output_file db "D:/out.txt", 0
    str_space db " ", 0
    str_lf db 10, 0

    gInputFile dd 0
    gOutputFile dd 0

    gLineBuf db MAX_LINE dup(0)
    gLineBufPos dd 0
    
    gWords db MAX_WORDS * MAX_WORD dup(0)
    gWordLen dd MAX_WORDS dup(0)
    
    gReadCharCount dd 0
    gLineCounter dd 0
    
    gIntBuf db 16 dup(0)

.code

; Prints an integer into the integer buffer
; Returns char count
print_int:
    push ebx
    push esi
    push edi

    mov edi, offset gIntBuf
    xor esi, esi ; string len
    
print_int_loop:
    ; divide eax by 10
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
    ;int 3
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
    
    .while ecx > 0
        mov dl, [esi]
        
        .if dl == ' '
            inc eax
        .endif
        
        dec ecx
        inc esi
    .endw
    
    pop esi
    ret

print_line_number:
    mov eax, gLineCounter
    call print_int
    mov ecx, offset gIntBuf
    
    mov dx, '.'
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
    .while bl != 0
        .if bl == 32 ; ' '
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
        .endif
        
        inc ecx
        mov bl, [ecx]
    .endw
    
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
    
    .if eax == 6 || eax == 7
        push eax
        call split_into_words
        pop eax
        
        dec eax
        .while SDWORD PTR eax >= 0
            push eax
            call print_word
            pop eax
            dec eax
        .endw
        
        invoke WriteFile, gOutputFile, ADDR str_lf, 1, ADDR gReadCharCount, 0
    .else
        ; Output as is
        mov eax, gLineBufPos
        mov edx, offset gLineBuf
        mov cl, 10
        mov [edx+eax], cl
        inc gLineBufPos
        invoke WriteFile, gOutputFile, ADDR gLineBuf, gLineBufPos, ADDR gReadCharCount, 0
    .endif
    
    mov gLineBufPos, 0
    mov gLineBuf, 0
    ret

start:
    ; Open files
    invoke CreateFileA, ADDR str_input_file, 080000000h, 000000001h, 0, 4, 000000080h, 0
    mov gInputFile, eax
    
    invoke CreateFileA, ADDR str_output_file, 040000000h, 0, 0, 2, 000000080h, 0
    mov gOutputFile, eax
    
    ; Read lines
    .while(1)
        mov gReadCharCount, 0
        mov eax, offset gLineBuf
        add eax, gLineBufPos ; eax = gLineBuf + gLineBufPos
        push eax
        invoke ReadFile, gInputFile, eax, 1, ADDR gReadCharCount, 0
        pop eax
        
        .if gReadCharCount == 0
            .if gLineBufPos != 0
                call process_line
            .endif
            .break
        .endif
        
        mov bl, [eax]
        .if bl == 10 ; \n
            call process_line
        .else
            inc gLineBufPos
        .endif
    .endw
    
    xor eax, eax
    ret
    end start
