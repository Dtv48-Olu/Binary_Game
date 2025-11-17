# Olutoye Odufowokan
# Levels.asm
# Manages 10 levels with increasing difficulty (based on Cisco Binary Game)

.data
# Level configuration: max_number, time_limit (seconds), questions_per_level
# Format: Each level has 3 words: max_range, time_limit, questions_needed
level_data:
    # Level 1: 0-15 (4 bits), 60 seconds per question, 5 correct answers to advance
    .word 15, 60, 5
    
    # Level 2: 0-31 (5 bits), 50 seconds, 5 correct
    .word 31, 50, 5
    
    # Level 3: 0-63 (6 bits), 45 seconds, 5 correct
    .word 63, 45, 5
    
    # Level 4: 0-127 (7 bits), 40 seconds, 6 correct
    .word 127, 40, 6
    
    # Level 5: 0-255 (8 bits), 35 seconds, 6 correct
    .word 255, 35, 6
    
    # Level 6: 0-511 (9 bits), 30 seconds, 7 correct
    .word 511, 30, 7
    
    # Level 7: 0-1023 (10 bits), 25 seconds, 7 correct
    .word 1023, 25, 7
    
    # Level 8: 0-2047 (11 bits), 20 seconds, 8 correct
    .word 2047, 20, 8
    
    # Level 9: 0-4095 (12 bits), 15 seconds, 8 correct
    .word 4095, 15, 8
    
    # Level 10: 0-8191 (13 bits), 10 seconds, 10 correct
    .word 8191, 10, 10

# Level messages
level_intro: .asciiz "\n========== LEVEL "
level_intro2: .asciiz " ==========\n"
level_complete: .asciiz "\n*** LEVEL COMPLETE! ***\n"
level_advance: .asciiz "Advancing to next level...\n"
game_complete: .asciiz "\n***** CONGRATULATIONS! YOU BEAT ALL 10 LEVELS! *****\n"

# Statistics tracking
correct_in_level: .word 0    # Correct answers in current level
total_in_level: .word 0      # Total questions in current level

.text
.globl get_level_config
.globl display_level_intro
.globl check_level_complete
.globl advance_level
.globl reset_level_stats
.globl get_question_type

# Function: get_level_config
# Gets configuration for specified level
# Input: $a0 = level number (1-10)
# Output: $v0 = max_range, $v1 = time_limit
get_level_config:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    # Calculate offset: (level-1) * 12 bytes (3 words per level)
    addi $t0, $a0, -1       # level - 1
    li $t1, 12              # 3 words * 4 bytes
    mul $t0, $t0, $t1       # offset
    
    # Load level data
    la $t2, level_data
    add $t2, $t2, $t0       # Point to level data
    
    lw $v0, 0($t2)          # max_range
    lw $v1, 4($t2)          # time_limit

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Function: display_level_intro
# Shows level introduction with requirements
# Input: $a0 = level number
display_level_intro:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    move $s0, $a0           # Save level number
    
    # Print "========== LEVEL X =========="
    li $v0, 4
    la $a0, level_intro
    syscall
    
    li $v0, 1
    move $a0, $s0
    syscall
    
    li $v0, 4
    la $a0, level_intro2
    syscall
    
display_level_intro_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Function: check_level_complete
# Checks if player completed current level requirements
# Input: $a0 = level number, $a1 = correct answers so far
# Output: $v0 = 1 if level complete, 0 otherwise
check_level_complete:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    
    move $s0, $a0           # Save level number
    move $s1, $a1           # Save correct answers
    
    # Get required correct answers for this level
    addi $t0, $s0, -1       # level - 1
    li $t1, 12              # 3 words * 4 bytes
    mul $t0, $t0, $t1       # offset
    
    la $t2, level_data
    add $t2, $t2, $t0
    lw $t3, 8($t2)          # questions_needed
    
    # Check if player has enough correct answers
    bge $s1, $t3, level_is_complete
    
    # Not complete yet
    li $v0, 0
    j check_level_complete_end
    
level_is_complete:
    li $v0, 1
    
check_level_complete_end:
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# Function: advance_level
# Shows level complete message and advances to next level
advance_level:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Display level complete message
    li $v0, 4
    la $a0, level_complete
    syscall
    
    la $a0, level_advance
    syscall
    
    # Reset level statistics
    sw $zero, correct_in_level
    sw $zero, total_in_level
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: reset_level_stats
# Resets statistics for new level
reset_level_stats:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    sw $zero, correct_in_level
    sw $zero, total_in_level
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: get_question_type
# Randomly decides between decimal->binary or binary->decimal
# Output: $v0 = 0 for decimal->binary, 1 for binary->decimal
get_question_type:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Generate random 0 or 1
    li $v0, 42              # Random int
    li $a0, 0
    li $a1, 2               # Range 0-1
    syscall
    
    move $v0, $a0           # Return random type
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
