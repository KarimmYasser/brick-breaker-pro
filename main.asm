.MODEL SMALL
.STACK 100h
	
.DATA
	rect_x            dw 0
	rect_y            dw 0
	rectwidth         dw 0
	rectheight        dw 0
	rectcolour        db 0

	ball_x            dw 0
	ball_y            dw 0
	
	ScoreCounter      db 0
	CurrentLives      dw 3
	Level_Selector    dw 1

	bool_boxs         dw 1
	Bool_BoxExist     dw 1
	Bool_Box          dw 1, 1, 1, 1, 1, 1, 1, 1

	start_menu_option db 1
	string_start_game db 'START GAME$'
	string_exit_game  db 'EXIT GAME$'
	one               db '1)$'
	two               db '2)$'
	
.CODE
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
BoxCreator PROC
	                   mov          cx, 8
	                   mov          si, offset Bool_Box
	
	                   mov          Bool_BoxExist, 1
	                   mov          ax, Level_Selector
	
	loopBC:            
	
	                   mov          [si], ax
	
	                   add          si, 2
	
	                   loop         loopBC
	
	                   ret
BoxCreator ENDP
DrawRectangle PROC
	
	                   push         cx
	
	                   mov          Al, rectcolour
	                   mov          CX, rect_x
	                   dec          cx                   	; 0 based
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
	
	
	                   mov          rectcolour, 14
	                   mov          rectwidth, 320
	                   mov          rectheight, 200
	                   mov          rect_x, 0
	                   mov          rect_y, 0
	                   call         DrawRectangle
	
	                   mov          rectcolour, 0
	                   mov          rectwidth, 292       	; 320 - 14 - 14
	                   mov          rectheight, 180      	; 200 - 10 - 10
	                   mov          rect_x, 14
	                   mov          rect_y, 10
	                   call         DrawRectangle
	                   ret
boarder endp
delay proc
	                   push         ax
	                   push         bx
	                   push         cx
	                   push         dx

	                   mov          cx, 11000

	                   mov          ax, Level_Selector
	                   cmp          ax, 1
	                   je           level1
	                   cmp          ax, 2
	                   je           level2
	                   cmp          ax, 3
	                   je           level3
	                   jmp          end_set_delay

	level1:            
	                   mov          bx, 15
	                   jmp          end_set_delay

	level2:            
	                   mov          bx, 10
	                   jmp          end_set_delay

	level3:            
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
	                   mov          al, 13h              	;320x200
	                   int          10h

	                   call         boarder
	                   call         draw_start_menu
	                   mov          rectcolour,15        	;ball colour
	                   mov          start_menu_option, 1
	                   mov          ball_x, 84
	                   mov          ball_y, 64
	                   call         drawball             	;draw on selected option
	kbloop:            
	                   xor          ax, ax
	                   xor          bx, bx
	                   xor          cx, cx
	                   xor          dx, dx
	                   mov          ah, 0Ch
	                   int          21h                  	;clear keyboard buffer
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
	                   je           select
	                   cmp          bl,'1'
	                   jne          nxtcmp
					   jmp		    stgm
	nxtcmp:
	                   cmp          bl,'2'
	                   je           exit
	moveup:            
	                   mov          rectcolour, 0        	; erase ball
	                   call         drawball
	                   dec          start_menu_option
	                   cmp          start_menu_option, 0
	                   jg           calcOption
	                   mov          start_menu_option, 2
	                   jmp          calcOption

	movedown:          
	                   mov          rectcolour, 0        	; erase ball
	                   call         drawball
	                   inc          start_menu_option
	                   cmp          start_menu_option, 3
	                   jl           calcOption
	                   mov          start_menu_option, 1
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
	                   SetCursorPos 98, 18
	                   mov          ah, 4Ch
	                   int          21h                  	;exit
	stgm:              
	                   call         boarder
	                   ret
start_menu endp

	
Main proc far
	; Initialize the data segment
	                   MOV          AX, @DATA
	                   MOV          DS, AX
	
	; start vga
	                   mov          ah, 0
	                   mov          al, 13h
	                   INT          10h
	
	;intialize the game data
	                   mov          CurrentLives, 3
	                   mov          ScoreCounter, 0
	                   mov          bool_boxs, 1
	                   call         BoxCreator           	;intialize the boxs based on the level
	
	;;CALL START MENU
	                   call         boarder
	                   call         start_menu
	;mov ah, 0h
	;mov al, 13h                  ;320x200
	;int 10h
	
	
	;;MENU LOOP
	
	;;CALL INSTRUCTION MENU
	
	;;START GAME
	
	;;GAME INNER LOOP
	
	;;CHECK WIN
	
	;;CALL END GAME MENU
	
	;;RESTART GAME
	
	;;QUIT GAME
	
	
Main endp
END Main
