# Brick Breaker Pro Game  

## Overview  
**Brick Breaker Pro** is a classic arcade-style game developed using **x8086 Assembly Language**, featuring a **multiplayer mode** enabled via **serial communication**. Players compete to break bricks while managing lives, progressing through challenging levels with increasing difficulty.  

The game includes a **start menu** where players can initiate a chat with their opponent once the serial connection is established, as well as a **level select screen** to choose between multiple levels.

---

## Features  
- **Start Menu**: Players can navigate to begin the game, exit game, and use a built-in **chat feature** to communicate with the opponent via serial communication.
- **Chat Feature**: Allows players to send text messages to each other in chat screen once the serial connection is established.
- **Level Select Screen**: Choose between multiple levels before starting the game.
- **Multiplayer Mode**: Two players can connect and compete via serial communication.  
- **Lives System**: Each player starts with 3 lives.  
- **Three Levels**:  
  - **Level 1**: Bricks break with one hit.  
  - **Level 2**: Bricks require two hits to break.  
  - **Level 3**: Bricks require three hits to break.  
- **Scoring System**: Players earn points for breaking bricks.  
- **Game Over Condition**: A player loses when all lives are lost.  

---

## How to Play  
1. Connect two systems using a serial cable.  
2. Launch the game on both systems.
3. Upon starting the game, you'll be presented with the **Start Menu**.
4. In the **Start Menu**, connect with the second player via serial communication, and use the **chat feature** to exchange messages before the game starts.  
5. Select **Start Game** to begin the game in both sides.
6. Use the keyboard to move the paddle and hit the ball.  
7. Break all the bricks to advance to the next level.  
8. Avoid losing all lives to stay in the game.  

---

## Game Controls  
- **Left Arrow**: Move paddle left.  
- **Right Arrow**: Move paddle right.  
- **ESC**: Return to start menu.  

---

## Requirements  
- **DOSBox**: A DOS emulator is required to run the game.  
- **Serial Communication**: Ensure the systems are connected via a serial port.  

---

## How to Build and Run  
1. Assemble the code using an x8086 assembler, such as **MASM** or **TASM**.  
   ```bash
   masm main.asm;
   link main.obj;
   ```
2. Configure the serial communication port settings (e.g., COM1).  
3. Load the executable into **DOSBox** and start the game.  

---

## Code Structure  
- **Initialization**: Configures serial communication, graphics, and game variables.  
- **Start Menu**: Displays the start screen, where players can select to begin the game and use the chat feature to communicate.  
- **Chat Feature**: Allows players to send messages to each other once the serial connection is established in the start menu.  
- **Level Select Screen**: Allows players to choose between available levels.  
- **Gameplay Loop**: Handles ball movement, collision detection, and scoring.  
- **Multiplayer Logic**: Synchronizes game state between players via serial communication.  
- **Levels and Difficulty**: Adjusts brick durability as levels progress. 

---

## Notes  
- Ensure proper serial port configuration for smooth multiplayer experience.  
- Use **DOSBox** for running the game on modern systems.  

---

## Future Enhancements  
- Add sound effects for collisions and level progression.  
- Introduce power-ups (e.g., paddle size increase, multi-ball).  

---

## Credits  

Developed by **Karim Yasser**, **Habiba Aymen** and **Helana Nady**.  

Feel free to contribute by creating pull requests or reporting issues.  
