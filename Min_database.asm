INCLUDE Irvine32.inc
INCLUDE macros.inc
.386
.model flat,stdcall
BUFFER_SIZE = 5001
key = 251
.data
buffer byte BUFFER_SIZE+10 DUP(?)
arr byte BUFFER_SIZE dup(?)
conc byte BUFFER_SIZE dup(?)

arrr byte 4 dup(?)
sorted_arr byte BUFFER_SIZE dup(?)
finalbuffer byte BUFFER_SIZE+10 DUP(?)
eqcount byte 0
filenamee BYTE 20 DUP(?)
filename byte "database_report.txt",0
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;mr.pink
u dword 0
u1 dword 0
TempBuffer BYTE BUFFER_SIZE DUP(?)
sid byte 4 dup(?)
myind dword  ?
fileend dword ?
info byte 13 dup(?)
report_entery byte "StudentID Student Name Numeric Grade Alphabetic_Grade";,0dh,0ah
del byte "#",0
zeft_buffer byte BUFFER_SIZE dup(?)
addrr dword ?
counter byte 0
divident byte 3
;;;;;;;;

.code

;------------------------------------------------
;------------------------------------------------
;take student data from user then put it in arr
;------------------------------------------------
inputfromuserr proc
mov ecx,BUFFER_SIZE
mov edx,offset arr
mov bl,'#'
mov [edx],bl
inc edx
Loo:
mov bl,','	
mwrite "please Enter student ID : "
call readstring
inc eax
add stringLength ,eax
mov eax,stringLength
mov arr[eax],bl
add edx,eax
mwrite "please Enter student Name : "
call readstring
inc eax
add stringLength ,eax
mov esi,stringLength
mov arr[esi],bl
add edx,eax
mwrite "please Enter student Grade : "
call readstring
add stringLength ,eax
mov bl,','
add edx,eax
mov [edx],bl
call alpha_grade
mov bl,'#'
add edx,eax
mov [edx],bl
mov edx,offset arr
add edx,stringLength
add edx,2
mov bl,','	
mwrite"enter another record Y(1)/N(0) : "
call readdec
cmp eax,1
je Loo
add stringLength,5
mov esi,offset arr
mov edi,offset buffer
mov ecx,lengthof arr
rep movsb
mov edx,offset buffer

ret
inputfromuserr endp

;------------------------------------------------
;
;
;store alphaptaic in buffer
;------------------------------------------------
;------------------------------------------------
alpha_grade proc
mov bx,90
cmp word ptr[edx],bx
jae A
mov bx,80
cmp word ptr[edx],bx
jae B
mov bx,70
cmp word ptr[edx],bx
jae CC
mov bx,60
cmp word ptr[edx],bx 
jae D
mov bx,60
cmp word ptr[edx],bx
jb F
jmp error
A:
inc edx
mov bl ,'A'
mov [edx],bl
jmp done
B:
inc edx
mov bl ,'B'
mov [edx],bl
jmp done
CC:
inc edx
mov bl ,'C'
mov [edx],bl
jmp done
D:
inc edx
mov bl ,'D'
mov [edx],bl
jmp done
F:
inc edx
mov bl ,'F'
mov [edx],bl
jmp done

error: 
mwrite"invalid grade please try again later"
done:
ret
alpha_grade endp


update proc id :ptr byte, buf :ptr byte, idl :dword, bul :dword, serRBuf :ptr byte


mov esi,id
mov edi,buf
push edi
add edi,4
mov myind,edi


ag:
add edi,4
mov esi, id
cmp byte ptr[edi],','
jne NR
sub edi,4
mov ecx, 4
sear:

cmp byte ptr[edi],','
je NR
mov dl,[esi]
mov bl,[edi]
inc edi
inc esi
cmp dl,bl
jne NR
 
loop sear
jmp dne

NR:
inc edi
cmp byte ptr[edi],'#'
jne NR
inc edi
mov myind,edi
mov ecx,4
cmp edi, bul
je wr
jmp ag


dne:
pop edi
mov esi,serrbuf
mov ecx,edi
add ecx,bul
l1:
mov bl,[edi]
mov [esi],bl
inc edi
inc esi
cmp edi,myind
jne con
DR:
inc edi
cmp byte ptr[edi],'#'
jne DR
inc edi
con:
cmp edi,ecx
jne l1

push esi
call inputfromuserr
pop esi
mov ebx ,esi
mov esi,offset arr
mov edi,ebx
mov ecx,lengthof arr
rep movsb

jmp re
wr:
mWrite <"invalid id">

re:

ret
update endp




