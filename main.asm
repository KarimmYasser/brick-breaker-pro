.MODEL SMALL
.STACK 100h
include     macros.inc      ; general macros
	
.DATA
	rect_x            dw  0
	rect_y            dw  0
	rectwidth         dw  0
	rectheight        dw  0
	rectcolour        db  0

	playerOneLives    dw  3
	playerTwoLives    dw  3
	playerOneScore    db  0
	playerTwoScore    db  0

	ball_x            dw  100
	ball_y            dw  100d
	ball_size         dw  6

	VertBall          dw  0                            	; the direction of the ball in the vertical direction
	HorzBall          dw  0                            	; the direction of the ball in the horizontal direction
	
	;-------------- For Chat
	var               db  ?
	sendX             db  0
	sendY             db  0Bh
	recieveX          db  0
	recieveY          db  18h
	;-----------------------
	HeartColumn       db  0
	buffer            db  100 dup('$')
	ScoreName         db  "Score: $"
	LevelName         db  "Level: $"

	Paddle_x          dw  50                           	; start x position for paddle
	Paddle_y          dw  160                          	; start y position for paddle
	paddle_x_half     dw  0

	level_paddle_x    dw  30                           	; paddle width - changes according to level chosen
	level_padhalfx    dw  15

	paddleSpeed       equ 7
	
	ScoreCounter      db  0
	CurrentLives      dw  3
	Level_Selector    dw  1

	start_menu_option db  1
	string_start_game db  'START GAME$'
	string_chat       db  'CHAT$'
	string_exit_game  db  'EXIT GAME$'
	one               db  '1)$'
	two               db  '2)$'
	three             db  '3)$'
	levelnum_string   db  '(1)        (2)       (3)$'
	level_string      db  'LEVEL      LEVEL     LEVEL$'


	;----------------------- bricks data
	x                 dw  11h                          	; brick x coordinate
	y                 dw  10h                          	; brick y coordinate
	brick_width       dw  18h
	brick_height      dw  08h

	starting_x_left   dw  2Ch, 47h, 62h
	; 7Dh, 11h, 2Ch, 47h, 62h, 7Dh, 11h, 2Ch, 47h, 62h, 7Dh, 11h, 2Ch, 47h, 62h, 7Dh	; 20 bricks

	; 17, 44, 71, 98, 125 (3 pixels gap)
	
	starting_y        dw  26h, 26h, 26h
	;  1Bh, 1Bh, 1Bh, 1Bh, 1Bh, 26h, 26h, 26h, 26h, 26h, 31h, 31h, 31h, 31h, 31h	; 20 bricks
	
	bricks_no         dw  3
	color             db  50h
	colors            db  59h, 56h, 50h                	; init value
	
	bool_boxs         dw  1
	BoxesExist        dw  1
	Bool_Box          dw  20 dup(1)
	brickExists       dw  1                            	; boolean to move the value of function checkBrickExists
	
.CODE

BoxCreator PROC
	                        mov          cx, bricks_no
	                        mov          si, offset Bool_Box
	
	                        mov          BoxesExist, 1
	                        mov          ax, Level_Selector
	
	loopBC:                 
	
	                        mov          [si], ax
	
	                        add          si, 2
	
	                        loop         loopBC
	
	                        ret
BoxCreator ENDP
moveLeft proc
	                        mov          ax, level_paddle_x
	                        mov          rectwidth, ax
	                        mov          rectcolour, 0
	                        call         WAIT_FOR_VSYNC
	                        call         DrawPaddle
	                        cmp          Paddle_x, 22              	; left border boundary + speed
	                        jle          endleft
	                        sub          Paddle_x, paddleSpeed
	                        ret
	endleft:                
	                        mov          Paddle_x, 15              	; left border boundary
	                        ret
moveLeft endp

moveRight proc
	                        mov          rectcolour, 0
	                        mov          ax, level_paddle_x
	                        mov          rectwidth, ax
	                        call         WAIT_FOR_VSYNC
	                        call         DrawPaddle
	                        mov          ax, Paddle_x
	                        add          ax, level_paddle_x
	                        cmp          ax, 151                   	; right border boundary - speed
	                        jge          endright
	                        add          Paddle_x, paddleSpeed
	                        ret
	endright:               
	                        mov          ax, 159                   	; right border boundary
	                        sub          ax, level_paddle_x
	                        mov          Paddle_x, ax
	                        ret
