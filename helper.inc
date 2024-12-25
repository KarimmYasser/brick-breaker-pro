BoxCreator PROC
	                       mov          cx, bricks_no
	                       mov          si, offset Bool_Box
												 mov          di, offset Bool_Box_left
	
	                       mov          BoxesExist, 1
	                       mov          ax, Level_Selector
	
	loopBC:                
	
	                       mov          [si], ax
												 mov          [di], ax
	
	                       add          si, 2
												 add          di, 2
	
	                       loop         loopBC
	
	                       ret
BoxCreator ENDP



moveLeft proc
						   mov			ax, Paddle_x
						   mov			oldPaddle_x, ax
	                       cmp          Paddle_x, 22          	; left border boundary + speed
	                       jle          endleft
	                       sub          Paddle_x, paddleSpeed
	                       ret
	endleft:               
	                       mov          Paddle_x, 15          	; left border boundary
	                       ret
moveLeft endp

moveRight proc
						   mov			ax, Paddle_x
						   mov			oldPaddle_x, ax
	                       mov          ax, Paddle_x
	                       add          ax, level_paddle_x
	                       cmp          ax, 151               	; right border boundary - speed
	                       jge          endright
	                       add          Paddle_x, paddleSpeed
	                       ret
	endright:              
	                       mov          ax, 159               	; right border boundary
	                       sub          ax, level_paddle_x
	                       mov          Paddle_x, ax
	                       ret
moveRight endp

moveCenter proc
						   mov			ax, Paddle_x
						   mov			oldPaddle_x, ax
	                       mov          ax, Paddle_x
	                       add          ax, level_paddle_x
	                       cmp          ax, 151               	; right border boundary - speed
	                       jge          endcenter
	                       add          Paddle_x, 0
	                       ret
	endcenter:              
	                       mov          ax, 159               	; right border boundary
	                       sub          ax, level_paddle_x
	                       mov          Paddle_x, ax
	                       ret
moveCenter endp

WAIT_FOR_VSYNC PROC NEAR
	                       push         ax
	                       push         dx
	                       mov          dx, 3DAh              	; VGA status port
	vsync_wait1:           
	                       in           al, dx
	                       test         al, 8                 	; Check vertical retrace
	                       jnz          vsync_wait1           	; Wait if already in retrace
	vsync_wait2:           
	                       in           al, dx
	                       test         al, 8                 	; Wait for vertical retrace
	                       jz           vsync_wait2
	                       pop          dx
	                       pop          ax
	                       ret
WAIT_FOR_VSYNC ENDP

delay proc
	                       push         ax
	                       push         bx
	                       push         cx
	                       push         dx

	                       mov          cx, 0FFFFh

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
delayshort proc
	                       push         ax
	                       push         bx
	                       push         cx
	                       push         dx

	                       mov          cx, 10000

	                       mov          bx, 10
	mydelay2:               
	                       push         cx
	                       mov          cx, bx
	mydelay12:              
	                       dec          cx
	                       jnz          mydelay12
	                       pop          cx
	                       loop         mydelay2

	                       pop          dx
	                       pop          cx
	                       pop          bx
	                       pop          ax

	                       ret
delayshort ENDP


CheckBox PROC
	push ax
	push bx
	push cx
	push dx
	push bp
	push si
	push di
	
	mov cx, bricks_no
	mov si, offset Bool_Box
	
	mov BoxesExist, 0
	
loopCB:
	
	mov ax, [si]
	cmp ax , 0
	je noBox
	
	mov BoxesExist, 1
	
noBox:
	
	add si, 2
	
	loop loopCB
	
	
	cmp BoxesExist, 0
    jne skip_level_check

    cmp Level_Selector, 1
    je level_1

    cmp Level_Selector, 2
    je level_2

    cmp Level_Selector, 3
    je level_3

    jmp end_level_check

level_1:
    mov Level_Selector, 2
	call BoxCreator
    jmp startgame

level_2:
    mov Level_Selector, 3
	call BoxCreator
    jmp startgame

level_3:
    call winscreen
    jmp startmenu

skip_level_check:
end_level_check:
	
	pop di
	pop si
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	CheckBox ENDP