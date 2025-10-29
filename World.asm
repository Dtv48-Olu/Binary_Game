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
game_over: .word 0
generated_number: .word 0    # Store the random number generated
question_type: .word 0       # 0 = decimal to binary, 1 = binary to decimal

lose_message: .asciiz "\nGame Over! You reached 7 incorrect lines.\n"
end_message: .asciiz "Thanks for playing the Binary Game!\n"

.text
.globl main


main:
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

game_loop: # while the game is not over the loop will continue unless the player quits or loses
      lw $t2, game_over
      bne $t2, $zero, end_game # If game_over does not equal zero, end the game

      lw $t1, lines_displayed
      li $t3, 7
      bge $t1, $t3, player_loses # When the number of lines reach 7+ >=or greater than or equal to 7 it will branch to player_loses

      # Generate random number (range depends on level, for now use 15)
      li $a0, 15              # Max range for level 1
      jal generate_random_number
      sw $v0, generated_number    # Store the generated number

      # Display the question (0 = decimal to binary)
      lw $a0, generated_number
      li $a1, 0               # Question type: decimal to binary
      jal display_question

      # TODO: Call Player.asm to get input
      # TODO: Call Validation_Check.asm to check answer
      # TODO: If wrong, increment lines_displayed and add line

      # Loop back
      j game_loop

player_loses:
    li $t0, 1
    sw $t0, game_over

    # Display lose message
    li $v0, 4
    la $a0, lose_message
    syscall

    j end_game

end_game:
    # Display final score/message
    li $v0, 4
    la $a0, end_message
    syscall

    # Exit program
    li $v0, 10
    syscall
