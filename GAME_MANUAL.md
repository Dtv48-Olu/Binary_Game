# Binary Game - User Manual
---
## Overview
This is a binary conversion game. You convert numbers between decimal and binary formats. Complete all 10 levels to win.

## How to Play

### Starting the Game
1. Run the program in MARS
2. Read the welcome screen
3. Press any key to begin Level 1

### Gameplay
- The computer shows you a number to convert
- Two types of questions:
  - "Convert this decimal to binary: 5" → Answer: 101
  - "Convert this binary to decimal: 101" → Answer: 5
- Type your answer and press Enter
- Get feedback: "Correct!" or "Incorrect! The correct answer was: X"

### Levels
The game has 10 levels with increasing difficulty:

| Level | Number Range | Time Limit | Need to Advance |
|-------|--------------|------------|-----------------|
| 1     | 0-15         | 60 seconds | 5 correct       |
| 2     | 0-31         | 50 seconds | 5 correct       |
| 3     | 0-63         | 45 seconds | 5 correct       |
| 4     | 0-127        | 40 seconds | 6 correct       |
| 5     | 0-255        | 35 seconds | 6 correct       |
| 6     | 0-511        | 30 seconds | 7 correct       |
| 7     | 0-1023       | 25 seconds | 7 correct       |
| 8     | 0-2047       | 20 seconds | 8 correct       |
| 9     | 0-4095       | 15 seconds | 8 correct       |
| 10    | 0-8191       | 10 seconds | 10 correct      |

### Win Conditions
- Complete all 10 levels
- Get the required correct answers for each level
- Stay under the time limit

### Lose Conditions
- Get 7 wrong answers total (across all levels)
- Take too long to answer (timeout counts as wrong)

## Controls
- Type numbers using keyboard
- Press Enter to submit answer
- The game validates your input automatically

## Input Rules
- For binary answers: Only use 0 and 1 (example: 101)
- For decimal answers: Use regular numbers (example: 5)
- Invalid input shows error message and asks you to try again

## Scoring
- Track correct answers (your score)
- Track wrong answers (lines displayed)
- Each level shows: "Score: X | Lines: Y/7"

## Tips
- Practice binary conversion before playing
- Work quickly - time limits get shorter each level
- Remember: 7 wrong answers total = game over
- Use powers of 2: 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024...

## Technical Requirements
- MARS MIPS Simulator
- All .asm files in same directory
- Enable "Assemble all files in directory" in MARS settings

## Troubleshooting
- If game won't start: Check MARS settings
- If input rejected: Use only valid characters (0,1 for binary; 0-9 for decimal)
- If functions not found: Make sure all .asm files are in directory

---