delete proc  id :ptr byte, buf :ptr byte, idl :dword, bul :dword, serRBuf :ptr byte


mov esi,id
mov edi,buf
push edi
add edi,4
mov myind,edi


ag:
add edi,4
mov esi, id
cmp byte ptr[edi],','
jne NR
sub edi,4
mov ecx, 4
sear:

cmp byte ptr[edi],','
je NR
mov dl,[esi]
mov bl,[edi]
inc edi
inc esi
cmp dl,bl
jne NR
 
loop sear
jmp dne

NR:
inc edi
cmp byte ptr[edi],'#'
jne NR
inc edi
mov myind,edi
mov ecx,4
cmp edi, bul
je wr
jmp ag


dne:
pop edi
mov esi,serrbuf
mov ecx,edi
add ecx,bul
l1:
mov bl,[edi]
mov [esi],bl
inc edi
inc esi
cmp edi,myind
jne con
DR:
inc edi
cmp byte ptr[edi],'#'
jne DR
inc edi
con:

cmp edi,ecx
jne l1

mov edx,offset tempbuffer
call writestring
jmp re
wr:
mWrite <"invalid id">

re:

ret
delete endp

;-------------------------------------------------------
; BubbleSort
; Sort an array of 32-bit signed integers in ascending
; order, using the bubble sort algorithm.
; Receives: pointer to array, array size
; Returns: nothing
;-------------------------------------------------------
BubbleSort PROC USES eax ecx esi,
pArray:PTR Dword,     ; pointer to array
Count:DWORD           ; array size
mov ecx,Count
dec ecx               ; decrement count by 1

L1: push ecx          ; save outer loop count
mov esi,pArray        ; point to first value
L2: mov eax,[esi]     ; get array value
cmp byte ptr [esi+4],'0'
jb L4
cmp byte ptr[esi+4],'9'
ja L4
cmp [esi+4],eax       ; compare a pair of values
jg L3                 ; if [ESI] <= [ESI+4], no exchange
xchg eax,[esi+4]      ; exchange the pair
mov [esi],eax
L3: add esi,4         ; move both pointers forward
loop L2               ; inner loop
pop ecx               ; retrieve outer loop count
loop L1               ; else repeat outer loop
L4: ret
BubbleSort ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;search with paramters 
;;offset of id , buffer offset,id size, buffer size,return array offset
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

search proc serid :ptr byte, serbuf :ptr byte, seridl :dword, serbul :dword,fbl :ptr dword,snb :dword, serRBuf :ptr byte

mov esi,serid
mov edi,serbuf
push edi
add edi,4
mov myind,edi


ag:
add edi,4
mov esi, serid
cmp byte ptr[edi],','
jne NR
sub edi,4
mov ecx, 4
sear:

cmp byte ptr[edi],','
je NR
mov dl,[esi]
mov bl,[edi]
inc edi
inc esi
cmp dl,bl
jne NR
 
loop sear
jmp done

NR:
inc edi
cmp byte ptr[edi],'#'
jne NR
inc edi
mov myind,edi
mov ecx,4
cmp edi, serbul
je wr
jmp ag

done:
mov eax,fbl
mov edi,myind
mov esi,serrbuf
add esi,snb
l:
mov bl,[edi]
mov [esi],bl
inc esi
inc edi
add dword ptr[eax],1
cmp byte ptr[edi],'#'
jne l
wr:
ret
search endp

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
call report
mwrite "enter 0 to repeat this transaction or else done"
call readdec
cmp eax,0
je genfull
jmp donny



disstd:
call ofile 

mwrite"please Enter the student ID in 4 digits ex:0055 : "
mov edx,offset sid

mov edi,offset buffer
mov ecx,5
call readstring
mov u1,0
invoke search , offset sid ,  offset buffer , 4 , stringLen, offset u , u1 , offset finalbuffer
mov ecx,u
mov edx,offset finalbuffer
	call writestring
	call crlf
	jmp endy





	delstd:
	call ofile
	mov edx, offset buffer
mwrite "please enter student ID like 0055:"
mov edx, offset sid
mov ecx,5
call readstring
mov edx, offset buffer
call writestring
invoke delete,offset sid,offset buffer,4,stringLen, offset finalbuffer
mov esi,offset finalbuffer
mov edi,offset buffer
mov ecx,lengthof buffer
mov edi,3
rep movsb
call addkey
;
	;mov edx, offset filenamee
;call createoutputfile
;mov fileHandle ,eax
;
;mov eax,fileHandle
	;mov edx,OFFSET buffer
	;mov ecx , stringLen
	;call WriteToFile
	;call CloseFile
;
;jmp done



