INCLUDE Irvine32.inc
INCLUDE macros.inc
.386
.model flat,stdcall
BUFFER_SIZE = 5001
key = 251
.data
buffer byte BUFFER_SIZE+10 DUP(?)
arr byte BUFFER_SIZE dup(?)
filenamee BYTE 80 DUP(?)
newkey byte 3 dup(?)
keylength dword 0
fileHandle HANDLE ?
stringLength Dword ?
stringLen Dword 0
countbyte Dword 0

bytesWritten Dword ?
str1 BYTE "Cannot create file",0dh,0ah,0
keylog BYTE "[please Enter the db-key ]: ",0
updatestudent byte "Enter Student ID to Update: ",0
delstudent byte "Enter Student ID to Delete: ",0
DisplaySTD byte "Enter Student ID to Display info: ",0
op1 byte "1-for Enroll Student in existed file. ",0 
op6 byte "6-for Enroll Student in new file. ",0 
op2 byte "2-for Update Student Data. ",0 
op3 byte "3-for Delete Student Data. ",0  
op4 byte "4-for Display it's info. ",0  
op5 byte "5-for Generate Full Report. ",0
sav byte "enter 1 to save all work.",0
op0 byte "0-for exit. ",0
enroll byte "Enter Student's ID and Grade seprated by :@: :",0


.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main proc
mov edx,offset op1
call DisplayMessage
mov edx,offset op6
call DisplayMessage
mov edx,offset op2
call DisplayMessage
mov edx,offset op3
call DisplayMessage
mov edx,offset op4
call DisplayMessage
mov edx,offset op5
call DisplayMessage
mov edx,offset op0
call DisplayMessage
call comparing
exit
main endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;comparing  input  proc for startup
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
comparing proc
pushad
lo:
call readdec
cmp eax ,0
je done
cmp eax,1
je  enstd
cmp eax,2
je upstd
cmp eax,3
je delstd
cmp eax,4
je disstd
cmp eax,5
je genfull
cmp eax,6
je enrollnewstudentwithfile
jmp lo


genfull:
;call report
mwrite "enter 0 to repeat this transaction or else done"
call readdec
cmp eax,0
je genfull
jmp done
disstd:
;call displayinfo
mwrite "enter 0 to repeat this transaction or else done"
call readdec
cmp eax,0
je disstd
jmp done
delstd:
;call deletestudent
mwrite "enter 0 to repeat this transaction or else done"
call readdec
cmp eax,0
je delstd
jmp done
upstd:
;call updatestudent
mwrite "enter 0 to repeat this transaction or else done"
call readdec
cmp eax,0
je upstd
jmp done

enrollnewstudentwithfile:
call enrollstd
mwrite "enter 0 to repeat this transaction or else done"
call readdec
cmp eax,0
je enrollnewstudentwithfile
popad
exit

enstd:
;return stringLen 
call ofile
call encrypt
enstudent:
;return stringLength
call inputfromuser
mov edi,offset arr
mov esi,offset buffer
add esi,stringLen
mov ecx,stringLength

lol:
mov bl,[edi]
mov [esi],bl
inc edi
inc esi
loop lol
mov ebx,stringLen
add ebx,stringLength
mov stringLen,ebx
mwrite "enter 0 to repeat this transaction or else done"
call readdec
cmp eax,0
je enstudent
done:
call encrypt
call createfile_
popad
exit
ret
comparing endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;paramter : take offset in edx and display 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DisplayMessage PROC
;display the message
pushad
call writestring
call Crlf
popad
ret
DisplayMessage endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;proc to encrypt and decrypt using XOR instruction
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
encrypt proc
pushad
mov ecx,stringLen
cmp ecx,0
je done
mov esi,0
Lo:
xor buffer[esi],key ; translate a byte
inc esi
loop Lo
jmp done
mWrite <"Buffer:",0dh,0ah,0dh,0ah>
mov edx,OFFSET buffer                ; display the buffer
call WriteString
call Crlf
done:
popad
ret 
encrypt endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;proc to create file(createoutputfile) instruction
;;write into file from buffer after encrypt data with( writetofile)
;;then use(closefile)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
createfile_ proc
;create new file
pushad
mov edx, offset filenamee
call createoutputfile
mov fileHandle ,eax
; Check for errors.
cmp eax, INVALID_HANDLE_VALUE      ; error found?
jne file_ok                        ; no: skip
mov edx,OFFSET str1                ; display error
call DisplayMessage
exit
file_ok:
    
    mov eax,fileHandle
	mov edx,OFFSET buffer
	mov ecx , stringLen
	call WriteToFile
	call CloseFile

