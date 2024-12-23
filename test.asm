.model small
.stack 100h

.data
	x               dw 11h                                                                                                 	; brick x coordinate
	y               dw 10h                                                                                                 	; brick y coordinate
	brick_width     dw 18h
	brick_height    dw 08h

	starting_x_left dw 11h, 2Ch, 47h, 62h, 7Dh, 11h, 2Ch, 47h, 62h, 7Dh, 11h, 2Ch, 47h, 62h, 7Dh, 11h, 2Ch, 47h, 62h, 7Dh  	; 20 bricks
	starting_y      dw 10h, 10h, 10h, 10h, 10h, 1Bh, 1Bh, 1Bh, 1Bh, 1Bh, 26h, 26h, 26h, 26h, 26h, 31h, 31h, 31h, 31h, 31h  	; 20 bricks
	
	bricks_no       dw 20

	bricks_level_1  dw 1, 2, 3, 0, 1, 2, 3, 0, 1, 1, 1, 2, 3, 0, 1, 2, 3, 0, 1, 1, 1, 2, 3, 0, 1, 2, 3, 0, 1, 1, 1, 2, 3, 0	; 20 bricks of level 1
	bricks_level_2  dw 20 dup(2)                                                                                           	; 20 bricks of level 2
	bricks_level_3  dw 20 dup(3)                                                                                           	; 20 bricks of level 3
	level           dw 1

	color           db 50h                                                                                                 	; 50 52 54
	


.code

main proc far
	                mov  ax, @data
	                mov  ds, ax

	; video mode
	                mov  ah, 0
	                mov  al, 13h
	                int  10h

	                call DrawBricks
	                
	                mov  ah, 4ch
	                int  21h
main endp

DrawBricks PROC
	                mov  di, 0
	                mov  cx, bricks_no

	                cmp  level, 1
	                je   level_1

	                cmp  level, 2
	                je   level_2

	                cmp  level, 3
	                je   level_3

	level_1:        
	                mov  si, offset bricks_level_1
	                jmp  draw
	level_2:        
	                mov  si, offset bricks_level_2
	                jmp  draw
	level_3:        
	                mov  si, offset bricks_level_3
	                jmp  draw
	
	drawLoop:       
	                mov  ax, [si]
	                cmp  ax, 0
	                mov  color, 00h

	                cmp  ax, 1
	                mov  color, 50h
	                je   draw

	                cmp  ax, 2
	                mov  color, 54h
	                je   draw

	                cmp  ax, 3
	                mov  color, 56h
	                je   draw

	draw:           
	                mov  ax, starting_x_left[di]
	                mov  x, ax
	                mov  ax, starting_y[di]
	                mov  y, ax
	                push cx
	                call DrawBrick
	                pop  cx

	                add  si, 2
	                add  di, 2
	                loop drawLoop

	                RET
DrawBricks ENDP

	; needs in 'x' the start x coordinate and in 'y' the start y coordinate and in 'color' the color of the brick
DrawBrick PROC
	                mov  cx, x                    	; init x coordinate
	                mov  dx, y                    	; init y coordinate

	move_horizontal:
	                mov  ah, 0Ch                  	; set the config to draw a pixel
	                mov  al, color
	                mov  bh, 00h                  	; page number
	                int  10h
	                inc  cx

	                mov  ax, cx
	                sub  ax, x
	                cmp  ax, brick_width          	; (Y) exit horizontal check
	                jng  move_horizontal

	                mov  cx, x                    	; reset for next line
	                inc  dx

	                mov  ax, dx
	                sub  ax, y
	                cmp  ax, brick_height         	; (Y) exit vertical check
	                jng  move_horizontal

	                RET
DrawBrick ENDP

end main
