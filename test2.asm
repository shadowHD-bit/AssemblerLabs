.386

.model flat, stdcall

option casemap :none

include includes\masm32rt.inc

BSIZE = 8

.data

textA db "Enter a: "
textB db 10, "Enter b: "
A db 10, "a = "
B db 10, "b = "
A_B db 10, "a+b = "
cDel8 db 10, "(a+b)/8 = "
Permutation db 10, "Permutation: "
ifmt db 10, 13, "%x"
ifmtN db "%x"
perenos db 10
a db ?
b db ?
cc dw ?
ones db "1"
nols db "0"
v db ?
v1 dw ?
rez db 0 ;
hit dd ?
hout dd ?

output dd BSIZE dup(?)

@out dd ?
@in dd ?

r dd 8

min equ 1
max equ 8

.code

start:

invoke GetStdHandle, STD_OUTPUT_HANDLE
mov hout, eax
invoke GetStdHandle, STD_INPUT_HANDLE
mov hit, eax
invoke WriteConsole, hout, addr textA, sizeof textA, addr @out, NULL
invoke SetConsoleMode, hit, 0


mov ecx,min

@ReadBiNumber:

push ecx

invoke ReadConsole, hit, addr output, 1, addr @in, NULL
	mov eax, output
	
	cmp eax, 31h
	je @Number_One
	
	cmp eax, 30h
	je @Number_Zero
	
	cmp eax, 1
	jg @Unknow_Number
	
	jmp exitt

@Number_Zero:
	invoke WriteConsole, hout, addr output, 1, addr @out, NULL
	
	add a, 0
	shl a, 1
	jmp @Repeat

@Number_One:
	invoke WriteConsole, hout, addr output, 1, addr @out, NULL
	
	add a, 1
	shl a, 1
	jmp @Repeat

@Unknow_Number:
	jmp @ReadBiNumber

@Repeat:
	
	pop ecx
	cmp ecx,max
	je exitt
	inc ecx
	jmp @ReadBiNumber



exitt:
	invoke WriteConsole, hout, addr A, sizeof A, addr @out, NULL
	
	vA:
	mov r, 8
	mov al, a
	mov v, al
	ror v, 7
	test v, 00000001b
	jz nolA
	invoke WriteConsole, hout, addr ones, sizeof ones, addr @out, NULL
	jmp @repVA
	nolA:
	invoke WriteConsole, hout, addr nols, 1, addr @out, NULL
	@repVA:
	rol v, 1
	dec r
	mov eax, r
	jnz vA
	
	
	
	
	exit

end start
