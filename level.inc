level_select proc
	                       mov          ah, 0
	                       mov          al, 13h               	;320x200
	                       int          10h
	                       call         boarder

	                       mov          AH, 0Ch               	; Clear Buffer
	                       int          21h
	                       SetCursorPos 4, 7

	                       lea          dx,levelnum_string
	                       mov          ah,09h
	                       int          21h

	                       mov          AH, 0Ch               	; Clear Buffer
	                       int          21h

	                       SetCursorPos 12, 6

	                       lea          dx,level_string
	                       mov          ah,09h
	                       int          21h

	                       mov          AH, 0Ch               	;Clear Buffer
	                       int          21h

	                       SetCursorPos 14, 7

	                       lea          dx,levelnum_string
	                       mov          ah,09h
	                       int          21h

	                       mov          AH, 0Ch               	;Clear Buffer
	                       int          21h


	                       mov          rectcolour, 59h
	                       mov          rectwidth, 40
	                       mov          rectheight, 26

	                       mov          rect_x, 48
	                       mov          rect_y, 46
	                       call         DrawRectangle
				   
	                       mov          rectcolour,54h
	                       mov          rect_x,136
	                       call         DrawRectangle
				   
	                       mov          rectcolour,50h
	                       mov          rect_x,217
	                       call         DrawRectangle
	again_and_again:       
	                       mov          AH, 0Ch               	;Clear Buffer
	                       int          21h
	                       call         delay
	                       mov          ah, 1
	                       int          16h
	                       mov          bx,ax
	                       jnz          ignorerecieve
	                       mov          dx, 3FDH
	                       in           al, dx
	                       and          al, 1
	                       jz           again_and_again
	                       mov          dx, 03F8H
	                       in           al, dx
	                       mov          bl, al
	                       mov          bh, 0
	                       jmp          recievecmp
	ignorerecieve:         
	                       mov          dx, 03F8H
	                       mov          al, bl
	                       out          dx, al

	recievecmp:            
	                       cmp          bl, '1'
	                       je           set_level_1
	                       cmp          bl, '2'
	                       je           set_level_2
	                       cmp          bl, '3'
	                       je           set_level_3
	                       cmp          bl, 13
	                       je           gostartmenu
	                       cmp          bl, 8
	                       je           gostartmenu
	                       cmp          bl, 27
	                       je           gostartmenu
	                       jmp          again_and_again

	set_level_1:           
	                       mov          Level_Selector, 1
	                       ret

	set_level_2:           
	                       mov          Level_Selector, 2
	                       ret

	set_level_3:           
	                       mov          Level_Selector, 3
	                       ret
						   
	gostartmenu:           jmp          startmenu
level_select endp