moveRight endp

WAIT_FOR_VSYNC PROC NEAR
	                        push         ax
	                        push         dx
	                        mov          dx, 3DAh                  	; VGA status port
	vsync_wait1:            
	                        in           al, dx
	                        test         al, 8                     	; Check vertical retrace
	                        jnz          vsync_wait1               	; Wait if already in retrace
	vsync_wait2:            
	                        in           al, dx
	                        test         al, 8                     	; Wait for vertical retrace
	                        jz           vsync_wait2
	                        pop          dx
	                        pop          ax
	                        ret
WAIT_FOR_VSYNC ENDP

DrawRectangle PROC
	
	                        push         cx
	
	                        mov          Al, rectcolour
	                        mov          CX, rect_x
	                        dec          cx                        	; 0 based
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

boarder proc
	                        mov          rectcolour, 3
	                        mov          rectwidth, 320
	                        mov          rectheight, 200
	                        mov          rect_x, 0
	                        mov          rect_y, 0
	                        call         DrawRectangle
	
	                        mov          rectcolour, 0
	                        mov          rectwidth, 300            	; 320 - 10 - 10
	                        mov          rectheight, 180           	; 200 - 10 - 10
	                        mov          rect_x, 10
	                        mov          rect_y, 10
	                        call         DrawRectangle
	                        ret
boarder endp

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

delay proc
	                        push         ax
	                        push         bx
	                        push         cx
	                        push         dx

	                        mov          cx, 11000

	                        mov          ax, Level_Selector
	                        cmp          ax, 1
	                        je           level1d
	                        cmp          ax, 2
	                        je           level2d
	                        cmp          ax, 3
	                        je           level3d
	                        jmp          end_set_delay

	level1d:                
	                        mov          bx, 15
	                        jmp          end_set_delay

	level2d:                
	                        mov          bx, 10
	                        jmp          end_set_delay

	level3d:                
	                        mov          bx, 5

	end_set_delay:          

	mydelay:                
	                        push         cx
	                        mov          cx, bx
	mydelay1:               
	                        dec          cx
	                        jnz          mydelay1
	                        pop          cx
	                        loop         mydelay

	                        pop          dx
	                        pop          cx
	                        pop          bx
	                        pop          ax

	                        ret
delay ENDP

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

DrawPaddle PROC
	;mov rectcolour, 15
	;mov rectwidth, 50
	                        mov          rectheight, 10
					   
	                        mov          si, Paddle_x
	                        mov          rect_x, si
	                        mov          si, Paddle_y
	                        mov          rect_y, si
	                        call         DrawRectangle
					   
	                        ret
DrawPaddle ENDP
MoveBall proc
	                        push         ax
	                        push         bx
	                        push         cx
	                        push         dx
	                        mov          ax, ball_x
	                        mov          bx, ball_y
	                        mov          cx, VertBall
	                        mov          dx, HorzBall

	                        cmp          dx, 1
	                        je           MoveRightBall

	MoveLeftBall:           
	                        cmp          ax, 21
	                        jl           ExactLeft
	                        sub          ax, 5
	                        mov          ball_x, ax
	                        jmp          VertCompare
	ExactLeft:              
	                        mov          ax, 16
	                        mov          ball_x, ax
	                        jmp          VertCompare
	MoveRightBall:          
	                        cmp          ax, 148
	                        jg           ExactRight
	                        add          ax, 4
	                        mov          ball_x, ax
	                        jmp          VertCompare
	ExactRight:             
	                        mov          ax, 152
	                        mov          ball_x, ax
	VertCompare:            
	                        cmp          cx, 0
	                        je           MoveDownBall
	MoveUpBall:             
	                        cmp          bx, 21
	                        jl           ExactUp
	                        sub          bx, 5
	                        mov          ball_y, bx
	                        jmp          EndMoveBall
	ExactUp:                
	                        mov          bx, 16
	                        mov          ball_y, bx
	                        jmp          EndMoveBall
	MoveDownBall:           
	                        add          bx, 5
	                        mov          ball_y, bx
	EndMoveBall:            
	                        pop          dx
	                        pop          cx
	                        pop          bx
	                        pop          ax
	                        ret
