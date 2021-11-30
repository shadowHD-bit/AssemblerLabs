.386

.model flat,stdcall

option casemap:none

include includes\kernel32.inc

include includes\user32.inc

include \masm32\include\windows.inc

includelib includes\kernel32.lib

includelib includes\user32.lib

.data

openfile db "C:\Users\USER\Desktop\in.txt",0

savefile db "C:\Users\USER\Desktop\out.txt",0

dot db "%d. ", 0

pr_enter db 0Dh, 0Ah

STR_SIZE equ 35

BSIZE equ 256

n dd ? ;количество итераций в цикле

lenstr dd ? ;длина строки в байтах

startfirstword dd ? ; начало первого слова

startsecondword dd ? ; начало второго слова

minwordlen dd ? ;минимальная длина слова

create_str db STR_SIZE dup(?) ;строка со словами

firstword db BSIZE dup(?) ;первое слово

secondword db BSIZE dup(?) ;второе слово

outFile dd ?

inFile dd ?

lenfirstword dd ? ;длина первого слова

lensecondword dd ? ;длина второго слова

cWritten dd ?

LpDistance dd ?

cRead dw ?

stat dd ? ;является индикатором, была ли перестановка

filesize dd ? ;объем файла в байтах

N dd 0 ;номер слова

numstr dd 0

shift dd ?

msgBuf db 3 dup(?)

spaces dd ? ;количество пробелов в строке

buf db ? ; буфер, где храниться текст из файла

.code

start:

invoke CreateFileA, ADDR savefile, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0

mov outFile, eax

invoke CreateFileA, ADDR openfile, GENERIC_READ, 0, 0, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0

mov inFile, eax

;чтение данных из файла

invoke GetFileSize, inFile, NULL

mov filesize, eax

invoke SetFilePointer, FILE_BEGIN, 0, ADDR LpDistance, inFile

invoke ReadFile, inFile, ADDR buf, filesize, ADDR cRead, 0

;цикл для обработки каждой строки по отдельности

readstrloop:

mov ecx, STR_SIZE ;помещаем в регистр ecx размер строки

mov esi, offset buf ;помещаем в регистр esi адресс буфера

add esi, shift ;добавляем смещение

mov edi, offset create_str ;добавляем в edi строку, в которую будет производиться запись

xor edx, edx ;обнуляем регистр edx

readstr:

lodsb ;считываем буквы

cmp ax, 13 ;проверяем на конец строки

je endreadstr ;если нашли переход на новую строку - прекращаем считывать

cmp ax, ' ' ;считаем пробелы в регистре edx

jne notSpace

inc edx

notSpace:

stosb ;записываем букву в конечную строку

loop readstr

endreadstr:

mov spaces, edx ;количество пробелов определяет возможное количество перестановок в строке за раз

mov eax, STR_SIZE

sub eax, ecx

mov lenstr, eax ;длину строки определяем, как разность начального и конечного значения регистра ecx

strsort:

mov stat, 0 ;зануляем переменную статуса

mov startfirstword, 0 ;зануляем переменную начала первого слова

mov eax, spaces

mov n, eax ;количество раз, которые выполнит следующий цикл при одном заходе

instrsort:

mov lenfirstword, 0 ;зануляем длину первого слова

mov lensecondword, 0 ;зануляем длину второго слова

mov N, 0 ;переменная, показывающая номер записываемого слова

;обнуляем все регистры для избежания ошибок

xor eax, eax

xor esi, edi

xor edi, edi

xor edx, edx

xor ecx, ecx

;перемещаем слова в буферы

mov edx, offset firstword ;в регистр edx помещаем первое считываемое слово

mov eax, startfirstword

mov startsecondword, eax ;первоначально старты первого и второго слов совпадают

readwords:

mov ecx, lenstr ;длину устанавливаем в длину строки

mov esi, offset create_str ;считываем с данной строки смещение, чтобы найти начало слова

add esi, eax

mov edi, edx ;адрес буфера слова

inc N ;cообщаем, что работаем с первым словом

cld

loopcopyword:

inc startsecondword ;увеличиваем смещение, указывающее на второе слово

lodsb ;считываем буквы

cmp ax, ' ' ;проверяем на пробел

je copyend ;если да - то завершаем копирование

stosb ;записываем букву в буфер

cmp N, 1 ;если N = 1 - увеличиваем длину первого слова

jne not1

inc lenfirstword

jmp cont

not1:

inc lensecondword ;иначе увеличиваем длину второго слова

cont:

mov eax, lenstr

cmp eax, startsecondword ;проверяем, является ли символ последним в строке

je copyend ;если да - завершаем копирование

loop loopcopyword

copyend:

cmp N, 2 ;если было обработано только первое слово

je endread ;помещаем переменные в нужные регистры

mov eax, startsecondword ;иначе случае выходим из цикла

mov edx, offset secondword

jmp readwords

endread:

mov eax, lenfirstword

cmp eax, lensecondword

jb @2

mov eax, lensecondword

mov minwordlen, EAX

jmp @3

@2:

mov minwordlen, eax

@3:

mov ecx, 0

compareloop:

mov al, firstword[ecx]

cmp al, secondword[ecx]

jne endcompareloop

inc ecx

cmp ecx, minwordlen

jne compareloop

endcompareloop:

;сравниваем по порядку буквы каждого слова

cmp al, secondword[ecx] ;если слова находятся в правильно порядке

jle rightorder

inc stat ; в пр. случае - говорим, что произошла перестановка

mov ecx, lensecondword

mov esi, offset secondword ;считываем с буфера второго слова

mov edi, offset create_str ;в строку

add edi, startfirstword ;с смещением начала первого слова

cld

refillfirstword: ;перезаписываем первое слово

lodsb

stosb

loop refillfirstword

mov eax, lensecondword

add eax, startfirstword

mov create_str[eax], ' ' ;добавляем пробел между словами

inc lensecondword ;перезаписываем первое слово на место второго

mov ecx, lenfirstword

mov esi, offset firstword

mov edi, offset create_str

add edi, startfirstword

add edi, lensecondword ;второе слово должно находиться со смещением на единицу больше от начала строки равным длине первого слова

cld

refillsecondword:

lodsb

stosb

loop refillsecondword

mov eax, lensecondword

jmp skiprightorder

rightorder:

inc lenfirstword

mov eax, lenfirstword

skiprightorder:

add startfirstword, eax ;заменяем начало первого слова, теперь оно начало второго слова

dec n ;уменьшаем n

cmp n, 0 ;если n = 0 то выходим из цилка

jne instrsort

cmp stat, 0 ;если в строке были перестановки то выполняем цикл еще раз

jne strsort ;иначе идём дальше

inc numstr

invoke wsprintf, ADDR msgBuf, ADDR dot, numstr ;вызываем скрипт, чтобы указать номер строки в результате

dec numstr

;записываем отсортированную строку и её номер в файл

invoke SetFilePointer, FILE_CURRENT, 0, ADDR LpDistance, outFile

invoke WriteFile, outFile, ADDR msgBuf, 3, ADDR cWritten, 0

invoke WriteFile, outFile, ADDR create_str, lenstr, ADDR cWritten, 0

invoke WriteFile, outFile, ADDR pr_enter, 2, ADDR cWritten, 0

add lenstr, 2 ;добавляем 2, чтобы он указывал на начало слд. строки

mov eax, lenstr

add shift, eax ;помещаем в смещение

inc numstr ;увеличиваем номер строки

jmp readstrloop

;закрываем дескриптора и завершаем программу

invoke CloseHandle, outFile

invoke CloseHandle, inFile

invoke ExitProcess, 0

end star
