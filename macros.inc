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