MoveBall endp
BallPaddleCollision proc
	                        push         CX
	                        push         DX

	                        mov          ax, Paddle_x
	                        mov          bx, Paddle_y
	                        sub          bx, 10

	                        cmp          ball_x, ax
	                        jl           NoCollision

	                        add          ax, level_paddle_x
	                        mov          paddle_x_half, ax
	                        mov          dx,	level_padhalfx
	                        sub          paddle_x_half, dx
	                        mov          cx, paddle_x_half

	                        cmp          ball_x, ax
	                        jg           NoCollision
	                        cmp          ball_x, cx
	                        jl           skipFirstHalf
	                        cmp          ball_y, bx
	                        jl           NoCollision

	                        add          bx, 10

	                        cmp          ball_y, bx
	                        jg           NoCollision

	                        mov          VertBall, 1
	                        mov          HorzBall, 1
	                        jmp          NoCollision

	skipFirstHalf:          
	                        cmp          ball_x, cx
	                        jg           NoCollision
	                        sub          cx, level_padhalfx
	                        cmp          ball_x, cx
	                        jl           NoCollision
	                        cmp          ball_y, bx
	                        jl           NoCollision

	                        add          bx, 16

	                        cmp          ball_y, bx
	                        jg           NoCollision

	                        mov          VertBall, 1
	                        mov          HorzBall, 0

	NoCollision:            
	                        pop          DX
	                        pop          CX
	                        ret
BallPaddleCollision endp
draw_start_menu proc
	                        SetCursorPos 6, 16
	                        PrintString  string_start_game
	                        SetCursorPos 6, 12
	                        PrintString  one
	                        SetCursorPos 12, 16
	                        PrintString  string_chat
	                        SetCursorPos 12, 12
	                        PrintString  two
	                        SetCursorPos 18, 16
	                        PrintString  string_exit_game
	                        SetCursorPos 18, 12
	                        PrintString  three
	                        ret
draw_start_menu endp
start_menu proc
	ToMenu:                 
	                        mov          ah, 0h
	                        mov          al, 13h                   	;320x200
	                        int          10h

	                        call         boarder
	                        call         draw_start_menu
	                        mov          rectcolour,15             	;ball colour
	                        mov          start_menu_option, 1
	                        mov          ball_x, 84
	                        mov          ball_y, 48
	                        call         drawball                  	;draw on selected option
	                        xor          ax, ax
	                        xor          bx, bx
	                        xor          cx, cx
	                        xor          dx, dx
	kbloop:                 
	                        mov          ah, 0Ch
	                        int          21h                       	;clear keyboard buffer
	                        call         delay

	                        mov          ah, 1
	                        int          16h
	                        mov          bx, ax
	                        jz           kbloop
	                        cmp          bh, 48h
	                        je           moveup
	                        cmp          bh, 50h
	                        je           movedown
	                        cmp          bl, 13
	                        jne          nxtcmp1
	                        jmp          select
	nxtcmp1:                
	                        cmp          bl,'1'
	                        jne          nxtcmp2
	                        jmp          stgm
	nxtcmp2:                
	                        cmp          bl,'2'
	                        jne          nxtcmp3
	                        jmp          chatting
	nxtcmp3:                
	                        cmp          bl,'3'
	                        jne          nxtcmp4
	                        jmp          exit
	nxtcmp4:                
	                        cmp          bl, 27
	                        je           weexit
	                        jmp          kbloop
	;-------------------------------------------
	weexit:                 jmp          exit
	;-------------------------------------------
	moveup:                 
	                        mov          rectcolour, 0             	; erase ball
	                        call         drawball
	                        dec          start_menu_option
	                        cmp          start_menu_option, 0
	                        jg           calcOption
	                        mov          start_menu_option, 1
	                        jmp          calcOption

	movedown:               
	                        mov          rectcolour, 0             	; erase ball
	                        call         drawball
	                        inc          start_menu_option
	                        cmp          start_menu_option, 4
	                        jl           calcOption
	                        mov          start_menu_option, 3
	                        jmp          calcOption
	calcOption:             
	                        cmp          start_menu_option, 2
	                        je           option2
	                        cmp          start_menu_option, 3
	                        je           option3
	                        mov          ball_x, 84
	                        mov          ball_y, 48
	                        mov          rectcolour, 15
	                        call         drawball
	                        jmp          kbloop
	option2:                
	                        mov          ball_x, 84
	                        mov          ball_y, 96
	                        mov          rectcolour, 15
	                        call         drawball
	                        jmp          kbloop
	option3:                
	                        mov          ball_x, 84
	                        mov          ball_y, 144
	                        mov          rectcolour, 15
	                        call         drawball
	                        jmp          kbloop
	select:                 
	                        cmp          start_menu_option, 1
	                        je           stgm
	                        cmp          start_menu_option, 2
	                        je           chatting
	                        jmp          exit
	chatting:               
	exit:                   
	                        SetCursorPos 18, 1
	                        mov          ah, 4Ch
	                        int          21h                       	;exit
	stgm:                   
	                        ret
