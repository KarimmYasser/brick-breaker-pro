; for any outside procedures that uses draw rectangle
public DrawRectangle
public rectcolour
public rectheight
public rectwidth
public rect_x
public rect_y

; for drawing game border
public playerOneScore
public playerTwoScore
public playerOneLives
public playerTwoLives
public Level_Selector

extrn DrawLevelBorder:far
extrn TestProc:far

.MODEL SMALL
.STACK 100h
include     macros.inc      ; general macros
	
.DATA
	rect_x            dw 0
	rect_y            dw 0
	rectwidth         dw 0
	rectheight        dw 0
	rectcolour        db 0

	playerOneLives    dw 3
	playerTwoLives    dw 3
	playerOneScore    db 0
	playerTwoScore    db 0

	ball_x            dw 100
	ball_y            dw 100

	VertBall          dw 0
	HorzBall          dw 0

	Paddle_x          dw 50                           	; start x position for paddle
	Paddle_y          dw 160                          	; start y position for paddle
	paddle_x_half     dw 0

	level_paddle_x    dw 30                           	; paddle width - changes according to level chosen
	level_padhalfx    dw 15
	
	ScoreCounter      db 0
	CurrentLives      dw 3
	Level_Selector    dw 1

	bool_boxs         dw 1
	Bool_BoxExist     dw 1
	Bool_Box          dw 1, 1, 1, 1, 1, 1, 1, 1
	NumBoolBox        dw 8

	start_menu_option db 1
	string_start_game db 'START GAME$'
	string_exit_game  db 'EXIT GAME$'
	one               db '1)$'
	two               db '2)$'
	levelnum_string   db '(1)        (2)       (3)$'
	level_string      db 'LEVEL      LEVEL     LEVEL$'
	
.CODE

BoxCreator PROC
	                    mov          cx, NumBoolBox
	                    mov          si, offset Bool_Box
	
	                    mov          Bool_BoxExist, 1
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
	                    call         DrawPaddle
	                    cmp          Paddle_x, 17
	                    jle          endleft
	                    sub          Paddle_x, 7
	                    ret
	endleft:            
	                    mov          Paddle_x, 17
	                    ret
moveLeft endp

moveRight proc
	                    mov          rectcolour, 0
	                    mov          ax, level_paddle_x
	                    mov          rectwidth, ax
	                    call         DrawPaddle
	                    mov          ax, Paddle_x
	                    add          ax, level_paddle_x
	                    cmp          ax, 148
	                    jge          endright
	                    add          Paddle_x, 7
	                    ret
	endright:           
	                    mov          ax, 150
	                    sub          ax, level_paddle_x
	                    mov          Paddle_x, ax
	                    ret
moveRight endp

DrawRectangle PROC
	
	                    push         cx
	
	                    mov          Al, rectcolour
	                    mov          CX, rect_x
	                    dec          cx                  	; 0 based
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
	                    mov          rectwidth, 300      	; 320 - 10 - 10
	                    mov          rectheight, 180     	; 200 - 10 - 10
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
	                    mov          rectwidth, 6
	                    mov          rectheight, 6

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

BallPaddleCollision proc
	                    push         CX
	                    push         DX

	                    mov          ax, Paddle_x
	                    sub          ax, 5
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
	                    jg           skipFirstHalf
	                    cmp          ball_x, cx
	                    jl           skipFirstHalf
	                    cmp          ball_y, bx
	                    jl           skipFirstHalf

	                    add          bx, 10

	                    cmp          ball_y, bx
	                    jg           skipFirstHalf

	                    mov          VertBall, 1
	                    mov          HorzBall, 0

	skipFirstHalf:      
	                    cmp          ball_x, ax
	                    jg           NoCollision
	                    cmp          ball_x, cx
	                    jg           NoCollision
	                    cmp          ball_y, bx
	                    jl           NoCollision

	                    add          bx, 10

	                    cmp          ball_y, bx
	                    jl           NoCollision

	                    mov          VertBall, 1
	                    mov          HorzBall, 1

	NoCollision:        
	                    pop          DX
	                    pop          CX
	                    ret
BallPaddleCollision endp
draw_start_menu proc
	                    SetCursorPos 8, 16
	                    PrintString  string_start_game
	                    SetCursorPos 8, 12
	                    PrintString  one
	                    SetCursorPos 14, 16
	                    PrintString  string_exit_game
	                    SetCursorPos 14, 12
	                    PrintString  two
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
	                    mov          ball_y, 64
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
	                    jmp          exit
	nxtcmp3:            
	                    cmp          bl, 27
	                    je           exit
	                    jmp          kbloop
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
	                    cmp          start_menu_option, 3
	                    jl           calcOption
	                    mov          start_menu_option, 2
	                    jmp          calcOption
	calcOption:         
	                    cmp          start_menu_option, 2
	                    je           option2
	                    mov          ball_x, 84
	                    mov          ball_y, 64
	                    mov          rectcolour, 15
	                    call         drawball
	                    jmp          kbloop
	option2:            
	                    mov          ball_x, 84
	                    mov          ball_y, 112
	                    mov          rectcolour, 15
	                    call         drawball
	                    jmp          kbloop
	select:             
	                    cmp          start_menu_option, 1
	                    je           stgm
	                    cmp          start_menu_option, 2
	                    jne          stgm
	exit:               
	                    SetCursorPos 18, 1
	                    mov          ah, 4Ch
	                    int          21h                 	;exit
	stgm:               
	                    ret
start_menu endp

level_select proc
	                    mov          ah, 0
	                    mov          al, 13h             	;320x200
	                    int          10h
	                    call         boarder

	                    mov          AH, 0Ch             	; Clear Buffer
	                    int          21h
	                    SetCursorPos 4, 7

	                    lea          dx,levelnum_string
	                    mov          ah,09h
	                    int          21h

	                    mov          AH, 0Ch             	; Clear Buffer
	                    int          21h

	                    SetCursorPos 12, 6

	                    lea          dx,level_string
	                    mov          ah,09h
	                    int          21h

	                    mov          AH, 0Ch             	;Clear Buffer
	                    int          21h

	                    SetCursorPos 14, 7

	                    lea          dx,levelnum_string
	                    mov          ah,09h
	                    int          21h

	                    mov          AH, 0Ch             	;Clear Buffer
	                    int          21h


	                    mov          rectcolour, 1
	                    mov          rectwidth, 40
	                    mov          rectheight, 26

	                    mov          rect_x, 48
	                    mov          rect_y, 46
	                    call         DrawRectangle
				   
	                    mov          rectcolour,13
	                    mov          rect_x,136
	                    call         DrawRectangle
				   
	                    mov          rectcolour,4
	                    mov          rect_x,217
	                    call         DrawRectangle
	again_and_again:    
	                    mov          AH, 0Ch             	;Clear Buffer
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
	gostartmenu:        jmp          startmenu
DrawScreen PROC
	;call         CheckBox
	                    mov          rectcolour, 0       	;draw ball black
	                    call         drawball
	                    call         TestProc

	;call         BallMovement
	;call         BallWallCollision
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
	
Main proc far
	; Initialize the data segment
	                    MOV          AX, @DATA
	                    MOV          DS, AX
	
	; start vga
	                    mov          ah, 0
	                    mov          al, 13h
	                    INT          10h
	
	;intialize the game data
	                    mov          playerOneScore, 0
	                    mov          playerTwoScore, 0

	                    mov          bool_boxs, 1
	                    call         BoxCreator          	;intialize the boxs based on the level
	
	;;CALL START MENU
	startmenu:          
	                    call         start_menu
	;;CALL LEVEL SELECT
	                    call         level_select
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
