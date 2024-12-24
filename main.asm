.MODEL COMPACT
.STACK 4084
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
	ball_y            dw  100
	ball_size         dw  6

	VertBall          dw  0                                  	; the direction of the ball in the vertical direction up if 1 down if 0
	HorzBall          dw  0                                  	; the direction of the ball in the horizontal direction right if 1 left if 0
	
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

	Paddle_x          dw  50                                 	; start x position for paddle
	Paddle_y          dw  160                                	; start y position for paddle
	paddle_x_half     dw  0

	level_paddle_x    dw  30                                 	; paddle width - changes according to level chosen
	level_padhalfx    dw  15

	paddleSpeed       equ 7
	
	ScoreCounter      db  0
	CurrentLives      dw  3
	Level_Selector    dw  1

	start_menu_option db  1
	space             db  ' $'
	string_start_game db  'START GAME$'
	string_chat       db  'CHAT$'
	string_exit_game  db  'EXIT GAME$'
	one               db  '1)$'
	two               db  '2)$'
	three             db  '3)$'
	levelnum_string   db  '(1)        (2)       (3)$'
	level_string      db  'LEVEL      LEVEL     LEVEL$'
	winScreenStr      db  'YOU HAVE COMPLETED THE GAME$'
	credits           db  'MADE BY: KARIM ~ HABIBA ~ HELANA$'
	winContinue       db  'DO U WISH TO CONTINUE?$'
	enterContinue     db  'Press enter to continue$'
	nToQuit           db  'Press N to quit $'


	;----------------------- bricks data
	x                 dw  11h                                	; brick x coordinate
	y                 dw  10h                                	; brick y coordinate
	brick_width       dw  18h
	brick_height      dw  08h

	starting_x_left   dw  15h, 30h, 4Bh, 66h, 81h
	                  dw  15h, 30h, 4Bh, 66h, 81h
	                  dw  15h, 30h, 4Bh, 66h, 81h
	                  dw  15h, 30h, 4Bh, 66h, 81h            	; 20 bricks

	starting_x_right  dw  0A7h, 0C2h, 0DDh, 0F8h, 0113h
	                  dw  0A7h, 0C2h, 0DDh, 0F8h, 0113h
	                  dw  0A7h, 0C2h, 0DDh, 0F8h, 0113h
	                  dw  0A7h, 0C2h, 0DDh, 0F8h, 0113h      	; 20 bricks

	starting_y        dw  15h, 15h, 15h, 15h, 15h
	                  dw  20h, 20h, 20h, 20h, 20h
	                  dw  2Bh, 2Bh, 2Bh, 2Bh, 2Bh
	                  dw  36h, 36h, 36h, 36h, 36h            	; 20 bricks
	
	bricks_no         dw  20
	color             db  50h
	colors            db  59h, 56h, 50h                      	; init value
	
	bool_boxs         dw  1
	BoxesExist        dw  1
	Bool_Box          dw  20 dup(1)
	
.CODE
	                       include      chat.inc
	                       include      draw.inc
	                       include      helper.inc
	                       include      level.inc
	                       include      moveball.inc
	                       include      screens.inc
draw_start_menu proc
	                       SetCursorPos 6, 16
	                       PrintString  string_start_game
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
	                       mov          al, 13h             	;320x200
	                       int          10h

	                       call         boarder
	                       call         draw_start_menu
	                       mov          rectcolour,15       	;ball colour
	                       mov          start_menu_option, 1
	                       mov          ball_x, 84
	                       mov          ball_y, 48
	                       call         drawball            	;draw on selected option
	                       xor          ax, ax
	                       xor          bx, bx
	                       xor          cx, cx
	                       xor          dx, dx
	kbloop:                
	                       mov          ah, 0Ch
	                       int          21h                 	;clear keyboard buffer
	                       call         delay

	                       mov          ah, 1
	                       int          16h
	                       mov          bx, ax
	                       jnz          firstcmp

	                       mov          dx, 3FDH
	                       in           al, dx
	                       and          al, 1
	                       jz           kbloop
	                       mov          dx, 03F8H
	                       in           al, dx
	                       mov          bl, al
	                       mov          bh,0
	                       jmp          sendcmp
	firstcmp:              
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
	weexit:                jmp          exit
	;-------------------------------------------
						   
	sendcmp:               
	                       cmp          bl,'1'
	                       jne          nxtcmp2send
	                       jmp          stgmsend
	nxtcmp2send:           
	                       cmp          bl,'2'
	                       jne          nxtcmp3send
	                       jmp          chattingsend
	nxtcmp3send:           
	                       cmp          bl,'3'
	                       je           exitsendhelp
	                       jmp          kbloop
	;-------------------------------------
	exitsendhelp:          jmp          exitsend
	;-------------------------------------
	moveup:                
	                       mov          rectcolour, 0       	; erase ball
	                       call         drawball
	                       dec          start_menu_option
	                       cmp          start_menu_option, 0
	                       jg           calcOption
	                       mov          start_menu_option, 1
	                       jmp          calcOption

	movedown:              
	                       mov          rectcolour, 0       	; erase ball
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
	                       mov          dx, 3F8H
	                       mov          al, '2'
	                       out          dx, al
	chattingsend:          
	                       call         CHAT
	                       jmp          ToMenu
	exit:                  
	                       mov          dx, 3F8H
	                       mov          al, '3'
	                       out          dx, al
	exitsend:              
	                       SetCursorPos 18, 1
	                       mov          ah, 4Ch
	                       int          21h                 	;exit
	stgm:                  
	                       mov          dx, 3F8H
	                       mov          al, '1'
	                       out          dx, al
	stgmsend:              
	                       ret
start_menu endp
BallPaddleCollision proc
	                       push         CX
	                       push         DX

	                       mov          ax, Paddle_x
	                       mov          bx, Paddle_y
	                       sub          bx, 10
	                       mov          si, ball_x
	                       add          si, 3               	;half of ball width

	                       cmp          si, ax
	                       jl           NoCollision

	                       add          ax, level_paddle_x
	                       mov          paddle_x_half, ax
	                       mov          dx,	level_padhalfx
	                       sub          paddle_x_half, dx
	                       mov          cx, paddle_x_half

	                       cmp          si, ax
	                       jg           NoCollision
	                       cmp          si, cx
	                       jl           skipSecondHalf
	                       cmp          ball_y, bx
	                       jl           NoCollision

	                       add          bx, 10

	                       cmp          ball_y, bx
	                       jg           NoCollision

	                       mov          VertBall, 1
	                       mov          HorzBall, 1
	                       jmp          NoCollision

	skipSecondHalf:        
	                       cmp          si, cx
	                       jg           NoCollision
	                       sub          cx, level_padhalfx
	                       cmp          si, cx
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
CheckBallWallCollision proc

	; Check collision with left boundary
	check_left_bound:      
	                       cmp          ball_x, 17          	; game border starts at 15
	                       jg           check_right_bound   	; if greater than continue checking on the rest of boundaries
	                       mov          HorzBall,1          	; reverse the direction to move right
	
	; Check collision with right boundary
	check_right_bound:     
	                       mov          ax, 158             	; divider line is the right boundary for game border
	                       sub          ax, ball_size
	                       cmp          ball_x, ax
	                       jl           check_upper_bound
	                       mov          HorzBall,0          	; reverse the direction to move left

	; Check collision with top boundary
	check_upper_bound:     
	                       cmp          ball_y, 16          	; game border starts at 15
	                       jg           check_lower_bound
	                       mov          VertBall,0          	; reverse direction to move down
	; Check collision with bottom boundary
	check_lower_bound:     
	                       mov          ax, 168             	; game border lower bound height - ball size
	                       sub          ax, ball_size
	                       cmp          ball_y, ax
	                       jl           end_check
	                       mov          VertBall,1          	; reverse direction to move up
	end_check:             
	                       ret
	
CheckBallWallCollision endp

Main proc far
	; Initialize the data segment
	                       MOV          AX, @DATA
	                       MOV          DS, AX
	                       MOV          ES, AX

	; initinalize COM
	                       initCom
	
	; start vga
	                       mov          ah, 0
	                       mov          al, 13h
	                       INT          10h
	                       call         winscreen
	
	;intialize the game data
	                       mov          playerOneScore, 0
	                       mov          playerTwoScore, 0

	                       mov          bool_boxs, 1
	                       call         BoxCreator          	;intialize the boxs based on the level
	
	;;CALL START MENU
	startmenu:             
	                       call         start_menu
	;;CALL LEVEL SELECT
	                       mov          ah, 0Ch
	                       int          21h                 	;clear keyboard buffer
	                       call         level_select
	                       call         BoxCreator          	;intialize the boxs based on the level
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
	                       int          21h                 	;exit
Main endp
END Main