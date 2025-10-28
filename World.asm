# Olutoye Odufowokan
# CS 2340.009
# In-line Project Description: A simple binary game that tests the user's knowledge of binary numbers. Recreated using MIPS assembly language.
.data
startingPromptOne: .asciiz "Welcome to the Binary Game!\n"
startingPromptTwo: .asciiz "Please read the project documentation if you don't know the rules for how the game operates\n"
startingPromptThree: .asciiz "Let's begin!\n"

player: .asciiz "Player" # Placeholder text as the player would need to be mentioned multiple times
computer: .asciiz "Computer" # Placeholder text as the computer would need to be mentioned multiple times

current_level: .word 1
line: .asciiz "----------------------------------------\n"
lines_displayed: .word 0
game_over: word 0

.text
.main
    # Printing my three starting prompts
    li $v0, 4
    la $a0, startingPromptOne
    syscall
    li $v0, 4
    la $a0, startingPromptTwo
    syscall
    li $v0, 4
    la $a0, startingPromptThree
    syscall

    li $t0, 1
    sw $t0, current_level

    li $t1, 0
    sw $t1, lines_displayed

    # World.asm controls the game's logic and flow. It be functioning as game loop that call upon the assembly modules for it to work
    # I'll implement a timeout personally for just proper coding practice even though it not technically require

    game_loop:
