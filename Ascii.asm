# Olutoye Odufowokan
# Ascii.asm
# Responsible for displaying ASCII art, boxes, and GUI elements in MARS I/O

.data
# Box characters
star: .asciiz "*"
plus: .asciiz "+"
minus: .asciiz "-"
equals: .asciiz "="
pipe: .asciiz "|"
space: .asciiz " "
newline: .asciiz "\n"

# Pre-made box components (width of 50 characters)
top_border: .asciiz "+------------------------------------------------+\n"
bottom_border: .asciiz "+------------------------------------------------+\n"
separator_line: .asciiz "+================================================+\n"
thin_line: .asciiz "------------------------------------------------\n"
star_line: .asciiz "**************************************************\n"
empty_line: .asciiz "|                                                |\n"

# Title box
title_top: .asciiz "**************************************************\n"
title_mid1: .asciiz "*                                                *\n"
title_mid2: .asciiz "*          WELCOME TO THE BINARY GAME!           *\n"
title_mid3: .asciiz "*                                                *\n"
title_bottom: .asciiz "**************************************************\n"

# Level display template
level_box_top: .asciiz "+================================================+\n"
level_box_mid: .asciiz "|                   LEVEL "
level_box_end: .asciiz "                    |\n"
level_box_bottom: .asciiz "+================================================+\n"

# Score display
score_label: .asciiz "| Score: "
lives_label: .asciiz " | Lines: "
separator: .asciiz " |\n"

.text
.globl draw_title_box
.globl draw_top_border
.globl draw_bottom_border
.globl draw_separator
.globl draw_star_line
.globl draw_empty_line
.globl draw_level_box
.globl draw_score_line
.globl draw_custom_box

# Function: draw_title_box
# Purpose: Draws the welcome title box
# Input: None
# Output: Prints title box to console
draw_title_box:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    la $a0, title_top
    syscall

    la $a0, title_mid1
    syscall

    la $a0, title_mid2
    syscall

    la $a0, title_mid3
    syscall

    la $a0, title_bottom
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: draw_top_border
# Purpose: Draws top border of a box
# Input: None
# Output: Prints "+--------...--------+\n"
draw_top_border:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    la $a0, top_border
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: draw_bottom_border
# Purpose: Draws bottom border of a box
# Input: None
# Output: Prints "+--------...--------+\n"
draw_bottom_border:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    la $a0, bottom_border
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: draw_separator
# Purpose: Draws a separator line with equals signs
# Input: None
# Output: Prints "+========...========+\n"
draw_separator:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    la $a0, separator_line
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: draw_star_line
# Purpose: Draws a line of stars
# Input: None
# Output: Prints "**********...**********\n"
draw_star_line:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    la $a0, star_line
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: draw_empty_line
# Purpose: Draws an empty line within a box
# Input: None
# Output: Prints "|                    |\n"
draw_empty_line:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 4
    la $a0, empty_line
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Function: draw_level_box
# Purpose: Draws a box displaying the current level
# Input: $a0 = level number (1-10)
# Output: Prints level box
draw_level_box:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    move $s0, $a0       # Save level number

    # Draw top
    li $v0, 4
    la $a0, level_box_top
    syscall

    # Draw middle with level number
    la $a0, level_box_mid
    syscall

    li $v0, 1
    move $a0, $s0
    syscall

    li $v0, 4
    la $a0, level_box_end
    syscall

    # Draw bottom
    la $a0, level_box_bottom
    syscall

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Function: draw_score_line
# Purpose: Draws a line showing score and lines displayed
# Input: $a0 = score, $a1 = lines displayed
# Output: Prints "| Score: X | Lines: Y |"
draw_score_line:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $s0, $a0       # Save score
    move $s1, $a1       # Save lines

    # Print "| Score: "
    li $v0, 4
    la $a0, score_label
    syscall

    # Print score number
    li $v0, 1
    move $a0, $s0
    syscall

    # Print " | Lines: "
    li $v0, 4
    la $a0, lives_label
    syscall

    # Print lines number
    li $v0, 1
    move $a0, $s1
    syscall

    # Print "/7 |"
    li $v0, 11
    li $a0, '/'
    syscall

    li $v0, 1
    li $a0, 7
    syscall

    li $v0, 4
    la $a0, separator
    syscall

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# Function: draw_custom_box
# Purpose: Draws a custom box with specified width using stars
# Input: $a0 = width (number of characters)
# Output: Prints a box
draw_custom_box:
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $s0, $a0       # Save width
    li $s1, 0           # Counter

    # Draw top line of stars
draw_custom_top:
    bge $s1, $s0, draw_custom_top_done
    li $v0, 4
    la $a0, star
    syscall
    addi $s1, $s1, 1
    j draw_custom_top

draw_custom_top_done:
    li $v0, 4
    la $a0, newline
    syscall

    # Draw bottom line of stars
    li $s1, 0
draw_custom_bottom:
    bge $s1, $s0, draw_custom_bottom_done
    li $v0, 4
    la $a0, star
    syscall
    addi $s1, $s1, 1
    j draw_custom_bottom

draw_custom_bottom_done:
    li $v0, 4
    la $a0, newline
    syscall

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra
