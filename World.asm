# Olutoye Odufowokan
# CS 2340.009
# Binary Game with 10 Levels and Timeout

.data
startingPromptOne: .asciiz "Welcome to the Binary Game!\n"
startingPromptTwo: .asciiz "Complete all 10 levels to win!\n"
startingPromptThree: .asciiz "Let's begin!\n"
newline: .asciiz "\n"

player: .asciiz "Player"
computer: .asciiz "Computer"

current_level: .word 1
lines_displayed: .word 0
game_over: .word 0
generated_number: .word 0
question_type: .word 0
player_score: .word 0
correct_in_level: .word 0   # Track correct answers in current level

lose_message: .asciiz "\nGame Over! You reached 7 incorrect lines.\n"
timeout_lose: .asciiz "\nGame Over! You ran out of time!\n"
win_message: .asciiz "\n CONGRATULATIONS! YOU BEAT ALL 10 LEVELS! \n"
end_message: .asciiz "Thanks for playing the Binary Game!\n"
final_score_msg: .asciiz "Your final score: "
level_score_msg: .asciiz "Correct in this level: "

.text
.globl main

main:
    # Draw title box
    jal draw_title_box

    li $v0, 4
    la $a0, newline
    syscall
    la $a0, startingPromptTwo
    syscall
    la $a0, startingPromptThree
    syscall

    jal draw_separator

    # Initialize game
    li $t0, 1
    sw $t0, current_level
    sw $zero, lines_displayed
    sw $zero, player_score
    sw $zero, correct_in_level

    # Display Level 1 introduction
    lw $a0, current_level
    jal display_level_intro

game_loop:
    # Check game over conditions
    lw $t2, game_over
    bne $t2, $zero, end_game

    # Check if 7 lines reached
    lw $t1, lines_displayed
    li $t3, 7
    bge $t1, $t3, player_loses

    # Get level configuration
    lw $a0, current_level
    jal get_level_config
    move $s3, $v0           # Save max_range
    move $s4, $v1           # Save time_limit

    # Set time limit for this level
    move $a0, $s4
    jal set_time_limit

    # Display current status
    lw $a0, current_level
    jal draw_level_box

    lw $a0, player_score
    lw $a1, lines_displayed
    jal draw_score_line

    jal draw_separator

    # Generate random number based on level range
    move $a0, $s3           # Use level's max_range
    jal generate_random_number
    sw $v0, generated_number

    # Randomly choose question type
    jal get_question_type
    sw $v0, question_type

    # Display the question
    lw $a0, generated_number
    lw $a1, question_type
    jal display_question

    # Start timer for this question
    jal start_timer

    # Get player input
    lw $a0, question_type
    jal get_player_input
    move $s0, $v0           # Save answer

    # Check for timeout
    jal check_timeout
    bne $v0, $zero, timeout_occurred

    # Check the answer
    lw $a0, generated_number
    move $a1, $s0
    lw $a2, question_type
    jal check_answer

    move $s1, $v0           # Save result
    move $s2, $v1           # Save correct answer

    # Display result
    move $a0, $s1
    move $a1, $s2
    jal display_result

    # Update based on result
    beq $s1, $zero, answer_wrong

answer_correct:
    # Increment scores
    lw $t0, player_score
    addi $t0, $t0, 1
    sw $t0, player_score

    lw $t0, correct_in_level
    addi $t0, $t0, 1
    sw $t0, correct_in_level

    # Check if level complete
    lw $a0, current_level
    lw $a1, correct_in_level
    jal check_level_complete

    beq $v0, $zero, game_loop  # Not complete, continue

    # Level complete!
    jal advance_level

    # Check if beat all 10 levels
    lw $t0, current_level
    li $t1, 10
    bgt $t0, $t1, game_won

    # Advance to next level
    addi $t0, $t0, 1
    sw $t0, current_level
    sw $zero, correct_in_level

    # Display new level intro
    lw $a0, current_level
    jal display_level_intro

    j game_loop

answer_wrong:
    # Increment lines
    lw $t1, lines_displayed
    addi $t1, $t1, 1
    sw $t1, lines_displayed

    jal draw_top_border
    j game_loop

timeout_occurred:
    # Timeout counts as wrong
    lw $t1, lines_displayed
    addi $t1, $t1, 1
    sw $t1, lines_displayed

    j game_loop

player_loses:
    li $t0, 1
    sw $t0, game_over

    jal draw_star_line
    li $v0, 4
    la $a0, lose_message
    syscall
    jal draw_star_line
    j end_game

game_won:
    li $t0, 1
    sw $t0, game_over

    jal draw_star_line
    li $v0, 4
    la $a0, win_message
    syscall
    jal draw_star_line
    j end_game

end_game:
    jal draw_bottom_border

    # Show final score
    li $v0, 4
    la $a0, final_score_msg
    syscall

    li $v0, 1
    lw $a0, player_score
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    la $a0, end_message
    syscall

    jal draw_bottom_border

    # Exit
    li $v0, 10
    syscall
