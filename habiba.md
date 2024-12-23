public DrawGrid

.model small
.stack 100h

.data
x dw 11h ; Ball x coordinate
y dw 10h ; Ball y coordinate
brick_width dw 18h
brick_height dw 08h

    starting_x_left  dw 11h, 2Ch, 47h, 62h, 7Dh
    starting_x_right dw 0A1h, 0BCh, 0D7h, 0F2h, 110Dh
    starting_y       dw 10h, 1Bh, 26h, 31h, 3Ch
    colors           db 50h, 50h, 52h, 52h, 54h, 54h, 56h, 56h, 58h, 58h

    bricks_no        dw 5

.code

main proc far
mov ax, @data
mov ds, ax

                    mov  ah, 0                   	; set the configuration of the video mode
                    mov  al, 13h                 	; set the video mode 13h
                    int  10h                     	; call the BIOS video interrupt

    ; call TestProc
    ; call Brick2
                    call DrawGrid

                    mov  ah, 4ch
                    int  21h

main endp

DrawGrid PROC
mov di, 0 ; beginning of y points array
mov cx, bricks_no ; number of rows
dec cx
DrawGridLoop:  
 push cx
call DrawLeftRow
call DrawRightRow
pop cx
add di, 2
loop DrawGridLoop

                    RET

DrawGrid ENDP

DrawLeftRow PROC
mov si, 0 ; beginning of x points array
mov cx, bricks_no

    DrawLeftLoop:
                    mov  ax, starting_x_left[si]
                    mov  bx, starting_y[di]
                    mov  x, ax
                    mov  y, bx
                    push cx
                    call DrawBrick
                    pop  cx
                    add  si, 2
                    loop DrawLeftLoop

                    RET

DrawLeftRow ENDP

DrawRightRow PROC
mov si, 0 ; beginning of x points array
mov cx, bricks_no

    DrawRightLoop:
                    mov  ax, starting_x_right[si]
                    mov  bx, starting_y[di]
                    mov  x, ax
                    mov  y, bx
                    push cx
                    call DrawBrick
                    pop  cx
                    add  si, 2
                    loop DrawRightLoop

                    RET

DrawRightRow ENDP

DrawBrick PROC
mov cx, x ; init x coordinate
mov dx, y ; init y coordinate

    move_horizontal:
                    mov  ah, 0Ch                 	; set the config to draw a pixel
                    mov  al, colors[si]
                    mov  bh, 00h                 	; page number
                    int  10h
                    inc  cx

                    mov  ax, cx
                    sub  ax, x
                    cmp  ax, brick_width         	; (Y) exit horizontal check
                    jng  move_horizontal

                    mov  cx, x                   	; reset for next line
                    inc  dx

                    mov  ax, dx
                    sub  ax, y
                    cmp  ax, brick_height        	; (Y) exit vertical check
                    jng  move_horizontal

                    RET

DrawBrick ENDP

end main