popad
;exit
ret
createfile_ endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;enroll student and button save
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
enrollstd proc
mov edx,offset buffer
looop:
mov byte ptr[edx],'#'
inc edx
push edx
mov edx,offset enroll
call writestring
pop edx
mov ecx ,BUFFER_SIZE
call readstring
add countbyte,eax
push edx 
mov edx,offset sav
call writestring
pop edx
call readdec
cmp eax,1
je savee
jmp looop
savee:
mov ebx,countbyte
mov stringLen,ebx
call encrypt
call createfileonly

ret
enrollstd endp




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
createfileonly proc
;create new file
pushad
mwrite "Enter the new file name with .txt : "
mov edx,offset filenamee
mov ecx,lengthof filenamee
call readstring
mwrite "Enter the new file key 0-255: "
mov edx,offset newkey
call readstring
mov keylength,eax
call addkey
mov edx, offset filenamee
call createoutputfile
mov fileHandle ,eax
; Check for errors.
cmp eax, INVALID_HANDLE_VALUE      ; error found?
jne file_ok                        ; no: skip
mov edx,OFFSET str1                ; display error
call DisplayMessage
exit
file_ok:
 
    mov eax,fileHandle
	mov edx,OFFSET buffer
	mov ecx , stringLen
	call WriteToFile
	call CloseFile
popad
;exit
ret
createfileonly endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inputfromuser proc
mov edx ,offset enroll
call writestring
mov ecx,BUFFER_SIZE
mov edx,offset arr
call readstring
mov stringLength ,eax
ret
inputfromuser endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ofile proc
loo:
mwrite "Enter the file name with .txt:"
mov ecx,lengthof filenamee
mov edx,offset filenamee
call readstring
mwrite "Enter the DBkey: "
mov ecx,lengthof newkey
inc ecx
mov edx,offset newkey
call readstring
mov newkey[eax],0

mov edx,OFFSET filenamee
call OpenInputFile
mov fileHandle,eax

cmp eax,INVALID_HANDLE_VALUE      ; error opening file?
jne file_ok                       ; no: skip
mWrite <"Cannot open file",0dh,0ah>
exit                         ; and quit
file_ok:
; Read the file into a buffer.
mov edx,OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
mov stringLen,eax 
mWrite "File size: "
call WriteDec                        ; display file size
call Crlf              
mov edx,OFFSET buffer
mov ebx,offset newkey
mov ecx,3
l1:
mov al,[edx]
cmp al,[ebx]
jne err
inc edx
inc ebx
loop l1
jmp donee
err:
mwrite "Database Error Key Not Found!! try again"
mov eax,fileHandle
call CloseFile
jmp loo
donee:
mov eax,fileHandle
call CloseFile

ret
ofile endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;write the key in file
addkey proc
mov eax,3
add eax,stringLen
mov esi,offset buffer
add esi,stringLen
mov edi,offset buffer
add edi,eax
mov ecx,stringLen
mov stringLen,eax
mov ebx,0
l1:
mov bl,[esi]
mov [edi],bl
dec edi
dec esi
loop l1
mov ebx,0
mov edi,offset buffer
mov edx,offset newkey
mov ecx,lengthof newkey
l2:
mov bl,[edx]
mov [edi],bl
inc edx
inc edi
loop l2



ret
addkey endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end main