start_menu endp
DrawLevelBorder proc far
	; Draws the outer black border
	                        mov          rectcolour, 0             	; black color
	                        mov          rectwidth, 320            	; whole width
	                        mov          rectheight, 200           	; whole height
	                        mov          rect_x, 0
	                        mov          rect_y, 0
	                        call         DrawRectangle

	; Draw the outer cyan border
	                        mov          rectcolour, 3             	; cyan color
	                        mov          rectwidth, 300
	                        mov          rectheight, 170
	                        mov          rect_x, 10
	                        mov          rect_y, 10
	                        call         DrawRectangle

	; Draw the black inner game rectangle
	                        mov          rectcolour, 0             	; black color
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

DrawDivider proc
	                        mov          rectcolour, 3             	; cyan color
	                        mov          rectwidth, 2
	                        mov          rectheight, 170
	                        mov          rect_x, 159               	; centered
	                        mov          rect_y, 10
	                        call         DrawRectangle
	                        ret
DrawDivider endp
DrawHearts PROC
	; Check if CurrentLives > 2 (for third heart)
	                        mov          ax, CurrentLives
	                        cmp          ax, 3
	                        jb           skip_third_heart          	; If CurrentLives < 3, skip drawing the third heart

	draw_third_heart:       
	                        SetCursorPos 4 HeartColumn
	                        DrawHeart

	skip_third_heart:       

	; Check if CurrentLives > 1 (for second heart)
	                        mov          ax, CurrentLives
	                        cmp          ax, 2
	                        jb           skip_second_heart         	; If CurrentLives < 2, skip drawing the second heart

	draw_second_heart:      
	                        SetCursorPos 3 HeartColumn
	                        DrawHeart

	skip_second_heart:      
	; Check if CurrentLives > 0 (for first heart)
	                        mov          ax, CurrentLives
	                        cmp          ax, 1
	                        jb           skip_first_heart          	; If CurrentLives < 1, skip drawing the first heart

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
	                        je           draw

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

	; needs in 'x' the start x coordinate and in 'y' the start y coordinate and in 'color' the color of the brick
DrawBrick PROC
	                        mov          cx, x                     	; init x coordinate
	                        mov          dx, y                     	; init y coordinate

	move_horizontal:        
	                        mov          ah, 0Ch                   	; set the config to draw a pixel
	                        mov          al, color
	                        mov          bh, 00h                   	; page number
	                        int          10h
	                        inc          cx

	                        mov          ax, cx
	                        sub          ax, x
	                        cmp          ax, brick_width           	; (Y) exit horizontal check
	                        jng          move_horizontal

	                        mov          cx, x                     	; reset for next line
	                        inc          dx

	                        mov          ax, dx
	                        sub          ax, y
	                        cmp          ax, brick_height          	; (Y) exit vertical check
	                        jng          move_horizontal

	                        RET
DrawBrick ENDP

