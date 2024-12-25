DrawScreen PROC
	;call         CheckBox
	                       mov          rectcolour, 0         	;draw ball black
	                       call         drawball
	                       call         drawballRight
	                       call         MoveBall
	                       call         MoveBallRight
	                       call         CheckBallWallCollision
	                       call         CheckBallWallCollisionRight
	                       mov          rectcolour, 15
	                       call         drawball
	                       call         drawballRight
	;call         BallBoxCollision
	                       cmp          Level_Selector, 1
	                       je           level1
	                       cmp          Level_Selector, 2
	                       je           level2
	                       cmp          Level_Selector, 3
	                       je           level3
	level1:                
	                       mov          level_paddle_x, 30
	                       mov          level_padhalfx, 15
	                       call         BallPaddleCollision
	                       call         BallPaddleCollisionRight
	                       mov          rectwidth, 30
	                       mov          rectcolour, 15
	                       call         DrawPaddle
						   call 	    DrawPaddleRightBlack
	                       call         DrawPaddleRight
	                       jmp          NoBoxS


	level2:                
	                       mov          level_paddle_x, 20
	                       mov          level_padhalfx, 10
	                       call         BallPaddleCollision
	                       mov          rectwidth, 20
	                       mov          rectcolour, 15
	                       call         DrawPaddle
						   call 	    DrawPaddleRightBlack
	                       call         DrawPaddleRight
	                       jmp          NoBoxS
	level3:                
	                       mov          level_paddle_x, 20
	                       mov          level_padhalfx, 10
	                       call         BallPaddleCollision
	                       mov          rectwidth, 20
	                       mov          rectcolour, 15
	                       call         DrawPaddle
						   call 	    DrawPaddleRightBlack
	                       call         DrawPaddleRight
	;call         BallBoxFCollision
	;call         DrawBoxF
	                       cmp          bool_boxS, 1
	                       jne          NoBoxS
	;call         DrawBoxS
	;call         BallBoxSCollision
	NoBoxS:                
	                       call         DrawAllBricks
	                       call         DrawAllBricksRight
	;call         DrawBox
	;call         DrawBoarder
	                       ret
DrawScreen ENDP

winscreen proc
	                       mov          ah, 0
	                       mov          al, 13h                 	;320x200
	                       int          10h
	
	                       call         boarder
	
	
	                       SetCursorPos 3, 7
	
	                       lea          dx, winScreenStr
	                       mov          ah, 09h
	                       int          21h
	
	loppypart2:            
	                       mov          ax, 0
	                       mov          bx, 0
	                       mov          cx, 0
	                       mov          dx, 0
	                       mov          AH, 0Ch                 	;Clear Buffer
	                       int          21h
	
	                       SetCursorPos 22,4
	
	                       lea          dx, credits
	                       mov          ah, 09h
	                       int          21h
	
	
	
	                       SetCursorPos 6,8
	
	                       lea          dx, winContinue
	                       mov          ah, 09h
	                       int          21h
	
	
	                       SetCursorPos 8,8
	                       
	                       lea          dx, enterContinue
	                       mov          ah, 09h
	                       int          21h
	
	
	                       SetCursorPos 10,8
	
	                       lea          dx, nToQuit
	                       mov          ah, 09h
	                       int          21h
	loppypart01:           
	                       mov          ax, 0
	                       mov          bx, 0
	                       mov          cx, 0
	                       mov          dx, 0
	                       mov          AH, 0Ch                 	;Clear Buffer
	
	
	
	                       int          21h
	
	                       call         delay
	
	                       mov          ah, 0
	                       int          16h
	                       mov          bx, ax
	                       cmp          bl, 'n'
	                       je           exitHelp
	                       cmp          bl, 0Dh
	                       je           startmenuHelp
	                       jnz          loppypart2
	                       ret
	;--------------------------------------------
	exitHelp:              jmp          exit
	startmenuHelp:         jmp          startmenu
	;-------------------------------------------

winscreen endp

gameBoarder proc
	                       mov          rectcolour, 3
	                       mov          rectwidth, 320
	                       mov          rectheight, 200
	                       mov          rect_x, 0
	                       mov          rect_y, 0
	                       call         DrawRectangle

	                       mov          rectcolour, 0
	                       mov          rectwidth, 145
	                       mov          rectheight, 180
	                       mov          rect_x, 10
	                       mov          rect_y, 10
	                       call         DrawRectangle

	                       mov          rectcolour, 0
	                       mov          rectwidth, 145
	                       mov          rectheight, 180
	                       mov          rect_x, 165
	                       mov          rect_y, 10
	                       call         DrawRectangle

	                       ret
gameBoarder endp