upstd:

mwrite "enter id in 4 digits : "
mov edx, offset sid
mov ecx,5
call readstring

invoke update , offset sid, offset buffer, 4, lengthof buffer, offset finalbuffer
mov esi,offset finalbuffer
mov edi,offset buffer
mov ecx,lengthof finalbuffer
rep movsb
je done




enrollnewstudentwithfile:
mov edx,offset buffer
pool:
call enrollstd

mwrite "enter 0 to repeat this transaction or else done"
call readdec
cmp eax,0
je pool
jmp createnewfileend




enstd:
;return stringLen 
call ofile
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
call createfile_
call encrypt
donny:
jmp endy
done:
call encrypt
call createfile_

createnewfileend:
;call encrypt
call createfileonly
endy:
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
add edx,eax
call readdec
cmp eax,1
je savee
jmp looop
savee:
mov ebx,countbyte
inc ebx
mov stringLen,ebx
mov bl,'#'
inc edx
mov byte ptr[edx],bl
inc stringLen

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
call encrypt
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
exit                              ; and quit
file_ok:
; Read the file into a buffer.
mov edx,OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
mov stringLen,eax 
mWrite "File size: "
call WriteDec                        ; display file size
call Crlf 
call encrypt             
mov edx,OFFSET buffer
mov ebx,offset newkey
mov ecx,lengthof newkey
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
 report proc
X:
mwrite "Please Enter File Name : "
mov edx,offset filenamee
mov ecx,lengthof filenamee
call readstring
;open file 
mov edx,OFFSET filenamee
call OpenInputFile
mov fileHandle,eax

;load file data
mov edx,OFFSET buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
mov stringLen,eax
;call encrypt

mwrite "full report sorted by ID(1)/Grade(2): "
call readdec	
cmp eax,1
je IDSORT
cmp eax,2
je GRADESort
mwrite "invalid option try again"
jmp X


IDSORT:
getallid:
mov edx ,offset buffer
mov ecx,lengthof buffer
mov edi,offset arr
add edx,3
lop:
cmp byte ptr[edx],'#'
je store_id
jmp skip

store_id:
inc edx
mov ebx," "
cmp [edx],ebx
je quit
push ecx
mov ecx,4

lo:
mov bl,[edx]
mov [edi],bl
inc edi
inc edx
loop lo

pop ecx
skip:
inc edx
loop lop

invoke BubbleSort ,offset arr,lengthof arr
;;; we should now call search fun to return records in sorted array 
;;; i will pass to it sorted array

mov esi,offset report_entery
mov ecx,lengthof report_entery
mov edi,offset  finalbuffer
rep movsb


;mov u1,lengthof report_entery
; u1,2


mov esi,0
llll:
push ecx
mov ecx,4
mov edi,0
lala:
mov bl,arr[esi]
mov arrr[edi],bl
inc esi
inc edi
loop lala
push esi
invoke search , offset arrr ,  offset buffer , 4 , lengthof buffer , offset u , u1 , offset finalbuffer

mov ebx , u1
sub ebx,2
mov finalbuffer[ebx], 0dh
inc ebx
mov finalbuffer[ebx], 0ah

mov edx,offset finalbuffer
add u,2
mov eax,u
mov u1,eax
pop esi
pop ecx

cmp arr[esi],'0'
jb cdnee
cmp arr[esi],'9'

jb llll

cdnee:
mov edx, offset filename
call createoutputfile
mov fileHandle ,eax
; Check for errors.
cmp eax, INVALID_HANDLE_VALUE      ; error found?
jne file_ok                        ; no: skip
mov edx,OFFSET str1                ; display error
call DisplayMessage
exit
;;;;;;;;;;;;;;;;;;;;;;;;;;
GRADESort:
mov edx ,offset buffer
mov ecx,lengthof buffer
mov edi,offset arr
LOOL:
cmp byte ptr [edx],','
je cnt
inc edx
jmp donne

cnt:
mov eax,0
inc counter
mov al,counter
div divident
cmp ah,0
je donelool
jmp donne

donelool:
mov ebx ,0
inc edx
mov bl,[edx]
mov [edi],bl
inc edi
donne:
loop LOOL
invoke BubbleSort ,offset arr,lengthof arr
;;;;;test;;;;;
mov edx,offset arr
mov ecx,lengthof arr
call writestring


;;;;;;;;;;;;;;;;;;;;;;;;;;
file_ok:
 
    mov eax,fileHandle
	mov edx,OFFSET finalbuffer
	mov ecx , lengthof   finalbuffer
	call WriteToFile
	call CloseFile
quit:
ret
report endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



end main