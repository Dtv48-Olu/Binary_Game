# Olutoye Odufowokan
# Computer.asm
# Responsible for generating random numbers that the player will need to convert

.data
computer_label: .asciiz "Computer: "
decimal_prompt: .asciiz "Convert this decimal to binary: "
binary_prompt: .asciiz "Convert this binary to decimal: "
newline: .asciiz "\n"

.text
.globl generate_random_number
.globl display_question

# Function: generate_random_number
# Purpose: Generates a random number based on current level
# Input: $a0 = max_range (e.g., 15 for level 1, 31 for level 2, etc.)
# Output: $v0 = random number generated
# Modifies: $v0, $a0, $a1
generate_random_number:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Generate random number using system call
    # syscall 42 generates random int in range
    li $v0, 42          # syscall 42 = random int range
    li $a1, 0           # lower bound = 0
    move $a1, $a0       # upper bound = max_range passed in
    syscall
    # Result is in $a0

    move $v0, $a0       # Return random number in $v0

    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: display_question
# Purpose: Displays the question to the player (either decimal->binary or binary->decimal)
# Input: $a0 = number to display
#        $a1 = question_type (0 = decimal to binary, 1 = binary to decimal)
# Output: Prints the question
# Modifies: $v0, $a0
display_question:
    # Save registers
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)      # Save number
    sw $s1, 8($sp)      # Save question type

    move $s0, $a0       # Save number
    move $s1, $a1       # Save question type

    # Print "Computer: "
    li $v0, 4
    la $a0, computer_label
    syscall

    # Check question type
    beq $s1, $zero, display_decimal
    # Otherwise, display binary
    j display_binary_question

display_decimal:
    # Print "Convert this decimal to binary: "
    li $v0, 4
    la $a0, decimal_prompt
    syscall

    # Print the decimal number
    li $v0, 1
    move $a0, $s0
    syscall

    j display_question_end

display_binary_question:
    # Print "Convert this binary to decimal: "
    li $v0, 4
    la $a0, binary_prompt
    syscall

    # Print the number as binary (convert decimal to binary string)
    move $a0, $s0
    jal print_binary

display_question_end:
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall

    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# Function: print_binary
# Purpose: Prints a number in binary format
# Input: $a0 = number to print in binary
# Output: Prints the binary representation
# Modifies: $v0, $a0, $t0-$t3
print_binary:
    # Save registers
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    move $s0, $a0       # Save number

    # Count significant bits (find highest bit set)
    li $t0, 0           # bit counter
    move $t1, $s0       # copy of number

    beq $t1, $zero, print_zero  # If number is 0, print "0"

count_bits:
    beq $t1, $zero, start_print
    srl $t1, $t1, 1     # Shift right
    addi $t0, $t0, 1    # Increment bit count
    j count_bits

start_print:
    # Print bits from left to right
    addi $t0, $t0, -1   # Adjust to actual bit position

print_bit_loop:
    blt $t0, $zero, print_binary_end

    # Extract bit at position $t0
    li $t2, 1
    sllv $t2, $t2, $t0  # Create mask: 1 << position
    and $t3, $s0, $t2   # Get the bit

    # Print '1' or '0'
    beq $t3, $zero, print_0

print_1:
    li $v0, 11          # Print character
    li $a0, '1'
    syscall
    j next_bit

print_0:
    li $v0, 11
    li $a0, '0'
    syscall

next_bit:
    addi $t0, $t0, -1
    j print_bit_loop

print_zero:
    li $v0, 11
    li $a0, '0'
    syscall

print_binary_end:
    # Restore registers
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
