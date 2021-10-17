.386
.model flat,stdcall
option casemap:none
include includes\user32.inc
includelib includes\user32.lib
include includes\kernel32.inc
includelib includes\kernel32.lib
include includes\msvcrt.inc
includelib includes\msvcrt.lib
.data
formatD db "%d", 0 ;формат для целовых знаковых чисел
formX db "%x", 0 ;формат для целых беззнаковых чисел
formC db "%c", 0 ;формат для символов
formS db "%s", 0 ;формат для строк
text db "Enter number: ", 0
textDec db "Decimal: ", 0
textHex db "Hex: ", 0
textX db "x = ", 0
textY1 db "y1 = ", 0
textY2 db "y2 = ", 0
increment dd 15
changeValue dd ?; значение a
y1 dd ?
y2 dd ?
result dd ?
.code
start:
invoke crt_printf, offset formS, addr text; выводим Enter number
invoke crt_scanf, offset formatD, offset changeValue; считываем что ввели и в change
invoke crt_printf, offset formC, 10; отступ
mov ecx,15; от 0 до 15
CYCL:
push ecx; достаем ecx
mov increment,ecx
mov eax,increment
cmp eax,4; сравнение

jle x_less_or_equals_4; jle меньше либо равно
sub eax,changeValue
mov y1,eax
jmp valueY2

x_less_or_equals_4:
mov eax,changeValue
imul eax,4
mov y1,eax

valueY2:
test ecx,1
jnz nechet ; x нечетное
jz chet ; x четное

nechet:
mov dword ptr [y2], 7 ; y2 = 7
jmp results

chet:
mov eax,ecx ; eax = a
mov bl, 2
div bl; eax = x/2
add eax, changeValue
mov dword ptr [y2], eax ; y2 = x/2+a
jmp results

results:
mov eax,y1
mov ebx,y2
add eax,ebx
mov result,eax
invoke crt_printf, offset formS, addr textX
invoke crt_printf, offset formatD, increment
invoke crt_printf, offset formC, 10
invoke crt_printf, offset formS, addr textY1
invoke crt_printf, offset formatD, y1
invoke crt_printf, offset formC, 10
invoke crt_printf, offset formS, addr textY2
invoke crt_printf, offset formatD, y2
invoke crt_printf, offset formC, 10
invoke crt_printf, offset formS, addr textDec
invoke crt_printf, offset formatD, result
invoke crt_printf, offset formC, 10
invoke crt_printf, offset formS, addr textHex
invoke crt_printf, offset formX, result
invoke crt_printf, offset formC, 10
invoke crt_printf, offset formC, 10
pop ecx
dec ecx
cmp ecx,0
je exit
jmp CYCL
exit:
invoke ExitProcess, 0
end start