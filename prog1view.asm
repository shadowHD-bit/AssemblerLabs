.386

	.model flat,stdcall
	option casemap:none
	include includes\kernel32.inc
	include includes\user32.inc
	includelib includes\kernel32.lib
	includelib includes\user32.lib
	
BSIZE equ 8

	symbA equ 4
	symbB equ 3
	symbC equ 12
	symbD equ 2
	symbE equ 7
	symbF equ 6
	symbG equ 11
	symbH equ 6
	symbK equ 54
	symbM equ 1
	
.data
	formatStr db "%d", 0
	inBuffer db BSIZE dup(?)
	Result dd ?; 
	stdout dd ?
	cWritten dd ?
	
.code
	start:
		
	mov eax, symbA
		
	sub eax, symbB
	add eax, symbC
	add eax, symbD
	add eax, symbE
	sub eax, symbF
	add eax, symbG
	add eax, symbH
	add eax, symbK
	add eax, symbM
	
	mov Result, eax
	
	invoke GetStdHandle, -11 
	mov ebp, offset Result
	mov stdout, eax 
	invoke wsprintf, ADDR inBuffer, ADDR formatStr, Result
	invoke WriteConsoleA, stdout, ADDR inBuffer, BSIZE, ADDR cWritten, 0
	invoke ExitProcess,0
end start