level_select proc
	                        mov          ah, 0
	                        mov          al, 13h                   	;320x200
	                        int          10h
	                        call         boarder

	                        mov          AH, 0Ch                   	; Clear Buffer
	                        int          21h
	                        SetCursorPos 4, 7

	                        lea          dx, levelnum_string
	                        mov          ah,09h
	                        int          21h

	                        mov          AH, 0Ch                   	; Clear Buffer
	                        int          21h

	                        SetCursorPos 12, 6

	                        lea          dx, level_string
	                        mov          ah,09h
	                        int          21h

	                        mov          AH, 0Ch                   	;Clear Buffer
	                        int          21h

	                        SetCursorPos 14, 7

	                        lea          dx,levelnum_string
	                        mov          ah,09h
	                        int          21h

	                        mov          AH, 0Ch                   	;Clear Buffer
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
	                        mov          AH, 0Ch                   	;Clear Buffer
	                        int          21h
	                        call         delay
	                        mov          ah, 1
	                        int          16h
	                        mov          bx,ax
	                        jz           again_and_again
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

	set_level_1:            
	                        mov          Level_Selector, 1
	                        ret

	set_level_2:            
	                        mov          Level_Selector, 2
	                        ret

	set_level_3:            
	                        mov          Level_Selector, 3
	                        ret
						   
level_select endp
	gostartmenu:            jmp          startmenu
DrawScreen PROC
	;call         CheckBox
	                        call         DrawAllBricks
	                        mov          rectcolour, 0             	;draw ball black
	                        call         drawball
	                        call         MoveBall
	                        call         CheckBallWallCollision
	                        call         CheckBallBrickCollision
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
	                        mov          rectwidth, 30
	                        mov          rectcolour, 15
	                        call         DrawPaddle
	                        jmp          NoBoxS


	level2:                 
	                        mov          level_paddle_x, 20
	                        mov          level_padhalfx, 10
	                        call         BallPaddleCollision
	                        mov          rectwidth, 20
	                        mov          rectcolour, 15
	                        call         DrawPaddle
	                        jmp          NoBoxS
	level3:                 
	                        mov          level_paddle_x, 20
	                        mov          level_padhalfx, 10
	                        call         BallPaddleCollision
	                        mov          rectwidth, 20
	                        mov          rectcolour, 15
	                        call         DrawPaddle
	;call         BallBoxFCollision
	;call         DrawBoxF
	                        cmp          bool_boxS, 1
	                        jne          NoBoxS
	;call         DrawBoxS
	;call         BallBoxSCollision
	NoBoxS:                 
	                        mov          rectcolour, 15
	                        call         drawball
	;call         DrawBox
	;call         DrawBoarder
	                        ret
DrawScreen ENDP

CheckBallWallCollision proc

	; Check collision with left boundary
	check_left_bound:       
	                        cmp          ball_x, 17                	; game border starts at 15
	                        jg           check_right_bound         	; if greater than continue checking on the rest of boundaries
	                        mov          HorzBall,1                	; reverse the direction to move right
	
	; Check collision with right boundary
	check_right_bound:      
	                        mov          ax, 158                   	; divider line is the right boundary for game border
	                        sub          ax, ball_size
	                        cmp          ball_x, ax
	                        jl           check_upper_bound
	                        mov          HorzBall,0                	; reverse the direction to move left

	; Check collision with top boundary
	check_upper_bound:      
	                        cmp          ball_y, 16                	; game border starts at 15
	                        jg           check_lower_bound
	                        mov          VertBall,0                	; reverse direction to move down
	; Check collision with bottom boundary
	check_lower_bound:      
	                        mov          ax, 168                   	; game border lower bound height - ball size
	                        sub          ax, ball_size
	                        cmp          ball_y, ax
	                        jl           end_check
	                        mov          VertBall,1                	; reverse direction to move up
	end_check:              
	                        ret
	
CheckBallWallCollision endp

