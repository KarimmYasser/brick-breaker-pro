.MODEL SMALL
.STACK 100h

.DATA
start_game DB 0

inst DB 'PRESS I TO GO INTO INSTRUCTION BOX', 0
oldisr DD 0
colume DW 0
row DW 0
incC DB 0
incR DB 0
previous DW 0
tickcount DB 0
left_edge DW 3524
right_edge DW 3652
right_ DW 0
left_ DW 0
pre_stack_pos DW 3580

second DW 0
minute DB 0
clock DB 0
bonus DW 0

bricks_start_location DW 810, 828, 846, 864, 882, 900, 918, 936, 1290, 1308, 1326, 1344, 1362, 1380, 1398, 1416, 1770, 1788, 1806, 1824, 1842, 1860, 1878, 1896
bricks_end_location DW 822, 840, 858, 876, 894, 912, 930, 948, 1302, 1320, 1338, 1356, 1374, 1392, 1414, 1428, 1782, 1800, 1818, 1836, 1854, 1872, 1890, 1908

score DW 0
total_bricks DW 24
calculated_location DW 0
left_limit DW 0
right_limit DW 0
mid DW 0
left_or_right DB 0
preBall DW 0

live DB 3
end_of_game DW 0
StayOnStacker DB 0

counter DW 0
solid DB 0
solid1 DB 0

Lose_str DB 'YOU_LOSE', 0
Score_str DB 'SCORE', 0
Lives_str DB 'LIVES', 0

welcome_str DB 'WELCOME TO BRICK BREAKER', 0
option_str DB 'PLEASE SELECT OPTIONS', 0
instructions_str DB 'INSTRUCTION', 0
play_str DB 'PRESS ENTER TO PLAY GAME', 0

ttl_live_str DB 'YOUR TOTAL LIVES ARE 3', 0
bonus_note_str DB 'BONUS AWARDED IF BREAK ALL BRICKS IN 2 MINS', 0
solid_base_str DB 'HITTING RED BRICK WILL SOLIDIFY YOUR BASE', 0

space_bar DB 'PRESS SPACE BAR TO RELEASE BALL', 0

total_score_str DB 'YOUR TOTAL SCORES :', 0
lives_remain_str DB 'LIVES REMAINING', 0
exit_str DB 'PRESS E TO EXIT', 0
quit_str DB 'PRESS ENTER+Q TO QUIT GAME', 0
restart_str DB 'PRESS ENTER+R TO RESTART YOUR GAME', 0

left_arrow DB 'USE RIGHT & LEFT ARROW TO MOVE BAR', 0

.CODE
Main proc far
START:
    ; Initialize the data segment
    MOV AX, @DATA
    MOV DS, AX

    ; start vga
	MOV AX,12h
	INT 10h

    ;;CALL START MENU

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