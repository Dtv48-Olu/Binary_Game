# Olutoye Odufowokan
# Player.asm
# Responsible for getting player input using menu selection

.data
# Menu prompts
input_prompt: .asciiz "Your answer: "
enter_prompt: .asciiz "Enter your answer (as a number): "
invalid_choice: .asciiz "Invalid input! Please enter a valid number.\n"
try_again: .asciiz "Try again: "

# Menu for binary input (when converting decimal to binary)
binary_menu_title: .asciiz "\n=== Enter Binary Number ===\n"
binary_instruction: .asciiz "Type the binary number (using only 0 and 1) and press Enter\n"
binary_example: .asciiz "Example: For binary 101, type: 101\n"

# Menu for decimal input (when converting binary to decimal)
decimal_menu_title: .asciiz "\n=== Enter Decimal Number ===\n"
decimal_instruction: .asciiz "Type the decimal number and press Enter\n"
decimal_example: .asciiz "Example: For 5, type: 5\n"

newline: .asciiz "\n"

.text
.globl get_player_input
.globl get_binary_input
.globl get_decimal_input
.globl validate_binary_input

# Function: get_player_input
# Purpose: Main function to get player input based on question type
# Input: $a0 = question_type (0 = need binary input, 1 = need decimal input)
# Output: $v0 = player's answer (as integer)
get_player_input:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    move $s0, $a0       # Save question type

    # Check question type
    beq $s0, $zero, need_binary_input
    # Otherwise, need decimal input
    j need_decimal_input

need_binary_input:
    # Question is decimal->binary, so get binary from user
    jal get_binary_input
    j get_player_input_end

need_decimal_input:
    # Question is binary->decimal, so get decimal from user
    jal get_decimal_input

get_player_input_end:
    # Result is already in $v0
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Function: get_binary_input
# Purpose: Gets binary number input from player (e.g., 101, 1100, etc.)
# Output: $v0 = binary number as integer (e.g., 101, 1100)
get_binary_input:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Display binary input menu
    li $v0, 4
    la $a0, binary_menu_title
    syscall

    la $a0, binary_instruction
    syscall

    la $a0, binary_example
    syscall

get_binary_retry:
    # Prompt for input
    li $v0, 4
    la $a0, input_prompt
    syscall

    # Read integer input
    li $v0, 5           # syscall 5 = read integer
    syscall
    move $t0, $v0       # Save input

    # Validate that input contains only 0s and 1s
    move $a0, $t0
    jal validate_binary_input

    # Check if valid
    beq $v0, $zero, binary_input_invalid

    # Valid input
    move $v0, $t0
    j get_binary_input_end

binary_input_invalid:
    # Display error and retry
    li $v0, 4
    la $a0, invalid_choice
    syscall

    la $a0, try_again
    syscall

    j get_binary_retry

get_binary_input_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: get_decimal_input
# Purpose: Gets decimal number input from player
# Output: $v0 = decimal number
get_decimal_input:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Display decimal input menu
    li $v0, 4
    la $a0, decimal_menu_title
    syscall

    la $a0, decimal_instruction
    syscall

    la $a0, decimal_example
    syscall

get_decimal_retry:
    # Prompt for input
    li $v0, 4
    la $a0, input_prompt
    syscall

    # Read integer input
    li $v0, 5           # syscall 5 = read integer
    syscall
    move $t0, $v0       # Save input

    # Check if input is negative
    blt $t0, $zero, decimal_input_invalid

    # Valid input
    move $v0, $t0
    j get_decimal_input_end

decimal_input_invalid:
    # Display error and retry
    li $v0, 4
    la $a0, invalid_choice
    syscall

    la $a0, try_again
    syscall

    j get_decimal_retry

get_decimal_input_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: validate_binary_input
# Purpose: Validates that input only contains 0s and 1s
# Input: $a0 = number to validate
# Output: $v0 = 1 if valid binary, 0 if invalid
validate_binary_input:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    move $s0, $a0       # Save input

    # Special case: 0 is valid
    beq $s0, $zero, valid_binary

    # Check each digit
validate_loop:
    beq $s0, $zero, valid_binary

    # Get last digit
    li $t1, 10
    div $s0, $t1
    mfhi $t2            # Remainder = last digit
    mflo $s0            # Quotient = remaining digits

    # Check if digit is 0 or 1
    beq $t2, $zero, digit_ok
    li $t3, 1
    beq $t2, $t3, digit_ok

    # Invalid digit found
    li $v0, 0
    j validate_binary_end

digit_ok:
    j validate_loop

valid_binary:
    li $v0, 1

validate_binary_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