CheckBallBrickCollision proc
	; init lines
	                        mov          si, offset starting_x_left
	                        mov          di, offset starting_y
	                        mov          cx, bricks_no
	                        mov          bx, 0

	; loop on all bricks and for each brick check if the ball collides with it or not
	CollisionLoop:          
	                        call         checkBrickExist
	                        cmp          brickExists, 0
	                        
	; pop          si                        	; restore original value else keep it (x offse)
	                        je           next_iteration
	
	check_start:            
	; pop          si

	; check bottom boundary
	; check lower bound
	check_bottom:           
	                        mov          ax, [di]                  	; brick_y
	                        add          ax, brick_height
	                        add          ax, 1
	                        cmp          ball_y, ax
	                        jg           check_top

	; check which brick was hit from range
	                        push         bx
	                        push         cx

	                        mov          bx, 0
	                        mov          cx, bricks_no
	find_brick:             
	                        mov          ax, ball_x
	                        cmp          ax, starting_x_left[bx]
	                        jl           skip
	; check right boundary
	                        mov          ax,  starting_x_left[bx]
	                        add          ax, brick_width
	                        cmp          ball_x, ax
	                        jg           skip
	                        jmp          collision
	skip:                   
	                        add          bx, 2
	                        loop         find_brick

	collision:              
	                        call         HandleCollision           	; check

	                        pop          cx
	                        pop          bx

	                        mov          VertBall, 0               	; move down
	                        jmp          next_iteration
	; mov          HorzBall, 1

	; check top for collision --> ball_y + ball_size >= bricky
	check_top:              
	                        mov          ax, ball_y
	                        add          ax, ball_size
	                        add          ax, 1                     	; extra
	                        cmp          ax, [di]
	                        jl           check_left

	; check left and right boundary of each brick to know which one same way as we did in bottom

	; second check collision from left ball_x + ball_size >= brick_x
	check_left:             
	                        mov          ax, ball_x
	                        add          ax, ball_size
	                        cmp          ax, [si]
	                        jl           check_right

	; find which brick vertically


	check_right:            
	next_iteration:         
	                        add          si, 2
	                        add          di, 2
	                        add          bx, 2

	                        dec          cx
	                        cmp          cx, 0
	                        jne          CollisionLoop

	                        ret
CheckBallBrickCollision endp

HandleCollision PROC
	                        push         si
	                        mov          si, bx

	                        cmp          Bool_Box[si], 0
	                        je           noBrick
	                        
	                        dec          Bool_Box[si]
	noBrick:                
	                        pop          si
	                        ret
HandleCollision ENDP

checkBrickExist PROC
	                        push         si
	                        mov          si, bx
	                        cmp          Bool_Box[si], 0
	                        je           skipBrick
	                        
	                        mov          brickExists, 1
	                        jmp          returnLabel
	skipBrick:              
	                        mov          brickExists, 0
	returnLabel:            
	                        pop          si
	                        ret
checkBrickExist ENDP

Main proc far
	; Initialize the data segment
	                        MOV          AX, @DATA
	                        MOV          DS, AX

	; initinalize COM
	                        initCom
	
	; start vga
	                        mov          ah, 0
	                        mov          al, 13h
	                        INT          10h
	

	                        call         BoxCreator                	;intialize the boxs based on the level
	
	;;CALL START MENU
	startmenu:              
	                        call         start_menu
	;;CALL LEVEL SELECT
	                        call         level_select
	                        call         BoxCreator                	;intialize the boxs based on the level
	;intialize the game data
	                        mov          playerOneScore, 0
	                        mov          playerTwoScore, 0

	                        mov          bool_boxs, 1
	                        mov          ball_x , 50
	                        mov          ball_y, 70
	;;START GAME
	startgame:              
	;    call         gameBoarder
	                        call         DrawLevelBorder


	
	;;GAME INNER LOOP
	gameLoop:               
	                        call         DrawScreen

	                        mov          ah, 0Ch
	                        int          21h
	                        call         delay

	                        xor          ax, ax
	                        xor          bx, bx
	                        xor          cx, cx
	                        xor          dx, dx

	                        mov          ah, 1
	                        int          16h
	                        mov          bx, ax
	                        jz           gameLoop
	                        cmp          bh, 4Bh
	                        jne          notleft
	                        call         moveLeft
	notleft:                
	                        cmp          bh, 4Dh
	                        jne          notright
	                        call         moveRight
	notright:               
	                        cmp          bl, 27
	                        je           startmenu
	                        cmp          bl, 8
	                        je           startmenu
	                        jmp          gameLoop
	
	;;CHECK WIN
	
	;;CALL END GAME MENU
	
	;;RESTART GAME
	
	;;QUIT GAME
	                        SetCursorPos 18, 1
	                        mov          ah, 4Ch
	                        int          21h                       	;exit
Main endp
END Main