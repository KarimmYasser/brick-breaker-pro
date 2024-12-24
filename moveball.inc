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
