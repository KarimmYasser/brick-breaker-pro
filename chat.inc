CHAT PROC
	                       push         ax
	                       push         bx
	                       push         cx
	                       push         dx
	                       push         bp
	                       push         si
	                       push         di

	                       mov          ax , 0003h
	                       int          10h
	                       mov          ah, 0Ch
	                       int          21h                     	;clear keyboard buffer
    
	; initinalize COM
	                       initCom

	;draw the screen
	                       scrollPageUp 0Dh, 0, 0, 11, 79, 03h
	                       scrollPageUp 0Dh, 12, 0, 24, 79, 030h

	;set the cursor
	                       setCursorPos 0Bh, 0h
	;    mov          ah, 01h
	;    mov          ch, 20h
	;    int          10h

	detect:                
	                       mov          ah, 01h
	                       int          16h
	                       jnz          send
	                       jmp          recieve

	send:                  
	                       mov          ah, 0h
	                       int          16h

	                       mov          var, al
	                       cmp          al, 0Dh
	                       jz           newline

	writing:               
	                       setCursorPos sendY, sendX
	                       cmp          sendX, 78
	                       jz           newline
	                       jmp          print

	newline:               
	                       scrollPageUp 1, 0, 0, 11, 79, 03h
	                       mov          sendX, 0
	                       mov          sendY, 0Bh
	                       setCursorPos sendY, sendX
	                       jmp          print

	print:                 
	                       mov          ah, 2
	                       mov          dl, var
	                       int          21h

	cont:                  
	                       mov          dx, 3FDH
	                       in           al, dx
	                       and          al, 00100000b
	                       jz           recieve
	                       mov          dx, 3F8H
	                       mov          al, var
	                       out          dx, al
	                       cmp          al, 27
	                       jz           forexit
	                       saveSCursor
	                       cmp          var, 08h
	                       mov          ah, 2
	                       mov          dl, ' '
	                       int          21h
	                       setCursorPos sendY, sendX
	                       jmp          detect

	forexit:               jmp          returnForChat
	forsend:               jmp          send

	recieve:               
	                       mov          ah, 1
	                       int          16h
	                       jnz          forsend

	                       mov          dx, 3FDH
	                       in           al, dx
	                       and          al, 1
	                       jz           recieve

	                       mov          dx, 03F8H
	                       in           al, dx
	                       mov          var, al
	                       cmp          var, 27
	                       jz           returnForChat

	                       cmp          var, 0Dh
	                       jz           rnewline

	reading:               
	                       setCursorPos recieveY, recieveX
	                       cmp          recieveX, 78
	                       jz           rnewline
	                       jmp          rprint

	rnewline:              
	                       scrollPageUp 1, 12, 0, 24, 79, 030h
	                       mov          recieveX, 0
	                       mov          recieveY, 18h
	                       setCursorPos recieveY, recieveX
	                       jmp          rprint

	rprint:                
	                       mov          ah, 2
	                       mov          dl, var
	                       int          21h

	                       saveRCursor
	                       cmp          var, 08h
	                       mov          ah, 2
	                       mov          dl, ' '
	                       int          21h
	                       setCursorPos recieveY, recieveX
	                       jmp          detect

	returnForChat:         
	                       pop          di
	                       pop          si
	                       pop          bp
	                       pop          dx
	                       pop          cx
	                       pop          bx
	                       pop          ax
	                       ret
CHAT ENDP
	
