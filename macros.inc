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

DrawHeart MACRO
              mov al, 3        ; ASCII code of heart to display
              mov bx, 0        ; page 0,
              mov bl, 1100b    ; color red
              mov cx, 1        ; repetition count
              mov ah, 09h      ; config line
              int 10h          ; for writing char at cursor position
ENDM
