DrawRectangle PROC
	
	                       push         cx
	
	                       mov          Al, rectcolour
	                       mov          CX, rect_x
	                       dec          cx                      	; 0 based
	                       add          CX, rectwidth
	                       mov          DX, rect_y
	                       add          DX, rectheight
	looprectvertical:      
	looprecthorizontal:    
	                       mov          ah, 0Ch
	                       int          10h
	                       dec          cx
	                       cmp          CX, rect_x
	                       jge          looprectvertical
	                       add          CX, rectwidth
	                       dec          dx
	                       cmp          DX, rect_y
	                       jge          looprecthorizontal
	
	
	                       pop          cx
	                       ret
DrawRectangle ENDP

drawball proc
	                       mov          ax, ball_size
	                       mov          rectwidth, ax
	                       mov          rectheight, ax

	                       mov          ax, ball_x
	                       mov          rect_x, ax
	                       mov          ax, ball_y
	                       mov          rect_y, ax
	                       call         DrawRectangle

	                       sub          rectwidth, 2
	                       add          rectheight, 2
	                       add          rect_x, 1
	                       sub          rect_y, 1
	                       call         DrawRectangle

	                       add          rectwidth, 4
	                       sub          rectheight, 4
	                       sub          rect_x, 2
	                       add          rect_y, 2
	                       call         DrawRectangle

	                       ret
drawball endp
drawballRight proc
	                       mov          ax, ball_size
	                       mov          rectwidth, ax
	                       mov          rectheight, ax

	                       mov          ax, ball_x_right
	                       mov          rect_x, ax
	                       mov          ax, ball_y_right
	                       mov          rect_y, ax
	                       call         DrawRectangle

	                       sub          rectwidth, 2
	                       add          rectheight, 2
	                       add          rect_x, 1
	                       sub          rect_y, 1
	                       call         DrawRectangle

	                       add          rectwidth, 4
	                       sub          rectheight, 4
	                       sub          rect_x, 2
	                       add          rect_y, 2
	                       call         DrawRectangle

	                       ret
drawballRight endp

DrawPaddle PROC
	                       mov          rectheight, 10
					   
	                       mov          si, Paddle_x
	                       mov          rect_x, si
	                       mov          si, Paddle_y
	                       mov          rect_y, si
	                       call         DrawRectangle
	                       
	;mov          rectcolour, 15
	;    sub          rectwidth, 4
	;    mov          si, Paddle_x
	;    add          si, 2
	;    mov          rect_x, si
	;    mov          si, Paddle_y
	;    mov          rect_y, si
	;    call         DrawRectangle
	;    add          rectwidth, 4
					   
	                       ret
DrawPaddle ENDP
DrawPaddleBlack PROC
						   mov          rectcolour, 0
	                       mov          rectheight, 10
					   
	                       mov          si, oldPaddle_x
	                       mov          rect_x, si
	                       mov          si, oldPaddle_y
	                       mov          rect_y, si
	                       call         DrawRectangle
	                       
	;mov          rectcolour, 15
	;    sub          rectwidth, 4
	;    mov          si, Paddle_x
	;    add          si, 2
	;    mov          rect_x, si
	;    mov          si, Paddle_y
	;    mov          rect_y, si
	;    call         DrawRectangle
	;    add          rectwidth, 4
					   
	                       ret
DrawPaddleBlack ENDP

DrawPaddleRight PROC
						   mov          rectcolour, 15
	                       mov          rectheight, 10
					   
	                       mov          si, Paddle_x_right
	                       mov          rect_x, si
	                       mov          si, Paddle_y_right
	                       mov          rect_y, si
	                       call         DrawRectangle
	                       
	;mov          rectcolour, 15
	;    sub          rectwidth, 4
	;    mov          si, Paddle_x
	;    add          si, 2
	;    mov          rect_x, si
	;    mov          si, Paddle_y
	;    mov          rect_y, si
	;    call         DrawRectangle
	;    add          rectwidth, 4
					   
	                       ret
DrawPaddleRight ENDP

DrawPaddleRightBlack PROC
						   mov          rectcolour, 0
	                       mov          rectheight, 10
					   
	                       mov          si, paddle_x_old
	                       mov          rect_x, si
	                       mov          si, Paddle_y_right
	                       mov          rect_y, si
	                       call         DrawRectangle
	                       ret
DrawPaddleRightBlack ENDP

DrawDivider proc
	                       mov          rectcolour, 3           	; cyan color
	                       mov          rectwidth, 2
	                       mov          rectheight, 170
	                       mov          rect_x, 159             	; centered
	                       mov          rect_y, 10
	                       call         DrawRectangle
	                       ret
DrawDivider endp
DrawHearts PROC
	; Check if CurrentLives > 2 (for third heart)
	                       mov          ax, CurrentLives
	                       cmp          ax, 3
	                       jb           skip_third_heart        	; If CurrentLives < 3, skip drawing the third heart

	draw_third_heart:      
	                       SetCursorPos 4 HeartColumn
	                       DrawHeart

	skip_third_heart:      

	; Check if CurrentLives > 1 (for second heart)
	                       mov          ax, CurrentLives
	                       cmp          ax, 2
	                       jb           skip_second_heart       	; If CurrentLives < 2, skip drawing the second heart

	draw_second_heart:     
	                       SetCursorPos 3 HeartColumn
	                       DrawHeart

	skip_second_heart:     
	; Check if CurrentLives > 0 (for first heart)
	                       mov          ax, CurrentLives
	                       cmp          ax, 1
	                       jb           skip_first_heart        	; If CurrentLives < 1, skip drawing the first heart

	draw_first_heart:      
	                       SetCursorPos 2 HeartColumn
	                       DrawHeart

	skip_first_heart:      
	                       ret
