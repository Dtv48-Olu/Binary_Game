# Olutoye Odufowokan
# Validation_Check.asm
# Responsible for validating questions and checking user input conversions

.data
correct_msg: .asciiz "Correct! Good job!\n"
incorrect_msg: .asciiz "Incorrect! The correct answer was: "
newline: .asciiz "\n"
invalid_input_msg: .asciiz "Invalid input! Please enter a valid number.\n"

.text
.globl validate_question
.globl check_answer
.globl convert_decimal_to_binary
.globl convert_binary_to_decimal

# Function: validate_question
# Purpose: Ensures the generated question number is within valid range
# Input: $a0 = number to validate
#        $a1 = max_range (e.g., 15, 31, 63, etc.)
# Output: $v0 = 1 if valid, 0 if invalid
validate_question:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Check if number is negative
    blt $a0, $zero, invalid_question

    # Check if number exceeds max range
    bgt $a0, $a1, invalid_question

    # Valid question
    li $v0, 1
    j validate_question_end

invalid_question:
    li $v0, 0

validate_question_end:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: check_answer
# Purpose: Main function to check if user's answer is correct
# Input: $a0 = original number (what computer generated)
#        $a1 = user's answer (what player entered)
#        $a2 = question_type (0 = decimal->binary, 1 = binary->decimal)
# Output: $v0 = 1 if correct, 0 if incorrect
#         $v1 = correct answer (for display if wrong)
check_answer:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)

    move $s0, $a0       # Save original number
    move $s1, $a1       # Save user's answer
    move $s2, $a2       # Save question type

    # Check question type
    beq $s2, $zero, check_decimal_to_binary
    # Otherwise, check binary to decimal
    j check_binary_to_decimal_answer

check_decimal_to_binary:
    # Convert original decimal to binary
    move $a0, $s0
    jal convert_decimal_to_binary
    move $s3, $v0       # Correct binary answer

    # Compare with user's answer
    beq $s1, $s3, answer_correct

    # Answer is incorrect
    li $v0, 0
    move $v1, $s3       # Return correct answer
    j check_answer_end

check_binary_to_decimal_answer:
    # Convert binary to decimal
    move $a0, $s0
    jal convert_binary_to_decimal
    move $s3, $v0       # Correct decimal answer

    # Compare with user's answer
    beq $s1, $s3, answer_correct

    # Answer is incorrect
    li $v0, 0
    move $v1, $s3       # Return correct answer
    j check_answer_end

answer_correct:
    li $v0, 1
    move $v1, $s1       # Return the answer (same as input)

check_answer_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# Function: convert_decimal_to_binary
# Purpose: Converts a decimal number to binary (as an integer representation)
# Input: $a0 = decimal number
# Output: $v0 = binary representation as integer (e.g., 5 -> 101)
convert_decimal_to_binary:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $s0, $a0       # Save decimal number
    li $s1, 0           # Result (binary as integer)
    li $t0, 1           # Position multiplier (1, 10, 100, etc.)

    # Special case: if number is 0
    beq $s0, $zero, decimal_to_binary_zero

convert_loop:
    beq $s0, $zero, convert_decimal_done

    # Get remainder (bit value: 0 or 1)
    andi $t1, $s0, 1    # Get last bit (number % 2)

    # Add bit to result
    mul $t2, $t1, $t0   # bit * position
    add $s1, $s1, $t2   # Add to result

    # Shift number right (divide by 2)
    srl $s0, $s0, 1

    # Move to next position (multiply by 10)
    li $t3, 10
    mul $t0, $t0, $t3

    j convert_loop

decimal_to_binary_zero:
    li $s1, 0

convert_decimal_done:
    move $v0, $s1

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# Function: convert_binary_to_decimal
# Purpose: Converts a binary number (as integer) to decimal
# Input: $a0 = binary number as integer (e.g., 101 for binary 101)
# Output: $v0 = decimal number (e.g., 5)
convert_binary_to_decimal:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $s0, $a0       # Save binary number
    li $s1, 0           # Result (decimal)
    li $t0, 1           # Power of 2 (1, 2, 4, 8, etc.)

    # Special case: if number is 0
    beq $s0, $zero, binary_to_decimal_zero

binary_convert_loop:
    beq $s0, $zero, binary_convert_done

    # Get last digit
    li $t3, 10
    div $s0, $t3
    mfhi $t1            # Remainder = last digit (0 or 1)
    mflo $s0            # Quotient = remaining digits

    # Add to result if digit is 1
    beq $t1, $zero, skip_add
    add $s1, $s1, $t0   # Add current power of 2

skip_add:
    # Move to next power of 2
    sll $t0, $t0, 1     # Multiply by 2

    j binary_convert_loop

binary_to_decimal_zero:
    li $s1, 0

binary_convert_done:
    move $v0, $s1

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# Function: display_result
# Purpose: Displays whether answer was correct or incorrect
# Input: $a0 = is_correct (1 = correct, 0 = incorrect)
#        $a1 = correct_answer (only used if incorrect)
# Output: Prints result message
.globl display_result
display_result:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $s0, $a0       # Save is_correct
    move $s1, $a1       # Save correct answer

    beq $s0, $zero, display_incorrect

    # Display correct message
    li $v0, 4
    la $a0, correct_msg
    syscall
    j display_result_end

display_incorrect:
    # Display incorrect message
    li $v0, 4
    la $a0, incorrect_msg
    syscall

    # Display correct answer
    li $v0, 1
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

display_result_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra
