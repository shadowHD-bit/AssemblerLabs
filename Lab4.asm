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
	;Переменная a задается в программе и не меняется в процессе ее исполнения.
	;Переменная x изменяется в диапазоне от 0 до 15.
	
	txtTask db "a = ",0
	txtTaskX db "x = ",0
	txtTaskY1 db "y1 = ",0
	txtTaskY2 db "y2 = ",0
	txtTaskDecimal db "y(10) = ",0
	txtTaskHex db "y(16) = ",0
	DecimalForm db "%d",0 
	HexForm db "%x",0 
	CharForm db "%c",0 
	StringForm db "%s",0 
	dotSpace db ", ",0
	
	maxValueX equ 15
	minValueX equ 0

.data?
	value_a dd ?
	value_y1 dd ?
	value_y2 dd ?
	value_y dd ?
	index dd ?

.code
start:
	
	invoke crt_printf, offset StringForm, addr txtTask
	invoke crt_scanf, offset DecimalForm, offset value_a
	invoke crt_printf, offset CharForm, 10
	
	mov ecx, minValueX
	
	cycl:
		push ecx
		mov index,ecx
		jmp conditionY1
		
		;Условие у1
		conditionY1:
			cmp ecx, 2
				jl xLessTwo
			cmp ecx, 2
				jge xMoreOrEqualsTwo
			jmp conditionY2
		
			xMoreOrEqualsTwo:
				mov eax, value_a
				add eax, 3
				mov	value_y1, eax
				jmp conditionY2
				
			xLessTwo:
				mov eax, 2
				sub eax, ecx
				mov	value_y1, eax
				jmp conditionY2
			
		;Условие у2
		conditionY2:
			cmp ecx, value_a
				jl xLessA
			cmp ecx, value_a
				jge xMoreOrEqualsA
			jmp resultY	
			
			xMoreOrEqualsA:				
				mov eax, value_a
				mov index, ecx
				imul eax, index 
				sub	eax, 1
				mov	value_y2, eax
				jmp resultY	
				
			xLessA:
				mov eax, value_a
				sub eax, 1
				mov	value_y2, eax
				jmp resultY
		
		;Результат	
		resultY:
			mov eax,value_y1
			mov ebx,value_y2
			add eax, ebx
			mov value_y,eax
			jmp output
			
		;Вывод результата
		output:
			invoke crt_printf, offset StringForm, addr txtTaskX
			invoke crt_printf, offset DecimalForm, index 
			invoke crt_printf, offset StringForm, addr dotSpace
			
			invoke crt_printf, offset StringForm, addr txtTaskY1
			invoke crt_printf, offset DecimalForm, value_y1 
			invoke crt_printf, offset StringForm, addr dotSpace
			
			invoke crt_printf, offset StringForm, addr txtTaskY2
			invoke crt_printf, offset DecimalForm, value_y2 
			invoke crt_printf, offset StringForm, addr dotSpace	
			
			invoke crt_printf, offset StringForm, addr txtTaskDecimal
			invoke crt_printf, offset DecimalForm, value_y
			invoke crt_printf, offset StringForm, addr dotSpace
			
			invoke crt_printf, offset StringForm, addr txtTaskHex
			invoke crt_printf, offset HexForm, value_y
			
			invoke crt_printf, offset CharForm, 10
		
		
		;exit 
		pop ecx
		cmp ecx,maxValueX
		je exit_operation
		inc ecx
		jmp cycl
	
		exit_operation:	
			invoke ExitProcess, 0 
	
end start