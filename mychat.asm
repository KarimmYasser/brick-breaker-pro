scrollPageUp MACRO num, fx, fy, ex, ey, va
	mov ah, 06h
    mov al, num
	mov bh, va
	mov ch, fx
	mov cl, fy
	mov dh, ex
	mov dl, ey
	int 10h
ENDM scrollPageUp
saveSCursor MACRO
    mov ah, 03h
    mov bh, 0h
    int 10h
    mov sendX, dl
    mov sendY, dh
ENDM saveSCursor
saveRCursor MACRO
    mov ah, 03h
    mov bh, 0h
    int 10h
    mov recieveX, dl
    mov recieveY, dh
ENDM saveRCursor
setCursor MACRO x, y
	mov ah, 2
	mov bh, 0
	mov dl, x
	mov dh, y
	int 10h
ENDM setCursor
InitCom MACRO
    ;Set Divisor Latch Access Bit
    mov dx,3fbh 			; Line Control Register
    mov al,10000000b		;Set Divisor Latch Access Bit
    out dx,al				;Out it
    ;Set LSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f8h			
    mov al,0ch			
    out dx,al

    ;Set MSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f9h
    mov al,00h
    out dx,al

    ;Set port configuration
    mov dx,3fbh
    mov al,00011011b
    out dx,al
ENDM InitCom

.model SMALL
.stack 64
.data
    var db ?
    sendX db 0
    sendY db 0Bh
    recieveX db 0
    recieveY db 18h
.code
main proc far
    mov ax, @data
    mov ds, ax
    
    ; initinalize COM
    initCom

    ;draw the screen
    scrollPageUp 0Dh, 0, 0, 11, 79, 03h
    scrollPageUp 0Dh, 12, 0, 24, 79, 030h

    ;set the cursor
    setCursor 0, 0Bh
    mov ah, 01h
    mov ch, 20h
    int 10h

detect:
    mov ah, 01h
    int 16h
    jnz send
    jmp recieve

send:
    mov ah, 0h
    int 16h

    mov var, al
    cmp al, 0Dh
    jz newline

writing:
    setCursor sendX, sendY
    cmp sendX, 78
    jz newline
    jmp print

newline:
    scrollPageUp 1, 0, 0, 11, 79, 03h
    mov sendX, 0
    mov sendY, 0Bh
    setCursor sendX, sendY
    jmp print

print:
    mov ah, 2
    mov dl, var
    int 21h

cont:
    mov dx, 3FDH
    in  al, dx
    and al, 00100000b
    jz  recieve
    mov dx, 3F8H
    mov al, var
    out dx, al
    cmp al, 27
    jz  forexit
    saveSCursor
    cmp var, 08h
    mov ah, 2
    mov dl, ' '
    int 21h
    setCursor sendX, sendY
    jmp detect

forexit: jmp exit
forsend: jmp send

recieve:
    mov ah, 1
    int 16h
    jnz forsend

    mov dx, 3FDH
    in  al, dx
    and al, 1
    jz  recieve

    mov dx, 03F8H
    in  al, dx
    mov var, al
    cmp var, 27
    jz  exit

    cmp var, 0Dh
    jz rnewline

reading:
    setCursor recieveX, recieveY
    cmp recieveX, 78
    jz rnewline
    jmp rprint

rnewline:
    scrollPageUp 1, 12, 0, 24, 79, 030h
    mov recieveX, 0
    mov recieveY, 18h
    setCursor recieveX, recieveY
    jmp rprint

rprint:
    mov ah, 2
    mov dl, var
    int 21h

    saveRCursor
    cmp var, 08h
    mov ah, 2
    mov dl, ' '
    int 21h
    setCursor recieveX, recieveY
    jmp detect

exit:
    mov ah, 4ch
    int 21h

main endp
end main