INCLUDE Irvine32.inc
INCLUDE macros.inc
.386
.model flat,stdcall
BUFFER_SIZE = 5001
key = 251
.data
buffer byte BUFFER_SIZE DUP(?)
filename byte "database.txt",0
filenamee BYTE 80 DUP(0)
fileHandle HANDLE ?
stringLength Dword ?
bytesWritten Dword ?
str1 BYTE "Cannot create file",0dh,0ah,0
str2 BYTE "Bytes written to file [database.txt]:",0
str3 BYTE "Enter up to 500 characters and press"
BYTE "[Enter]: ",0

enroll byte "Enter Student's ID and Grade seprated by @ :"
;str1 byte "Enter Student Grade: ",0

.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main proc
call  createfile_
exit
	
main endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DisplayMessage PROC
;display the message
pushad
call writestring
;call Crlf
popad
ret
DisplayMessage endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
encrypt proc
pushad
mov ecx,stringLength
mov esi,0
Lo:
xor buffer[esi],key ; translate a byte
inc esi
loop Lo
popad
ret 
encrypt endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

createfile_ proc
;create new file
pushad
mov edx, offset filename
call createoutputfile
mov fileHandle ,eax
; Check for errors.
cmp eax, INVALID_HANDLE_VALUE      ; error found?
jne file_ok ; no: skip
mov edx,OFFSET str1                ; display error
call DisplayMessage
exit
file_ok:
;Ask the user to input a string
mov edx, offset enroll
call DisplayMessage
mov ecx,BUFFER_SIZE
mov edx, offset buffer
call readstring
mov stringlength ,eax
call encrypt

; Write the buffer to the output file.
mov eax, filehandle
mov edx,offset buffer
mov ecx,stringlength
call writetofile
mov byteswritten ,eax
call closefile
; Display the return value.
mov edx,OFFSET str2 ; "Bytes written"
call DisplayMessage
mov eax,bytesWritten
call WriteDec
call Crlf
popad
ret
createfile_ endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Rfile proc
; Let user input a filename.
mWrite "Enter an input filename: "
mov edx,OFFSET filenamee
mov ecx,SIZEOF filenamee
call ReadString
; Open the file for input.
mov edx,OFFSET filename
call OpenInputFile
mov fileHandle,eax
; Check for errors.
cmp eax,INVALID_HANDLE_VALUE ; error opening file?
jne file_ok ; no: skip
mWrite <"Cannot open file",0dh,0ah>
exit ; and quit
file_ok:
; Read the file into a buffer.
mov edx,OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
jnc check_buffer_size ; error reading?
mWrite "Error reading file. " ; yes: show error message
call WriteWindowsMsg
jmp close_file
check_buffer_size:
cmp eax,BUFFER_SIZE ; buffer large enough?
jb buf_size_ok ; yes
mWrite <"Error: Buffer too small for the file",0dh,0ah>
jmp quit ; and quit
buf_size_ok:
mov buffer[eax],0 ; insert null terminator
mWrite "File size: "
call WriteDec ; display file size
call Crlf

; Display the buffer.
mWrite <"Buffer:",0dh,0ah,0dh,0ah>
mov edx,OFFSET buffer ; display the buffer
call WriteString
call Crlf
close_file:
mov eax,fileHandle
call CloseFile
quit:
exit
ret
Rfile endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end main