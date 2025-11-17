# Olutoye Odufowokan
# Timeout.asm
# Manages time limits for each question

.data
start_time: .word 0         # Store start time of current question
time_limit: .word 60        # Current time limit in seconds (default 60)
time_warning: .asciiz "\n Time Warning: 10 seconds left!\n"
time_up: .asciiz "\n TIME'S UP! Moving to next question...\n"
time_remaining_msg: .asciiz "Time remaining: "
seconds_msg: .asciiz " seconds\n"

.text
.globl start_timer
.globl check_timeout
.globl display_time_remaining
.globl set_time_limit

# Function: start_timer
# Purpose: Records the start time for a new question
# Input: None
# Output: None
start_timer:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # Get current system time
    li $v0, 30              # syscall 30 = get time
    syscall
    # $a0 = low order 32 bits of system time

    # Store start time
    sw $a0, start_time

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: check_timeout
# Purpose: Checks if time limit has been exceeded
# Input: None
# Output: $v0 = 1 if timeout, 0 if time remaining
check_timeout:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    # Get current time
    li $v0, 30
    syscall
    move $s0, $a0           # Current time

    # Get start time
    lw $s1, start_time

    # Calculate elapsed time (in milliseconds)
    sub $t0, $s0, $s1       # elapsed = current - start

    # Convert to seconds
    li $t1, 1000
    div $t0, $t1
    mflo $t0                # elapsed seconds

    # Get time limit
    lw $t1, time_limit

    # Check if time exceeded
    bge $t0, $t1, timeout_occurred

    # Check if warning needed (10 seconds left)
    sub $t2, $t1, $t0       # remaining = limit - elapsed
    li $t3, 10
    beq $t2, $t3, show_warning

    # No timeout
    li $v0, 0
    j check_timeout_end

show_warning:
    # Display warning but don't timeout yet
    li $v0, 4
    la $a0, time_warning
    syscall
    li $v0, 0
    j check_timeout_end

timeout_occurred:
    # Display timeout message
    li $v0, 4
    la $a0, time_up
    syscall
    li $v0, 1               # Return timeout = true

check_timeout_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# Function: display_time_remaining
# Purpose: Shows how much time is left
# Input: None
# Output: Prints time remaining
display_time_remaining:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    # Get current time
    li $v0, 30
    syscall
    move $s0, $a0

    # Get start time
    lw $s1, start_time

    # Calculate elapsed time
    sub $t0, $s0, $s1
    li $t1, 1000
    div $t0, $t1
    mflo $t0                # elapsed seconds

    # Calculate remaining time
    lw $t1, time_limit
    sub $t2, $t1, $t0       # remaining = limit - elapsed

    # Don't show negative time
    blez $t2, no_time_left

    # Display remaining time
    li $v0, 4
    la $a0, time_remaining_msg
    syscall

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 4
    la $a0, seconds_msg
    syscall
    j display_time_end

no_time_left:
    li $v0, 4
    la $a0, time_up
    syscall

display_time_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# Function: set_time_limit
# Purpose: Sets the time limit for questions
# Input: $a0 = time limit in seconds
# Output: None
set_time_limit:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    sw $a0, time_limit

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
