public TestProc

.model small
.stack 100h

.data
    x          dw 0Ah    ; Ball x coordinate
    y          dw 0Ah    ; Ball y coordinate
    squareSize dw 30h

.code

main proc far
                    mov ax, @data
                    mov ds, ax

    ; call TestProc
                                    
                    mov ah, 4ch
                    int 21h
main endp

TestProc PROC far
    ; mov ah, 0              ; set the configuration of the video mode
    ; mov al, 13h            ; set the video mode 13h
    ; int 10h                ; call the BIOS video interrupt

    ; mov ah, 0Bh            ; set the config to background color
    ; mov bh, 00h            ; set background color
    ; mov bl, 03h            ; color
    ; int 10h

                    mov cx, x              ; init x coordinate
                    mov dx, y              ; init y coordinate

    Draw_horizontal:
                    mov ah, 0Ch            ; set the config to draw a pixel
                    mov al, 15             ; choose white color
                    mov bh, 00h            ; page number
                    int 10h
                    inc cx

                    mov ax, cx
                    sub ax, x
                    cmp ax, squareSize     ; (Y) exit horizontal check
                    jng Draw_horizontal
              
                    mov cx, x              ; reset for next line
                    inc dx

                    mov ax, dx
                    sub ax, y
                    cmp ax, squareSize     ; (Y) exit vertical check
                    jng Draw_horizontal
                    RET
TestProc ENDP

end main