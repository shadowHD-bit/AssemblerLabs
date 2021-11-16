.386
.model flat,stdcall

include includes\windows.inc
include includes\kernel32.inc
includelib includes\kernel32.lib
.data?
countPoint dd ? 	;точка отсчета
cursorByte db ?		;байты перемещения указателя
byteWritten dd ?	;
.const
fileOutput db "out.txt",0
testText db "Hello World!",0
.code
start:
invoke CreateFileA,offset fileOutput,GENERIC_WRITE,0,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
mov countPoint,eax
invoke GetFileSize,0,eax
invoke SetFilePointer,FILE_BEGIN,0,addr cursorByte,countPoint
invoke WriteFile,countPoint,offset testText,128,offset byteWritten,0	;1 символов
invoke CloseHandle,countPoint
invoke ExitProcess,0
end start
