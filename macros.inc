PrintString MACRO string
		                           lea          dx, string
		                           mov          ah, 09H
		                           int          21h
ENDM

SetCursorPos MACRO row, col
		                            mov          ah, 02H
		                            mov          bh, 0
		                            mov          dh, row
		                            mov          dl, col
		                            int          10h
ENDM

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
InitCom MACRO
    ;Set Divisor Latch Access Bit
    mov dx,3fbh 			; Line Control Register
    mov al,10000000b		;Set Divisor Latch Access Bit
    out dx,al				;Out it
    ;Set LSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f8h			
    mov al,01h			
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

DrawHeart MACRO
              mov al, 3        ; ASCII code of heart to display
              mov bx, 0        ; page 0,
              mov bl, 1100b    ; color red
              mov cx, 1        ; repetition count
              mov ah, 09h      ; config line
              int 10h          ; for writing char at cursor position
ENDM
