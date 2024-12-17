; Declare the external variables and procedures
DrawHeart MACRO
              mov al, 3        ;ASCII code of heart to display
              mov bx, 0        ; page 0,
              mov bl, 1100b    ; color red
              mov cx, 1        ; repetition count
              mov ah, 09h      ; config line
              int 10h          ; for writing char at cursor position
ENDM

public DrawLevelBorder

extrn rectcolour:byte
extrn rectheight:word
extrn rectwidth:word
extrn rect_x:word
extrn rect_y:word

extrn playerOneScore: word
extrn playerTwoScore: word
extrn playerOneLives: word
extrn playerTwoLives: word

extrn DrawRectangle:far

.model small
.stack 100h

.data
    CurrentLives dw 0
    HeartColumn  db 0
    buffer db 100 dup('$')
.code
                      include      macros.inc              ; general macros

Main proc far
                      mov          ax, @data
                      mov          ds, ax

                      mov          ah, 4Ch
                      int          21h
Main endp

DrawLevelBorder proc far
    ; Draws the outer black border
                      mov          rectcolour, 0           ; black color
                      mov          rectwidth, 320          ; whole width
                      mov          rectheight, 200         ; whole height
                      mov          rect_x, 0
                      mov          rect_y, 0
                      call         DrawRectangle

    ; Draw the outer yellow border
                      mov          rectcolour, 14          ; yellow color
                      mov          rectwidth, 300
                      mov          rectheight, 180
                      mov          rect_x, 9
                      mov          rect_y, 9
                      call         DrawRectangle

    ; Draw the black inner game rectangle
                      mov          rectcolour, 0           ; black color
                      mov          rectwidth, 280
                      mov          rectheight, 160
                      mov          rect_x, 19
                      mov          rect_y, 19
                      call         DrawRectangle

                      call         DrawDivider

    ; draw hearts for both players
                      mov          ax, playerOneLives
                      mov          CurrentLives, ax
                      mov          HeartColumn, 0
                      call         DrawHearts

                      mov          ax, playerTwoLives
                      mov          CurrentLives, ax
                      mov          HeartColumn, 79
                      call         DrawHearts
                       
                      ret
DrawLevelBorder endp

DrawDivider proc
                      mov          rectcolour, 14          ; yellow color
                      mov          rectwidth, 4
                      mov          rectheight, 180
                      mov          rect_x, 158             ; centered
                      mov          rect_y, 9
                      call         DrawRectangle
                      ret
DrawDivider endp


DrawHearts PROC
    ; Check if CurrentLives > 2 (for third heart)
                      mov          ax, CurrentLives
                      cmp          ax, 3
                      jb           skip_third_heart        ; If CurrentLives < 3, skip drawing the third heart

    draw_third_heart: 
                      SetCursorPos 4 HeartColumn
                      DrawHeart

    skip_third_heart: 

    ; Check if CurrentLives > 1 (for second heart)
                      mov          ax, CurrentLives
                      cmp          ax, 2
                      jb           skip_second_heart       ; If CurrentLives < 2, skip drawing the second heart

    draw_second_heart:
                      SetCursorPos 3 HeartColumn
                      DrawHeart

    skip_second_heart:
    ; Check if CurrentLives > 0 (for first heart)
                      mov          ax, CurrentLives
                      cmp          ax, 1
                      jb           skip_first_heart        ; If CurrentLives < 1, skip drawing the first heart

    draw_first_heart: 
                      SetCursorPos 2 HeartColumn
                      DrawHeart

    skip_first_heart: 
                      ret
DrawHearts ENDP

DrawBorderStrings proc

DrawBorderStrings ENDP

end Main