DrawHearts ENDP
DrawBorderStrings proc
	; Save the registers
	                       push         ax
	                       push         bx
	                       push         cx
	                       push         dx
	                       push         bp
	                       push         si
	                       push         di

	                       SetCursorPos 23 2
	                       PrintString  ScoreName

	                       SetCursorPos 24 2
	                       PrintString  LevelName

	                       SetCursorPos 23 20
	                       PrintString  ScoreName
	                       SetCursorPos 24 20
	                       PrintString  LevelName

	                       pop          di
	                       pop          si
	                       pop          bp
	                       pop          dx
	                       pop          cx
	                       pop          bx
	                       pop          ax
	                       ret
DrawBorderStrings ENDP

DrawAllBricks PROC
	                       mov          di, 0
	                       mov          cx, bricks_no
	                       mov          si, offset Bool_Box
	
	drawLoop:              
	                       mov          ax, [si]
	                       cmp          ax, 0
	                       mov          color, 00h

	                       cmp          ax, 1
	                       mov          color, 59h
	                       je           draw

	                       cmp          ax, 2
	                       mov          color, 54h
	                       je           draw

	                       cmp          ax, 3
	                       mov          color, 50h
	                       je           draw

	draw:                  
	                       mov          ax, starting_x_left[di]
	                       mov          x, ax
	                       mov          ax, starting_y[di]
	                       mov          y, ax
	                       push         cx
	                       call         DrawBrick
	                       pop          cx

	                       add          si, 2
	                       add          di, 2
	                       loop         drawLoop

	                       RET
DrawAllBricks ENDP
DrawAllBricksRight PROC
	                       mov          di, 0
	                       mov          cx, bricks_no
	                       mov          si, offset Bool_Box_left
	
	drawLoopRight:         
	                       mov          ax, [si]
	                       cmp          ax, 0
	                       mov          color, 00h

	                       cmp          ax, 1
	                       mov          color, 59h
	                       je           drawRight

	                       cmp          ax, 2
	                       mov          color, 54h
	                       je           drawRight

	                       cmp          ax, 3
	                       mov          color, 50h
	                       je           drawRight

	drawRight:             
	                       mov          ax, starting_x_right[di]
	                       mov          x, ax
	                       mov          ax, starting_y[di]
	                       mov          y, ax
	                       push         cx
	                       call         DrawBrick
	                       pop          cx

	                       add          si, 2
	                       add          di, 2
	                       loop         drawLoopRight

	                       RET
DrawAllBricksRight ENDP

	; needs in 'x' the start x coordinate and in 'y' the start y coordinate and in 'color' the color of the brick
DrawBrick PROC
	                       mov          cx, x                   	; init x coordinate
	                       mov          dx, y                   	; init y coordinate

	move_horizontal:       
	                       mov          ah, 0Ch                 	; set the config to draw a pixel
	                       mov          al, color
	                       mov          bh, 00h                 	; page number
	                       int          10h
	                       inc          cx

	                       mov          ax, cx
	                       sub          ax, x
	                       cmp          ax, brick_width         	; (Y) exit horizontal check
	                       jng          move_horizontal

	                       mov          cx, x                   	; reset for next line
	                       inc          dx

	                       mov          ax, dx
	                       sub          ax, y
	                       cmp          ax, brick_height        	; (Y) exit vertical check
	                       jng          move_horizontal

	                       RET
DrawBrick ENDP

boarder proc
	                       mov          rectcolour, 3
	                       mov          rectwidth, 320
	                       mov          rectheight, 200
	                       mov          rect_x, 0
	                       mov          rect_y, 0
	                       call         DrawRectangle
	
	                       mov          rectcolour, 0
	                       mov          rectwidth, 300        	; 320 - 10 - 10
	                       mov          rectheight, 180       	; 200 - 10 - 10
	                       mov          rect_x, 10
	                       mov          rect_y, 10
	                       call         DrawRectangle
	                       ret
boarder endp


DrawLevelBorder proc far
	; Draws the outer black border
	                       mov          rectcolour, 0         	; black color
	                       mov          rectwidth, 320        	; whole width
	                       mov          rectheight, 200       	; whole height
	                       mov          rect_x, 0
	                       mov          rect_y, 0
	                       call         DrawRectangle

	; Draw the outer cyan border
	                       mov          rectcolour, 3         	; cyan color
	                       mov          rectwidth, 300
	                       mov          rectheight, 170
	                       mov          rect_x, 10
	                       mov          rect_y, 10
	                       call         DrawRectangle

	; Draw the black inner game rectangle
	                       mov          rectcolour, 0         	; black color
	                       mov          rectwidth, 290
	                       mov          rectheight, 160
	                       mov          rect_x, 15
	                       mov          rect_y, 15
	                       call         DrawRectangle

	; draw hearts for both players
	                       mov          ax, playerOneLives
	                       mov          CurrentLives, ax
	                       mov          HeartColumn, 0
	                       call         DrawHearts

	                       mov          ax, playerTwoLives
	                       mov          CurrentLives, ax
	                       mov          HeartColumn, 79
                      
	                       call         DrawHearts
                       
	; draw score and level
	                       call         DrawBorderStrings
	                       call         DrawDivider
	                       ret
DrawLevelBorder endp
