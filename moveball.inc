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
	                       cmp          ax, 17
	                       jl           ExactLeft
	                       sub          ax, 2
	                       mov          ball_x, ax
	                       jmp          VertCompare
	ExactLeft:             
	                       mov          ax, 16
	                       mov          ball_x, ax
	                       jmp          VertCompare
	MoveRightBall:         
	                       cmp          ax, 151
	                       jg           ExactRight
	                       add          ax, 2
	                       mov          ball_x, ax
	                       jmp          VertCompare
	ExactRight:            
	                       mov          ax, 152
	                       mov          ball_x, ax
	VertCompare:           
	                       cmp          cx, 0
	                       je           MoveDownBall
	MoveUpBall:            
	                       cmp          bx, 17
	                       jl           ExactUp
	                       sub          bx, 1
	                       mov          ball_y, bx
	                       jmp          EndMoveBall
	ExactUp:               
	                       mov          bx, 16
	                       mov          ball_y, bx
	                       jmp          EndMoveBall
	MoveDownBall:          
	                       add          bx, 1
	                       mov          ball_y, bx
	EndMoveBall:           
	                       pop          dx
	                       pop          cx
	                       pop          bx
	                       pop          ax
	                       ret
MoveBall endp
MoveBallRight proc
	                       push         ax
	                       push         bx
	                       push         cx
	                       push         dx
	                       mov          ax, ball_x_right
	                       mov          bx, ball_y_right
	                       mov          cx, VertBallRight
	                       mov          dx, HorzBallRight

	                       cmp          dx, 1
	                       je           MoveRightBallRight

	MoveLeftBallRight:          
	                       cmp          ax, 0A3h
	                       jl           ExactLeftRight
	                       sub          ax, 2
	                       mov          ball_x_right, ax
	                       jmp          VertCompareRight
	ExactLeftRight:             
	                       mov          ax, 0A2h
	                       mov          ball_x_right, ax
	                       jmp          VertCompareRight
	MoveRightBallRight:         
	                       cmp          ax, 129h
	                       jg           ExactRightRight
	                       add          ax, 2
	                       mov          ball_x_right, ax
	                       jmp          VertCompareRight
	ExactRightRight:            
	                       mov          ax, 12Ah
	                       mov          ball_x_right, ax
	VertCompareRight:           
	                       cmp          cx, 0
	                       je           MoveDownBallRight
	MoveUpBallRight:            
	                       cmp          bx, 17
	                       jl           ExactUpRight
	                       sub          bx, 1
	                       mov          ball_y_right, bx
	                       jmp          EndMoveBallRight
	ExactUpRight:               
	                       mov          bx, 16
	                       mov          ball_y_right, bx
	                       jmp          EndMoveBallRight
	MoveDownBallRight:          
	                       add          bx, 1
	                       mov          ball_y_right, bx
	EndMoveBallRight:           
	                       pop          dx
	                       pop          cx
	                       pop          bx
	                       pop          ax
	                       ret
MoveBallRight endp
