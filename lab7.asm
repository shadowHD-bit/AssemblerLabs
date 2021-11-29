
.386
.model flat, stdcall
option casemap :none
include includes\masm32.inc
include includes\kernel32.inc
include includes\macros\macros.asm
includelib includes\masm32.lib
includelib includes\kernel32.lib
include includes\msvcrt.inc
includelib includes\msvcrt.lib

.data
	text_entered_a db "Enter Number A: "
	text_entered_b db "Enter Number B: "
	text_entered_c db "Enter Number C: "
	text_entered_d db "Enter Number D: "
	text_entered_e db "Enter Number E: "
	text_entered_f db "Enter Number F: "
	text_entered_g db "Enter Number G: "
	text_entered_h db "Enter Number H: "
	text_entered_k db "Enter Number K: "
	text_entered_m db "Enter Number M: "
	
	text_zero db "0"
	text_one db "1"
	text_two db "2"
	text_three db "3"
	text_four db "4"
	text_five db "5"
	text_six db "6"
	text_seven db "7"
	text_eight db "8"
	text_night db "9"
	index dd 9

.data?

	STD_INPUT dd ?
	STD_OUTPUT dd ?
	INPUT_BUFFER dd ?
	OUTPUT_BUFFER dd ?
	bit_buffer dd ?

.code

start:



	mov edx, 0

	invoke GetStdHandle, -10
		mov STD_INPUT, eax
	invoke GetStdHandle, -11
		mov STD_OUTPUT, eax
	invoke SetConsoleMode, STD_INPUT, 0
	
	@Main:
		
	
	call PROC_ENTER_TEXT	
	call PROC_VALID_NUMBER


PROC_ENTER_TEXT:
	cmp index, 10
	je vvoda
	
	cmp index, 9
	je vvodb
	
	cmp index, 8
	je vvodc
	
	cmp index, 7
	je vvodd
	
	cmp index, 6
	je vvode
	
	cmp index, 5
	je vvodf
	
	cmp index, 4
	je vvodg
	
	cmp index, 3
	je vvodh
	
	cmp index, 2
	je vvodk
	
	cmp index, 1
	je vvodm
	
	vvoda:
	invoke WriteConsole, STD_OUTPUT, addr text_entered_a, sizeof text_entered_a, addr OUTPUT_BUFFER, 0
	vvodb:
	invoke WriteConsole, STD_OUTPUT, addr text_entered_b, sizeof text_entered_b, addr OUTPUT_BUFFER, 0
	vvodc:
	invoke WriteConsole, STD_OUTPUT, addr text_entered_c, sizeof text_entered_c, addr OUTPUT_BUFFER, 0
	vvodd:
	invoke WriteConsole, STD_OUTPUT, addr text_entered_d, sizeof text_entered_d, addr OUTPUT_BUFFER, 0
	vvode:
	invoke WriteConsole, STD_OUTPUT, addr text_entered_e, sizeof text_entered_e, addr OUTPUT_BUFFER, 0
	vvodf:
	invoke WriteConsole, STD_OUTPUT, addr text_entered_f, sizeof text_entered_f, addr OUTPUT_BUFFER, 0
	vvodg:
	invoke WriteConsole, STD_OUTPUT, addr text_entered_g, sizeof text_entered_g, addr OUTPUT_BUFFER, 0
	vvodh:
	invoke WriteConsole, STD_OUTPUT, addr text_entered_h, sizeof text_entered_h, addr OUTPUT_BUFFER, 0
	vvodk:
	invoke WriteConsole, STD_OUTPUT, addr text_entered_k, sizeof text_entered_k, addr OUTPUT_BUFFER, 0
	vvodm:
	invoke WriteConsole, STD_OUTPUT, addr text_entered_m, sizeof text_entered_m, addr OUTPUT_BUFFER, 0
	
	
	invoke ReadConsole, STD_INPUT, addr bit_buffer, 1, addr INPUT_BUFFER, 0
		mov eax, bit_buffer	
	

PROC_VALID_NUMBER proc
	
@vvod:
	cmp eax, 13
		je @press_enter
	
	cmp eax, 30h
		je @if_number_zero
				
	cmp eax, 31h
		je @if_number_one

	cmp eax, 32h
		je @if_number_two
		
	cmp eax, 33h
		je @if_number_three
	
	cmp eax, 34h
		je @if_number_four
		
	cmp eax, 35h
		je @if_number_five
		
	cmp eax, 36h
		je @if_number_six
		
	cmp eax, 37h
		je @if_number_seven
		
	cmp eax, 38h
		je @if_number_eight

	cmp eax, 39h
		je @if_number_night


	@press_enter:
		dec index
		jmp @vvod

	@if_number_zero:
		invoke WriteConsole, STD_OUTPUT, addr text_zero, 1, addr OUTPUT_BUFFER, 0
		jmp @vvod
		
	@if_number_one:
		invoke WriteConsole, STD_OUTPUT, addr text_one, 1, addr OUTPUT_BUFFER, 0
		jmp @vvod
		
	@if_number_two:
		invoke WriteConsole, STD_OUTPUT, addr text_two, 1, addr OUTPUT_BUFFER, 0
		jmp @vvod
		
	@if_number_three:
		invoke WriteConsole, STD_OUTPUT, addr text_three, 1, addr OUTPUT_BUFFER, 0
		jmp @vvod
		
	@if_number_four:	
		
		invoke WriteConsole, STD_OUTPUT, addr text_four, 1, addr OUTPUT_BUFFER, 0
		jmp @vvod
	@if_number_five:	
		invoke WriteConsole, STD_OUTPUT, addr text_five, 1, addr OUTPUT_BUFFER, 0
		jmp @vvod
		
	@if_number_six:	
		invoke WriteConsole, STD_OUTPUT, addr text_six, 1, addr OUTPUT_BUFFER, 0
		jmp @vvod
		
	@if_number_seven:
		invoke WriteConsole, STD_OUTPUT, addr text_seven, 1, addr OUTPUT_BUFFER, 0
		jmp @vvod
		
	@if_number_eight:
		invoke WriteConsole, STD_OUTPUT, addr text_eight, 1, addr OUTPUT_BUFFER, 0
		jmp @Main
		
	@if_number_night:
		invoke WriteConsole, STD_OUTPUT, addr text_night, 1, addr OUTPUT_BUFFER, 0
		jmp @Main
		
PROC_VALID_NUMBER endp	

end start
