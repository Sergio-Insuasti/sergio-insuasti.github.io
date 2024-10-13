########################################################################
# COMP1521 24T2 -- Assignment 1 -- Breakout!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/24T2/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by SERGIO INSUASTI (z5338374)
# on TUESDAY JUNE 11 - FRIDAY JUNE 28
#
# Version 1.0 (2024-06-11): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
########################################################################

#![tabsize(8)]

# ##########################################################
# ####################### Constants ########################
# ##########################################################

# C constants
FALSE = 0
TRUE  = 1

MAX_GRID_WIDTH = 60
MIN_GRID_WIDTH = 6
GRID_HEIGHT    = 12

BRICK_ROW_START = 2
BRICK_ROW_END   = 7
BRICK_WIDTH     = 3
PADDLE_WIDTH    = 6
PADDLE_ROW      = GRID_HEIGHT - 1

BALL_FRACTION  = 24
BALL_SIM_STEPS = 3
MAX_BALLS      = 3
BALL_NONE      = 'X'
BALL_NORMAL    = 'N'
BALL_SUPER     = 'S'

VERTICAL       = 0
HORIZONTAL     = 1

MAX_SCREEN_UPDATES = 24

KEY_LEFT        = 'a'
KEY_RIGHT       = 'd'
KEY_SUPER_LEFT  = 'A'
KEY_SUPER_RIGHT = 'D'
KEY_STEP        = '.'
KEY_BIG_STEP    = ';'
KEY_SMALL_STEP  = ','
KEY_DEBUG_INFO  = '?'
KEY_SCREEN_UPD  = 's'
KEY_HELP        = 'h'

# NULL is defined in <stdlib.h>
NULL  = 0

# Other useful constants
SIZEOF_CHAR = 1
SIZEOF_INT  = 4

BALL_X_OFFSET      = 0
BALL_Y_OFFSET      = 4
BALL_X_FRAC_OFFSET = 8
BALL_Y_FRAC_OFFSET = 12
BALL_DX_OFFSET     = 16
BALL_DY_OFFSET     = 20
BALL_STATE_OFFSET  = 24
# <implicit 3 bytes of padding>
SIZEOF_BALL = 28

SCREEN_UPDATE_X_OFFSET = 0
SCREEN_UPDATE_Y_OFFSET = 4
SIZEOF_SCREEN_UPDATE   = 8

MANY_BALL_CHAR = '#'
ONE_BALL_CHAR  = '*'
PADDLE_CHAR    = '-'
EMPTY_CHAR     = ' '
GRID_TOP_CHAR  = '='
GRID_SIDE_CHAR = '|'

	.data
# ##########################################################
# #################### Global variables ####################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE DEFINITIONS !!!

grid_width:			# int grid_width;
	.word	0

balls:				# struct ball balls[MAX_BALLS];
	.byte	0:MAX_BALLS*SIZEOF_BALL

bricks:				# char bricks[GRID_HEIGHT][MAX_GRID_WIDTH];
	.byte	0:GRID_HEIGHT*MAX_GRID_WIDTH

bricks_destroyed:		# int bricks_destroyed;
	.word	0

total_bricks:			# int total_bricks;
	.word	0

paddle_x:			# int paddle_x;
	.word	0

score:				# int score;
	.word	0

combo_bonus:			# int combo_bonus;
	.word	0

screen_updates:			# struct screen_update screen_updates[MAX_SCREEN_UPDATES];
	.byte	0:MAX_SCREEN_UPDATES*SIZEOF_SCREEN_UPDATE

num_screen_updates:		# int num_screen_updates;
	.word	0

whole_screen_update_needed:	# int whole_screen_update_needed;
	.word	0

no_auto_print:			# int no_auto_print;
	.word	0


# ##########################################################
# ######################### Strings ########################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE STRINGS !!!

str_print_welcome_1:
	.asciiz	"Welcome to 1521 breakout! In this game you control a "
str_print_welcome_2:
	.asciiz	"paddle (---) with\nthe "
str_print_welcome_3:	# note: this string is used twice
	.asciiz	" and "
str_print_welcome_4:
	.asciiz	" (or "
str_print_welcome_5:
	.asciiz	" for fast "
str_print_welcome_6:
	.asciiz	"movement) keys, and your goal is\nto bounce the ball ("
str_print_welcome_7:
	.asciiz	") off of the bricks (digits). Every ten "
str_print_welcome_8:
	.asciiz	"bricks\ndestroyed spawns an extra ball. The "
str_print_welcome_9:
	.asciiz	" key will advance time one step.\n\n"

str_read_grid_width_prompt:
	.asciiz	"Enter the width of the playing field: "
str_read_grid_width_out_of_bounds_1:
	.asciiz	"Bad input, the width must be between "
str_read_grid_width_out_of_bounds_2:
	.asciiz	" and "
str_read_grid_width_not_multiple:
	.asciiz	"Bad input, the grid width must be a multiple of "

str_game_loop_win:
	.asciiz	"\nYou win! Congratulations!\n"
str_game_loop_game_over:
	.asciiz	"Game over :(\n"
str_game_loop_final_score:
	.asciiz	"Final score: "

str_print_game_score:
	.asciiz	" SCORE: "

str_hit_brick_bonus_ball:
	.asciiz	"\n!! Bonus ball !!\n"

str_run_command_prompt:
	.asciiz	" >> "
str_run_command_bad_cmd_1:
	.asciiz	"Bad command: '"
str_run_command_bad_cmd_2:
	.asciiz	"'. Run `h` for help.\n"

str_print_debug_info_1:
	.asciiz	"      grid_width = "
str_print_debug_info_2:
	.asciiz	"        paddle_x = "
str_print_debug_info_3:
	.asciiz	"bricks_destroyed = "
str_print_debug_info_4:
	.asciiz	"    total_bricks = "
str_print_debug_info_5:
	.asciiz	"           score = "
str_print_debug_info_6:
	.asciiz	"     combo_bonus = "
str_print_debug_info_7:
	.asciiz	"        num_screen_updates = "
str_print_debug_info_8:
	.asciiz	"whole_screen_update_needed = "
str_print_debug_info_9:
	.asciiz	"ball["
str_print_debug_info_10:
	.asciiz	"  y: "
str_print_debug_info_11:
	.asciiz	", x: "
str_print_debug_info_12:
	.asciiz	"  x_fraction: "
str_print_debug_info_13:
	.asciiz	"  y_fraction: "
str_print_debug_info_14:
	.asciiz	"  dy: "
str_print_debug_info_15:
	.asciiz	", dx: "
str_print_debug_info_16:
	.asciiz	"  state: "
str_print_debug_info_17:
	.asciiz	" ("
str_print_debug_info_18:
	.asciiz	")\n"
str_print_debug_info_19:
	.asciiz	"\nbricks["
str_print_debug_info_20:
	.asciiz	"]: "
str_print_debug_info_21:
	.asciiz	"]:\n"

# !!! Reminder to not not add to or modify any of the above !!!
# !!! strings or any other part of the data segment.        !!!
# !!! If you add more strings you will likely break the     !!!
# !!! autotests and automarking.                            !!!


############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

################################################################################
#
# Implement the following functions,
# and check these boxes as you finish implementing each function.
#
#  SUBSET 0
#  - [X] print_welcome
#  - [X] main
#  SUBSET 1
#  - [X] read_grid_width
#  - [X] game_loop
#  - [X] initialise_game
#  - [X] move_paddle
#  - [X] count_total_active_balls
#  - [X] print_cell
#  SUBSET 2
#  - [X] register_screen_update
#  - [X] count_balls_at_coordinate
#  - [X] print_game
#  - [X] spawn_new_ball
#  - [X] move_balls
#  SUBSET 3
#  - [X] move_ball_in_axis
#  - [X] hit_brick
#  - [X] check_ball_paddle_collision
#  - [X] move_ball_one_cell
#  PROVIDED
#  - [X] print_debug_info
#  - [X] run_command
#  - [X] print_screen_updates


################################################################################
# .TEXT <print_welcome>
        .text
print_welcome:
	# Subset:   0
	#
	# Frame:    [$ra]   
	# Uses:     [$a0, $v0]
	# Clobbers: [$a0, $v0]
	#
	# Locals:
	#   - None
	#
	# Structure:
	#   print_welcome
	#   -> [prologue]
	#       -> body
	#		-> print strings in structure of breakout.simple.c
	#   -> [epilogue]
	#	-> jr $ra to main

print_welcome__prologue:
	begin
print_welcome__body:
	li	$v0, 4
	la	$a0, str_print_welcome_1	#  printf("Welcome to 1521 breakout! In this game you control a ");					
	syscall

	li	$v0, 4
	la	$a0, str_print_welcome_2	#  printf("paddle (---) with\nthe"); 
	syscall

	li	$v0, 11
	li	$a0, KEY_LEFT			#  printf("%c", KEY_LEFT);
	syscall

	li	$v0, 4
	la	$a0, str_print_welcome_3	#  printf("and"); 
	 					
	syscall

	li	$v0, 11		
	li	$a0, KEY_RIGHT			#  printf("%c", KEY_RIGHT);
	syscall

	li	$v0, 4
	la	$a0, str_print_welcome_4	#  printf(" (or");
	syscall

	li	$v0, 11
	li	$a0, KEY_SUPER_LEFT		#  printf("%c", KEY_SUPER_LEFT);
	syscall

	li	$v0, 4
	la	$a0, str_print_welcome_3	#  and 
	syscall

	li	$v0, 11		
	li	$a0, KEY_SUPER_RIGHT		#  printf("%c", KEY_SUPER_RIGHT);
	syscall

	li	$v0, 4
	la	$a0, str_print_welcome_5	#  printf("for fast ")
	syscall

	li	$v0, 4
	la	$a0, str_print_welcome_6	#  printf("movement) keys, and your goal is\nto bounce the ball (");
	syscall

	li	$v0, 11
	li	$a0, ONE_BALL_CHAR		#  printf("%c", ONE_BALL_CHAR);
	syscall

	li	$v0, 4
	la	$a0, str_print_welcome_7	#  printf(") off of the bricks (digits). Every ten ";
	syscall

	li	$v0, 4
	la	$a0, str_print_welcome_8	#  printf("bricks\ndestroyed spawns an extra ball. The");
	syscall

	li	$v0, 11
	li	$a0, KEY_STEP			#  printf("%c", KEY_STEP);
	syscall

	li	$v0, 4
	la	$a0, str_print_welcome_9	#  printf(" key will advance time one step.\n\n");
	syscall
print_welcome__epilogue:
	end
	jr	$ra	 



################################################################################
# .TEXT <main>
        .text
main:
	# Subset:   0
	#
	# Frame:    [$ra]  
	# Uses:     [$v0]
	# Clobbers: [$v0]
	#
	# Locals:
	#   - None
	#
	# Structure:
	#   main
	#   -> [prologue]
	#	-> save $ra
	#       -> body
	#		-> jal print_welcome
	#		-> jal read_grid_width
	#		-> jal initialise_game
	#		-> jal game_loop
	#   -> [epilogue]
	#		-> restore $ra
	#		-> return	

main__prologue:
	begin
	push	$ra
main__body:
	jal	print_welcome			#  print_welcome();
	jal	read_grid_width			#  read_grid_width();
	jal	initialise_game			#  initialise_game();
	jal	game_loop			#  game_loop();
main__epilogue:
	pop	$ra
	end
	li	$v0, 0				#  return 0;
	jr	$ra


################################################################################
# .TEXT <read_grid_width>
        .text
read_grid_width:
	# Subset:   1
	#
	# Frame:    [$ra]  
	# Uses:     [$a0, $t0, $v0]
	# Clobbers: [$a0, $t0, $v0]
	#
	# Locals:           
	#   - $t0: grid_width % BRICK_WIDTH
	#   - $v0: grid_width
	#
	# Structure:        
	#   read_grid_width
	#   -> [prologue]
	#       -> body
	#		-> read_grid_width__scan:
	#			-> read_grid_width_cond_low_bound: 
	#			-> read_grid_width_cond_upper_bound: 
	#			-> read_grid_width_cond_div_by_brick_width: 
	#			-> read_grid_width_out_of_bounds:
	#			-> read_grid_width_not_multiple:
	#			-> loop back to body: if unsuccessful
	#   -> [epilogue]
	#		-> putchar(\n)
	#		-> return

read_grid_width__prologue:
	begin
read_grid_width__body:

read_grid_width__scan:
	li	$v0, 4
	la	$a0, str_read_grid_width_prompt				#  printf("Enter the width of the playing field: ");
	syscall

	li	$v0, 5
	syscall
	sw	$v0, grid_width						#  scanf("%d", &grid_width);
	
read_grid_width_cond_low_bound:
	blt	$v0, MIN_GRID_WIDTH, read_grid_width_out_of_bounds	#  if (grid_width < MIN_GRID_WIDTH) goto

read_grid_width_cond_upper_bound:
	bgt	$v0, MAX_GRID_WIDTH, read_grid_width_out_of_bounds	#  if (grid_width > MAX_GRID_WIDTH) goto

read_grid_width_cond_div_by_brick_width:
	rem	$t0, $v0, BRICK_WIDTH					#  else if (grid_width % BRICK_WIDTH != 0) 
	bnez	$t0, read_grid_width_not_multiple			#  goto read_grid_width_not_multiple
	b	read_grid_width__epilogue				#  else goto read_grid_width__epilogue

read_grid_width_out_of_bounds:
	li	$v0, 4
	la	$a0, str_read_grid_width_out_of_bounds_1		#  printf("Bad input, the width must be between");
	syscall

	li	$v0, 1
	la	$a0, MIN_GRID_WIDTH					#  printf("%d", MIN_GRID_WIDTH);
	syscall

	li	$v0, 4
	la	$a0, str_read_grid_width_out_of_bounds_2		#  printf(" and ");
	syscall

	li	$v0, 1
	la	$a0, MAX_GRID_WIDTH					#  printf("%d", MAX_GRID_WIDTH);
	syscall

	li	$v0, 11
	li	$a0, '\n'						#  printf("\n");
	syscall

	b	read_grid_width__scan					#  goto read_grid_width__body

read_grid_width_not_multiple:
	li	$v0, 4					
	la	$a0, str_read_grid_width_not_multiple			#  printf(
									#  "Bad input, the grid width must be a multiple of"
									#  );
	syscall

	li	$v0, 1
	la	$a0, BRICK_WIDTH					#  printf("%d", BRICK_WIDTH);
	syscall

	li	$v0, 11
	li	$a0, '\n'						#  printf("\n");
	syscall

	b	read_grid_width__scan					#  goto read_grid_width__body

read_grid_width__epilogue:
	
	li	$v0, 11
	li	$a0, '\n'						#  putchar('\n');
	syscall

	end
	li	$v0, 0							#  return 0;
	jr	$ra


################################################################################
# .TEXT <game_loop>
        .text
game_loop:
	# Subset:   1
	#
	# Frame:    [$ra, $s0, $s1, $s2]   
	# Uses:     [$ra, $s0, $s1, $s2]
	# Clobbers: [$t0, $t1, t2, $t3, $t4, $v0, $a0, $a1]
	#
	# Locals:           
	#   - $s0: bricks destroyed
	#   - $s1: total_bricks
	#   - $s2: count_total_active_balls result
	#
	# Structure:        
	#   game_loop
	#   -> [prologue]
	#       -> body
	#		->game_loop_loop_condition
	#			->game_loop__no_auto_print_if
	#				->game_loop__no_auto_print_eq_zero
	#				->game_loop__no_auto_print_eq_zero_false
	#			->game_loop_run_command_loop_cond
	#		->game_loop_run_commmand_loop_end
	#		->game_loop__loop_end
	#		->game_loop__win_print
	#		->game_loop_game_over
	#		->game_loop_final_score
	#   -> [epilogue]

game_loop__prologue:
	begin
	push	$ra       				# Save return address
	push	$s0        				# Save $s0
	push	$s1        				# Save $s1
	push	$s2        				# Save $s2

game_loop__body:
game_loop_loop_condition:

	la	$t0, bricks_destroyed			#  int bricks_destroyed;
	lw	$s0, 0($t0)
	la	$t1, total_bricks			#  int total_bricks;
	lw	$s1, 0($t1)


	bge	$s0, $s1, game_loop__loop_end		#  if (bricks_destroyed >= total_bricks) goto 
							#  game_loop__loop_end;

	jal	count_total_active_balls		#  count_total_active_balls();
	move	$s2, $v0				#  int balls = return of ^^
	blez	$s2, game_loop__loop_end		#  if (balls <= 0) goto game_loop__loop_end ;

game_loop__no_auto_print_if:

	la	$t3, no_auto_print			#  int no_auto_print;
	lw	$t3, 0($t3)			
	bnez	$t3, game_loop__no_auto_print_eq_zero_false		
							#  if (no_auto_print == 0) goto
							#  game_loop_print_game;
game_loop__no_auto_print_eq_zero:
	jal	print_game				#  print_game();

game_loop__no_auto_print_eq_zero_false:

game_loop_run_command_loop_cond:

	jal	run_command				#  run_command();
	move	$t4, $v0				#  int run_command = return run_command();
	
	bnez	$t4 ,game_loop_run_commmand_loop_end	#  if (run_command != 0) goto game_loop_loop_condition;
	b	game_loop_run_command_loop_cond		#  else goto game_loop_run_command;

game_loop_run_commmand_loop_end:
	b 	game_loop_loop_condition

game_loop__loop_end:

	bne	$s0, $s1, game_loop_game_over		#  if (bricks_destroyed != total_bricks) 
							#  goto game_loop_game_over;

game_loop__win_print:
	li	$v0, 4
	la	$a0, str_game_loop_win			#  printf("\nYou win! Congratulations!\n");
	syscall

	b	game_loop_final_score			#  goto game_loop_final_score;

game_loop_game_over:
	li	$v0, 4
	la	$a0, str_game_loop_game_over		#  printf("Game over :(\n");
	syscall


game_loop_final_score:
	li	$v0, 4	
	la	$a0, str_game_loop_final_score		#  printf("Final score: ");
	syscall

	li	$v0, 1
	lw	$a0, score				#  printf("%d", score);
	syscall

game_loop__epilogue:

	li	$v0, 11
	la	$a0, '\n'				#  printf("\n");
	syscall

	pop	$s2        				#  Restore $s2
	pop	$s1        				#  Restore $s1
	pop	$s0        				#  Restore $s0
	pop	$ra        				#  Restore return address

	end
	li	$v0, 0					#  return 0;
	jr	$ra


################################################################################
# .TEXT <initialise_game>
        .text
initialise_game:
	# Subset:   1
	#
	# Frame:    [$ra]  
	# Uses:     [$ra, $t0..9, $v0]
	# Clobbers: [$t0..9, $v0]
	#
	# Locals:          
	#   - $t0 = row
	#   - $t1 = col
	#   - $t7 = &bricks[row][col]	
	#
	# Structure:       
	#   initialise_game
	#   -> [prologue]
	#       -> body
	#		-> initialise_game_body_print_bricks_array:
	#			-> initialise_game__array_row_condition
	#			-> initialise_game__array_col_condition
	#			-> initialise_game__array_bricks_condition
	#			-> initialise_game__array_brick_maths
	#			-> initialise_game__array_if_condition
	#			-> initialise_game__array_else_condition
	#			-> initialise_game__array_increment_col
	#			-> initialise_game__array_increment_row
	#		-> initialise_game__spawn_balls
	#			-> initialise_game__spawn_balls_loop_cond
	#			-> initialise_game__spawn_balls_loop
	#			-> initialise_game__spawn_balls_new_ball_function
	#		-> initialise_game__spawn_paddle
	#		-> initialise_game__initialise_variables
	#		-> initialise_game__whole_grid_print
	#   -> [epilogue]

initialise_game__prologue:
	begin
	push	$ra

initialise_game__body:
	li	$t0, 0						#  int row = 0;	

initialise_game_body_print_bricks_array:

initialise_game__array_row_condition:
								
	li	$t1, GRID_HEIGHT				#  load $t1 with constant

	beq	$t0, $t1, initialise_game__spawn_balls		#  if (row == GRID_HEIGHT) goto spawn_balls;

	li	$t2, 0						#  int col = 0;

initialise_game__array_col_condition:
	lw	$t3, grid_width					#  load $t1 with grid_width
	bge	$t2, $t3, initialise_game__array_increment_row	#  if (col >= grid_width) goto array_row_condition;

initialise_game__array_bricks_condition:

	li	$t4, BRICK_ROW_START				#  load BRICK_ROW_START
	li	$t5, BRICK_ROW_END				#  load BRICK_ROW_END
	li	$t6, BRICK_WIDTH				#  load BRICK_WIDTH

initialise_game__body_brick_maths:

	li	$t8, MAX_GRID_WIDTH				#  read grid_width in new register
	mul	$t8, $t0, $t8					#  $t8 = row * grid_width
	add	$t8, $t8, $t2					#  $t8 = (row * grid_width) + col

	la	$t9, bricks					#  load address of bricks array
	add	$t9, $t9, $t8					#  add offset of array to bricks

	blt	$t0, $t4, initialise_game_array_else_condition	#  if (row < BRICK_ROW_START) goto array_else;
	bgt	$t0, $t5, initialise_game_array_else_condition	#  if (row > BRICK_ROW_END) goto array_else;

	
initialise_game_array_if_condition:

	div	$t7, $t2, $t6					#  $t7 = col / BRICK_WIDTH
	rem	$t7, $t7, 10					#  $t7 % 10
	addi	$t7, $t7, 1					#  1 + $t7


	sb	$t7, ($t9)					#  store offset in address of $t9

	j	initialise_game__array_increment_col		#  jump to col++


initialise_game_array_else_condition:

	li	$t7, 0						#  reset brick bounds
	sb	$t7, ($t9)					#  store offset in address of $t9


initialise_game__array_increment_col:

	addi	$t2, $t2, 1					#  col++;
	j	initialise_game__array_col_condition		#  return to col loop

initialise_game__array_increment_row:

	addi	$t0, $t0, 1					#  row++;
	j	initialise_game__array_row_condition		#  return to top of loop



initialise_game__spawn_balls:

	li	$t0, 0						#  re-initalise for new print
	la	$t1, MAX_BALLS					#  load MAX_BALLS

initialise_game__spawn_balls_loop_cond:

	beq	$t0, $t1, initialise_game__spawn_new_ball_function	#  if (i == MAX_BALLS) goto init spawn_paddle

initialise_game__spawn_balls_loop:

	mul	$t2, $t0, SIZEOF_BALL				#  $t2 = index * sizeof_element
	la	$t3, balls					#  &balls
	add	$t2, $t2, $t3					#  col = col + index * sizeof_element
	li	$t4, BALL_NONE 
	sb	$t4, BALL_STATE_OFFSET($t2)			#  ball[i].state = BALL_NONE


	add	$t0, $t0, 1					#  i++;
	j 	initialise_game__spawn_balls_loop_cond

initialise_game__spawn_new_ball_function:

	jal	spawn_new_ball					#  spawn_new_ball();

initialise_game__spawn_paddle:

	li	$t0, PADDLE_WIDTH				#  $t0 = PADDLE_WIDTH
	lw	$t1, grid_width					#  $t1 = grid_width
	sub	$t0, $t1, $t0					#  $t0 = grid_width - $t0
	addi	$t0, $t0, 1					

	div	$t0, $t0, 2					#  $t0 = $t0 / 2 

	sw	$t0, paddle_x					#  store $t0 in paddle_x


initialise_game__initialise_variables:

	li	$t0, 0
	sw	$t0, score					#  score = 0;

	li	$t1, 0
	sw	$t0, bricks_destroyed				#  bricks_destroyed = 0;

	li	$t4, BRICK_ROW_START				#  load BRICK_ROW_START
	li	$t5, BRICK_ROW_END				#  load BRICK_ROW_END
	li	$t6, BRICK_WIDTH

	lw	$t2, grid_width					#  $t4 and $t5 remain BRICK_ROW_END and BRICK_ROW_START
	sub	$t0, $t5, $t4					#  $t0 = BRICK_ROW_END - BRICK_ROW_START
	add	$t0, $t0, 1					#  $t0 = $t0 + 1
	div	$t1, $t2, $t6					#  $t1 = grid_widt * BRICK_WIDTH
	mul	$t3, $t0, $t1					#  $t3 = $t0 * $t1

	sw	$t3, total_bricks				#  total_bricks = $t3

initialise_game__whole_grid_print:

	li	$t0, 0
	sw	$t0, num_screen_updates				#  num_screen_updates = 0;

	li	$t2, TRUE
	sw	$t2, whole_screen_update_needed			#  whole_screen_update_needed = TRUE;

	li	$t0, 0
	sw	$t0, no_auto_print				#  no_auto_print = 0;

initialise_game__epilogue:
	pop	$ra
	end
	li	$v0, 0						#  return 0;
	jr	$ra


################################################################################
# .TEXT <move_paddle>
        .text
move_paddle:
	# Subset:   1
	#
	# Frame:    [$ra, $s0, $s1]   
	# Uses:     [$s0, $s1, $t0, $t1, $t2, $a0, $a1]
	# Clobbers: [$t0, $t1, $t2, $a0]
	#
	# Locals:          
	#   -	$t0 = paddle_x
	#   -   $t1 = PADDLE_WIDTH
	#   -	$t2 = grid_width
	#   -	$s0 = direction
	#   -   $
	# Structure:        
	#   move_paddle
	#   -> [prologue]
	#       -> body
	#		-> move_paddle__out_of_bounds_check_a:
	#		-> move_paddle__out_of_bounds_check_b:
	#			-> move_paddle__out_of_bounds_true:
	#			-> move_paddle__out_of_bounds_false:
	#		-> move_paddle__out_of_bounds_phi:
	#   -> [epilogue]

move_paddle__prologue:
	begin
	push	$ra					#  hold the return address
	push	$s0					#  initiate saved registers

move_paddle__body:

	move	$s0, $a0 				# int direction -> argument
	lw	$t0, paddle_x				# load value of paddle_x
	add	$t0, $t0, $s0
	sw	$t0, paddle_x				# paddle_x += direction

move_paddle__out_of_bounds_check_a:

	bltz	$t0, move_paddle__out_of_bounds_true	# if (paddle_x < 0) goto move_paddle__out_of_bounds_true

move_paddle__out_of_bounds_check_b:

	li	$t1, PADDLE_WIDTH
	add	$t0, $t0, $t1				#  paddle_x + PADDLE_WIDTH

	lw	$t2, grid_width

	bgt	$t0, $t2, move_paddle__out_of_bounds_true	#  if (paddle_x + PADDLE_WIDTH > grid_width) 
								#  goto move_paddle__out_of_bounds_true

	b	move_paddle__out_of_bounds_false	#  else goto move_paddle__out_of_bounds_false

move_paddle__out_of_bounds_true:

	lw	$t0, paddle_x				#  load value of paddle_x
	sub	$t0, $t0, $s0				#  paddle_x -= direction
	sw	$t0, paddle_x				#  store paddle_x -= direction

	b	move_paddle__out_of_bounds_phi		#  goto move_paddle__out_of_bounds_phi


move_paddle__out_of_bounds_false:

	jal	check_ball_paddle_collision		#  check_ball_paddle_collision();

	add	$s0, $s0, 2				#  (direction + 2)
	div	$s0, $s0, 2				#  (direction + 2) / 2

	lw	$t0, paddle_x				
	sub	$a0, $t0, $s0				#  paddle_x - direction_indicator
	
	li	$a1, PADDLE_ROW				

	jal	register_screen_update			#  register_screen_update(paddle_x - direction_indicator, PADDLE_ROW);

	lw	$t0, paddle_x
	add	$t0, $t0, PADDLE_WIDTH			#  paddle_x + PADDLE_WIDTH
	sub	$a0, $t0, $s0				#  paddle_x + PADDLE_WIDTH - direction_indicator
	li	$a1, PADDLE_ROW			

	jal	register_screen_update			#  register_screen_update(
							#  	(paddle_x + PADDLE_WIDTH - direction_indicator), PADDLE_ROW
							#  );

move_paddle__out_of_bounds_phi:


move_paddle__epilogue:
	pop	$s0					#  pop return address and saved register from stack
	pop	$ra
	end
	jr	$ra					#  return void;

################################################################################
# .TEXT <count_total_active_balls>
        .text
count_total_active_balls:
	# Subset:   1
	#
	# Frame:    [$ra]  
	# Uses:     [$t0..5]
	# Clobbers: [$t3, $t4]
	#
	# Locals:           
	#   - $t0 = count
	#   - $t1 = i
	#   - $t2 = MAX_BALLS
	#   - $t3 = i + SIZEOF_BALL
	#   - $t4 = &balls
	#   - $t5 = balls[i].state
	#
	# Structure:       
	#   count_total_active_balls
	#   -> [prologue]
	#       -> body
	#       	-> count_total_active_balls__init
	#       	-> count_total_active_balls__cond
	#       	-> count_total_active_balls__step
	#       	-> count_total_active_balls__state_not_none
	#       	-> count_total_active_balls__state_is_none
	#       	-> count_total_active_balls__false
	#
	#   -> [epilogue]

count_total_active_balls__prologue:
	begin
count_total_active_balls__body:

count_total_active_balls__init:

	li	$t0, 0							#  int count = 0;
	li	$t1, 0							#  int i = 0;
	li	$t2, MAX_BALLS

count_total_active_balls__cond:

	bge	$t1, $t2, count_total_active_balls__false		#  if (i >= MAX_BALLS) 
									#  goto count_total_active_balls__false;

count_total_active_balls__step:

	mul	$t3, $t1, SIZEOF_BALL					
	la	$t4, balls
	add	$t3, $t3, $t4
	lb	$t5, BALL_STATE_OFFSET($t3)				#  balls[i].state

	beq	$t5, BALL_NONE, count_total_active_balls__state_is_none	#  if (balls[i].state == BALL_NONE) 
									#  goto count_total_active_balls__state_is_none;

count_total_active_balls__state_not_none:

	add	$t0, $t0, 1						#  count++;

count_total_active_balls__state_is_none:

	add	$t1, $t1, 1						#  i++;
	j	count_total_active_balls__cond


count_total_active_balls__false:

	move	$v0, $t0						#  return count;

count_total_active_balls__epilogue:
	end
	jr	$ra


################################################################################
# .TEXT <print_cell>
        .text
print_cell:
	# Subset:   1
	#
	# Frame:    [$ra, $s0, $s1]  
	# Uses:     [$a0, $a1, $s0, $s1, $t0..4]
	# Clobbers: [$t0, $t2, $t3, $t4]
	#
	# Locals:           
	#   - $s0 = row
	#   - $s1 = col
	#   - $t0 = PADDLE_ROW
	#   - $t1 = paddle_x
	#   - $t2 = ball_count -> PADDLE_WIDTH
	#   - $t3 = row * MAX_GRID_WIDTH
	#   - $t4 = (row * MAX_GRID_WIDTH) + col
	#
	# Structure:        
	#   print_cell
	#   -> [prologue]
	#       -> body
	#       -> print_cell__count_balls
	#       	-> print_cell__many_balls
	#       	-> print_cell__one_ball
	#       -> print_cell__paddle_condition
	#       	-> print_cell__paddle_char
	#       -> print_cell__array_condition
	#       -> print_cell__all_false
	#   -> [epilogue]

print_cell__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1

print_cell__body:

	move	$s0, $a0				#  move row into saved register
	move	$s1, $a1				#  move col into saved register

	jal	count_balls_at_coordinate		#  count_balls_at_coordinate(row, col);

	move	$t2, $v0				#  int ball_count = count_balls_at_coordinate(row, col);
	
print_cell__count_balls:

	bgt	$t2, 1, print_cell__many_balls		#  if (ball_count > 1) goto print_cell__many_balls;
	bge	$t2, 1, print_cell__one_ball		#  if (ball_count == 1) goto print_cel__one_ball;

	b	print_cell__paddle_condition		#  else goto print_cell_paddle_condition;

print_cell__many_balls:

	li	$v0, MANY_BALL_CHAR			#  return MANY_BALL_CHAR;
	b	print_cell__epilogue

print_cell__one_ball:

	li	$v0, ONE_BALL_CHAR			#  return ONE_BALL_CHAR;
	b	print_cell__epilogue

print_cell__paddle_condition:

	li	$t0, PADDLE_ROW				#  init PADDLE_ROW
	lw	$t1, paddle_x				#  init paddle_x
	li	$t2, PADDLE_WIDTH			#  init PADDLE_WIDTH

	bne	$s0, $t0, print_cell__array_condition	#  if (row != PADDLE_ROW) goto 
							#  print_cell_array_condition;


	bgt	$t1, $s1, print_cell__array_condition	#  if (paddle_x > col) goto
							#  print_cell_array_condition;

	add	$t2, $t2, $t1				#  paddle_x + PADDLE_WIDTH;

	bge	$s1, $t2, print_cell__array_condition	#  if (col > (paddle_x + PADDLE_WIDTH))
							#  goto print_cell_array_condition;

print_cell__paddle_char:

	li	$v0, PADDLE_CHAR 			#  return PADDLE_CHAR;

	b	print_cell__epilogue

print_cell__array_condition:

	mul	$t3, $s0, MAX_GRID_WIDTH		#  row * MAX_GRID_WIDTH;

	add	$t4, $t3, $s1				#  col + (row * MAX_GRID_WIDTH);

	lb	$t0, bricks($t4)			#  load &bricks[row][col];

	beqz	$t0, print_cell__all_false		#  if (bricks[row][col] != 0)
							#  goto print_cell__all_false;
	sub	$t0, $t0, 1				#  bricks[row][col] - 1;
	add	$t0, $t0, '0'				#  '0' + bricks[row][col] - 1;

	move	$v0, $t0				#  return '0' + bricks[row][col] - 1;

	b	print_cell__epilogue

print_cell__all_false:
	
	li	$v0, EMPTY_CHAR				#  return EMPTY_CHAR;


print_cell__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra
	end
	jr	$ra


################################################################################
# .TEXT <register_screen_update>
        .text
register_screen_update:
	# Subset:   2
	#
	# Frame:    [$ra]  
	# Uses:     [$a0, $a1, $t0..$t5]
	# Clobbers: [$a0, $a1, $t1, $t3, $t4, $t5]
	#
	# Locals:          
	#   - $a0: x 
	#   - $a1: y
	#   - $t0: whole_screen_update_needed
	#   - $t1: num_screen_updates
	#   - $t2: screen_updates
	#   - $t3: TRUE
	#   - $t4: num_screen_updates * SIZEOF_SCREEN_UPDATE
	#   - $t5: &screen_updates / screen_updates[num_screen_updates].x = x
	#
	# Structure:        
	#   register_screen_update
	#   -> [prologue]
	#       -> body
	#		-> register_screen_update__init
	#		-> register_screen_update__not_zero
	#			-> register_screen_update__no_zero_false
	#		-> register_screen_update__max_updates
	#			-> register_screen_update__max_updates_true
	#			-> register_screen_update__max_updates_false
	#		-> register_screen_update__phi
	#   -> [epilogue]

register_screen_update__prologue:
	begin

register_screen_update__body:

register_screen_update__init:

	lw	$t0, whole_screen_update_needed		#  int whole_screen_update_needed;

	lw	$t1, num_screen_updates			#  int num_screen_updates;

	lw	$t2, screen_updates			#  struct screen_updates[num_screen_updates];

register_screen_update__not_zero:

	bnez	$t0, register_screen_update__phi	#  if (whole_screen_update_needed != 0)
							#  goto register_screen_update__epilogue

register_screen_update__no_zero_false:

register_screen_update__max_updates:

	blt	$t1, MAX_SCREEN_UPDATES, register_screen_update__max_updates_false  
							#  if (num_screen_updates < MAX_SCREEN_UPDATES)
							#  goto register_screen_update__max_updates_false;

register_screen_update__max_updates_true:
	li	$t3, TRUE				#  init TRUE;
	sw	$t3, whole_screen_update_needed		#  whole_screen_update_needed = TRUE;
	b	register_screen_update__phi		#  return;

register_screen_update__max_updates_false:
	mul	$t4, $t1, SIZEOF_SCREEN_UPDATE		#  num_screen_updates * SIZEOF_SCREEN_UPDATE
	la	$t5, screen_updates			#  &screen_updates

	add	$t5, $t4, $t5				#  &screen_updates + num_screen_updates * SIZEOF_SCREEN_UPDATE

	sw	$a0, SCREEN_UPDATE_X_OFFSET($t5) 	#  screen_updates[num_screen_updates].x = x;
	
	sw	$a1, SCREEN_UPDATE_Y_OFFSET($t5) 	#  screen_updates[num_screen_updates].y = y;

	add	$t1, $t1, 1					

	sw	$t1, num_screen_updates			#  num_screen_updates++

register_screen_update__phi:

register_screen_update__epilogue:
	end
	jr	$ra					#  return ();


################################################################################
# .TEXT <count_balls_at_coordinate>
        .text
count_balls_at_coordinate:
	# Subset:   2
	#
	# Frame:    [$ra]   
	# Uses:     [$a0, $a1, $v0, $t0..7]
	# Clobbers: [$t0, $t1, $t4]
	#
	# Locals:           
	#   - $t0: int count
	#   - $t1: int i
	#   - $t2: MAX_BALLS
	#   - $t3: i * SIZEOF_BALL
	#   - $t4: &balls -> &balls + i * SIZEOF_BALL
	#   - $t5: balls[i].state
	#   - $t6: balls[i].x
	#   - $t7: balls[i].y
	#   - $a0: Function Argument 1: int row
	#   - $a1: Function Argument 2: int col
	#
	# Structure:        
	#   count_balls_at_coordinate
	#   -> [prologue]
	#       -> body
	#		-> count_balls_at_coordinate__loop_cond:
	#		-> count_balls_at_coordinate__loop_body:
	#			-> count_balls_at_coordinate__if_count_empty:
	#			-> count_balls_at_coordinate__if_count_empty_true:	
	#				-> count_balls_at_coordinate__if_balls_row:
	#			-> count_balls_at_coordinate__if_balls_row_true:
	#			-> count_balls_at_coordinate__if_balls_col:
	#			-> count_balls_at_coordinate__if_balls_col_true:
	#			-> count_balls_at_coordinate__false:
	#		-> count_balls_at_coordinate__loop_step:
	#		-> count_balls_at_coordinate__loop_end:
	#		-> count_balls_at_coordinate__epilogue:
	#   -> [epilogue]

count_balls_at_coordinate__prologue:
	begin	
count_balls_at_coordinate__body:

	li	$t0, 0							#  int count = 0;
	li	$t1, 0							#  int i = 0;

count_balls_at_coordinate__loop_cond:
	li	$t2, MAX_BALLS
	bge	$t1, $t2, count_balls_at_coordinate__loop_end

count_balls_at_coordinate__loop_body:

	mul	$t3, $t1, SIZEOF_BALL					#  i * SIZEOF_BALL;
	la	$t4, balls						#  &balls;
	add	$t4, $t4, $t3						#  $t4 = &balls + i * SIZEOF_BALL;

	lb	$t5, BALL_STATE_OFFSET($t4)				#  balls[i].state;

count_balls_at_coordinate__if_count_empty:

	beq	$t5, BALL_NONE, count_balls_at_coordinate__false	#   if (count += balls[i].state != BALL_NONE) 
									#  goto false branch;

count_balls_at_coordinate__if_count_empty_true:	

	lw	$t6, BALL_X_OFFSET($t4)					#  int x = balls[i].x ;

	lw	$t7, BALL_Y_OFFSET($t4)					#  int y = balls[i].y;

count_balls_at_coordinate__if_balls_row: 

	bne	$t7, $a0, count_balls_at_coordinate__false		#  if (balls[i].y != row) go to false branch;

count_balls_at_coordinate__if_balls_row_true:

count_balls_at_coordinate__if_balls_col:

	bne	$t6, $a1, count_balls_at_coordinate__false		#  if (balls[i].x != col) go to false branch;

count_balls_at_coordinate__if_balls_col_true:

	addi	$t0, $t0, 1						#  count++;

count_balls_at_coordinate__false:

count_balls_at_coordinate__loop_step:

	addi	$t1, $t1, 1						#  i++;
	j	count_balls_at_coordinate__loop_cond
	
count_balls_at_coordinate__loop_end: 

	move	$v0, $t0						#  return count;

count_balls_at_coordinate__epilogue:
	end
	jr	$ra


################################################################################
# .TEXT <print_game>
        .text
print_game:
	# Subset:   2
	#
	# Frame:    [$ra, $s0, $s1, $s2]   
	# Uses:     [$ra, $s0, $s1, $s2, $v0, $a0, $a1, $t0]
	# Clobbers: [$a0, $v0, $t0]
	#
	# Locals:          
	#   - $s0: int row
	#   - $s1: int col
	#   - $s2: int grid_width
	#   - $a0: row argument for print_cell -> arguments for printing characters
	#   - $a1: col argument for print_cell
	#   - $t0: GRID_HEIGHT
	#
	# Structure:        
	#   print_game
	#   -> [prologue]
	#       -> body
	#		-> print_game__score_print:
	#		-> print_game__loop_row_init:
	#		-> print_game__loop_row_cond:
	#		-> print_game__loop_row_body:
	#			-> print_game__loop_col_init:
	#			-> print_game__loop_col_cond:
	#			-> print_game__loop_col_body:
	#				-> print_game__row_minus_one:
	#				-> print_game__row_minus_one_true:
	#				-> print_game__col_minus_one:
	#				-> print_game__col_is_grid_width:
	#				-> print_game__col_true:
	#				-> print_game__all_false
	#			-> print_game__loop_col_step
	#			-> print_game__loop_col_end
	#		-> print_game__loop_row_step
	#		-> print_game__loop_row_end
	#   -> [epilogue]

print_game__prologue:

	begin
	push	$ra					#  push addresses/registers to stack
	push	$s0
	push	$s1
	push	$s2

print_game__body:

print_game__score_print:

	li	$v0, 4
	la	$a0, str_print_game_score		#  printf(" SCORE: %d\n", score);
	syscall

	li	$v0, 1
	lw	$a0, score				#  printf("%d", score);
	syscall

	li	$v0, 11
	la	$a0, '\n'				#  printf("\n");
	syscall

print_game__loop_row_init:

	li	$s0, -1					#  int row = -1;

print_game__loop_row_cond:

	li	$t0, GRID_HEIGHT			#  load GRID_HEIGHT;
	bge 	$s0, $t0, print_game__loop_row_end	#  if (row >= GRID_HEIGHT)
							#  goto print_game__loop1_end;
print_game__loop_row_body:

print_game__loop_col_init:

	li	$s1, -1					#  int col = -1;
	lw	$s2, grid_width				#  load grid_width

print_game__loop_col_cond:

	bgt	$s1, $s2, print_game__loop_col_end		#  if (col > grid_width)
							#  goto print_game__loop2_end
print_game__loop_col_body:

print_game__row_minus_one:

	bne	$s0, -1, print_game__col_minus_one	#  if (row != -1) goto "next condition";
							#  next condition is...: 
							#  print_game__col_minus_one;
							#  else goto print_game__row_minus_one_true;

print_game__row_minus_one_true:

	li	$v0, 11					
	li	$a0, GRID_TOP_CHAR			#  putchar(GRID_TOP_CHAR);
	syscall

	b	print_game__loop_col_step		#  goto increment of loop2

print_game__col_minus_one:

	bne	$s1, -1, print_game__col_is_grid_width	#  if (col != -1) goto "next condition";
							#  next condition is...:
	b	print_game__col_true			#  print_game__col_is_grid_width
							#  else goto print_game__col_true

print_game__col_is_grid_width:

	bne	$s1, $s2, print_game__all_false		#  if (col != grid_width) goto next condition;

print_game__col_true:

	li	$v0, 11
	li	$a0, GRID_SIDE_CHAR			#  putchar(GRID_TOP_CHAR);
	syscall

	b	print_game__loop_col_step		#  goto row++;	

print_game__all_false:

	move	$a0, $s0				#  make row an argument
	move	$a1, $s1				#  make col an argument

	jal	print_cell				#  print_cell(row,col);		

	move	$a0, $v0				#  $a0 = return print_cell(row,col);
	li	$v0, 11
	syscall

print_game__loop_col_step:

	addi	$s1, $s1, 1				#  col++;
	j	print_game__loop_col_cond		#  goto print_game__loop2_cond;

print_game__loop_col_end:

	li	$v0, 11
	li	$a0, '\n'				#  putchar('\n');
	syscall

print_game__loop_row_step:

	addi	$s0, $s0, 1				#  row++
	j	print_game__loop_row_cond		#  goto print_game__loop1_cond

print_game__loop_row_end:

print_game__epilogue:
	pop	$s2					#  remove stored addresses/registers from stack
	pop	$s1
	pop	$s0
	pop	$ra
	end
	jr	$ra


################################################################################
# .TEXT <spawn_new_ball>
       .text
spawn_new_ball:
	# Subset:   2
	#
	# Frame:    [$ra, $s0, $s1] 
	# Uses:     [$t0..$t9, $a0, $a1, $v0]
	# Clobbers: [$t0..$t9, $a0, $a1, $v0]
	#
	# Locals:           
	#   - $t0: int i
	#   - $t1: &balls
	#   - $t2: &BALL_NONE
	#   - $t3: BALL_STATE_OFFSET($t1)
	#   - $t4: BALL_NORMAL
	#   - $t5: PADDLE_ROW
	#   - $t6: grid_width
	#   - $t7: BALL_FRACTION / 2
	#   - $t8: BALL_FRACTION -> -BALL_FRACTION / BALL_SIM_STEPS;
	#   - $s0: struct ball *new_ball
	#   - $s1: grid width % 2
	#
	# Structure:        
	#   spawn_new_ball
	#   -> [prologue]
	#       -> body
	#           -> spawn_new_ball__search_new_ball:
	#           	-> spawn_new_ball__search_loop_cond:
	#           	-> spawn_new_ball__search_loop_body:
	#			-> spawn_new_ball__state_is_none_cond:
	#           	-> spawn_new_ball__search_loop_step:
	#           		-> spawn_new_ball__state_is_none_true:
	#           	-> spawn_new_ball__search_loop_end:
	#           -> spawn_new_ball__place_ball:
	#           -> spawn_new_ball__function_call:
	#           -> spawn_new_ball__move_ball_up:
	#           -> spawn_new_ball__change_dx_sign:
	#           -> spawn_new_ball__return
	#           -> spawn_new_ball__no_new_ball
	#   -> [epilogue]

spawn_new_ball__prologue:
	begin
	push	$ra						#  push return address and
	push	$s0						#  saved registers to the stack
	push	$s1

spawn_new_ball__body:

spawn_new_ball__search_new_ball:

	li	$t0, 0						#  int i = 0;
	la	$t1, balls					#  &balls
	li	$t2, BALL_NONE					#  load BALL_NONE
	move	$s0, $t0					

spawn_new_ball__search_loop_cond:

	bge	$t0, MAX_BALLS, spawn_new_ball__search_loop_end	#  if (i < MAX_BALLS) 
								#  goto spawn_new_ball__search_loop_end;

spawn_new_ball__search_loop_body:

	lb	$t3, BALL_STATE_OFFSET($t1)			#  balls[i].state

spawn_new_ball__state_is_none_cond:

	beq	$t3, $t2, spawn_new_ball__state_is_none_true	#  if (balls[i].state == BALL_NONE)
								#  goto spawn_new_ball__state_is_none_true;

spawn_new_ball__search_loop_step:

	addi	$t0, $t0, 1					#  i++;
	addi	$t1, $t1, SIZEOF_BALL				#  &balls[i];
	j	spawn_new_ball__search_loop_cond		

spawn_new_ball__state_is_none_true:

	move	$s0, $t1					#  store &balls to saved register

spawn_new_ball__search_loop_end:

	beq	$s0, NULL, spawn_new_ball__no_new_ball		#  if (new_ball == NULL) 
								#  goto spawn_new_ball__no_new_ball;

	li	$t4, BALL_NORMAL
	sb	$t4, BALL_STATE_OFFSET($s0)			#  new_ball->state = BALL_NORMAL;

spawn_new_ball__place_ball:

	li	$t5, PADDLE_ROW					
	sub	$t5, $t5, 1					#  PADDLE_ROW - 1
	sw	$t5, BALL_Y_OFFSET($s0)				#  new_ball->y = PADDLE_ROW - 1;

	lw	$t6, grid_width
	div	$t6, $t6, 2					#  grid_width / 2
	sw	$t6, BALL_X_OFFSET($s0)				#  new_ball->x = grid_width / 2;

	li	$t7, BALL_FRACTION				
	div	$t7, $t7, 2					#  BALL_FRACTION / 2
	sw	$t7, BALL_X_FRAC_OFFSET($s0)			#  new_ball->x_fraction = BALL_FRACTION / 2;
	sw	$t7, BALL_Y_FRAC_OFFSET($s0)			#  new_ball->y_fraction = BALL_FRACTION / 2;	

	move	$a0, $t6					#  new_ball->x argument
	move	$a1, $t5					#  new_ball->y argument

spawn_new_ball__function_call:

	jal	register_screen_update				#  register_screen_update(new_ball->x, new_ball->y);

spawn_new_ball__move_ball_up:

	li	$t8, BALL_FRACTION
	mul	$t8, $t8, -1					#  BALL_FRACTION *= -1;
	div	$t8, $t8, BALL_SIM_STEPS			#  -BALL_FRACTION / BALL_SIM_STEPS
	sw	$t8, BALL_DY_OFFSET($s0)			#  new_ball->dy = -BALL_FRACTION / BALL_SIM_STEPS;


	li	$t8, BALL_FRACTION
	div	$t8, $t8, BALL_SIM_STEPS			#  new_ball->dx = BALL_FRACTION / BALL_SIM_STEPS / 4;
	div	$t8, $t8, 4
	sw	$t8, BALL_DX_OFFSET($s0)			#  new_ball->dx = BALL_FRACTION / BALL_SIM_STEPS / 4;


	lw	$s1, grid_width
	rem	$s1, $s1, 2
	bnez	$s1, spawn_new_ball__return			#  if (grid_width % 2 == 0) 


spawn_new_ball__change_dx_sign:

	mul	$t8, $t8, -1
	sw	$t8, BALL_DX_OFFSET($s0)			#  new_ball->dx *= -1;


spawn_new_ball__return:

	li	$v0, TRUE					#  return TRUE;
	j	spawn_new_ball__epilogue

spawn_new_ball__no_new_ball:

	li	$v0, FALSE					#  new_ball ==  NULL -> return FALSE;

spawn_new_ball__epilogue:
	pop	$s1						#  remove return address and 
	pop	$s0						#  saved registers from stack
	pop	$ra
	end
	jr	$ra						#  return $v0


################################################################################
# .TEXT <move_balls>
        .text
move_balls:
	# Subset:   2
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3, $s4]   
	# Uses:     [$ra, $s0, $s1, $s2, $s3, $s4, $t0, $t1, $t2]
	# Clobbers: [$s0, $s2, $s3, $t0, $t1, $t2]
	#
	# Locals:          
	#   - $a0: int sim_steps -> ball
	#   - $a1: VERTICAL/HORIZONTAL
	#   - $a2: &ball->y_fraction -> &ball->x_fraction
	#   - $a3: ball->dy -> ball->dx
	#   - $s0: int step
	#   - $s1: int sim_steps
	#   - $s2: int i
	#   - $s3: ball[i]
	#   - $t0: i * SIZEOF_BALL
	#   - $t1: &balls
	#   - $t2: BALL_NONE
	#
	# Structure:        
	#   move_balls
	#   -> [prologue]
	#       -> body
	#		-> move_balls__step_loop_init:
	#		-> move_balls__step_loop_cond:
	#		-> move_balls__step_loop_body:
	#			-> move_balls__i_loop_init:
	#			-> move_balls__i_loop_cond:
	#			-> move_balls__i_loop_body:
	#				-> move_balls__ball_state_none:
	#					-> move_balls__ball_state_is_none:
	#					-> move_balls__ball_state_not_none:
	#				-> move_balls__function_call_x:
	#				-> move_balls__function_call_y:
	#				-> move_balls__y_grid_height_cond:
	#					-> move_balls__y_grid_height_true:
	#					-> move_balls__y_grid_height_false:
	#			-> move_balls__i_loop_step:
	#		-> move_balls__i_loop_end:
	#		-> move_balls__step_loop_step:
	#		-> move_balls__step_loop_end:
	#   -> [epilogue]

move_balls__prologue:
	begin
	push	$ra					#  push return address and 
	push	$s0					#  saved reegisters to stack
	push	$s1
	push	$s2
	push	$s3
	push	$s4
move_balls__body:

move_balls__step_loop_init:

	li	$s0, 0					#  int step = 0;
	move	$s1, $a0				#  int sim_steps;

move_balls__step_loop_cond:

	bge	$s0, $s1, move_balls__step_loop_end	#  if (step >= sim_steps) goto move_balls__i_loop_end; 

move_balls__step_loop_body:

move_balls__i_loop_init:

	li	$s2, 0					#  int i = 0;

move_balls__i_loop_cond:

	bge	$s2, MAX_BALLS, move_balls__i_loop_end	#  if (i >= MAX_BALLS) goto move_balls__i_loop_end;

move_balls__i_loop_body:

	mul	$t0, $s2, SIZEOF_BALL			#  i * SIZEOF_BALL
	la	$t1, balls				#  &balls
	add	$s3, $t1, $t0				#  ball[i] = &balls + i * SIZEOF_BALL
	
move_balls__ball_state_none:

	lb	$s4, BALL_STATE_OFFSET($s3)		#  char balls[i].state;	

	bne	$s4, BALL_NONE, move_balls__ball_state_not_none
							#  if (balls[i].state != BALL_NONE) goto
							#  move_balls_function_call_a;
move_balls__ball_state_is_none:

	b	move_balls__i_loop_step			#  if (balls[i].state == BALL_NONE) i++;

move_balls__ball_state_not_none:

move_balls__function_call_x:

	move	$a0, $s3				#  argument a0: ball

	li	$a1, VERTICAL				#  argument a1: VERTICAL

	la	$a2, BALL_Y_FRAC_OFFSET($s3)		#  argument a2: &ball->y_fraction

	lw	$a3, BALL_DY_OFFSET($s3)		#  argument a3: ball->dy

	jal	move_ball_in_axis			#  move_ball_in_axis(ball, axis, fraction, delta);

move_balls__function_call_y:

	move	$a0, $s3				#  argument a0: ball

	li	$a1, HORIZONTAL				#  argument a1: HORIZONTAL

	la	$a2, BALL_X_FRAC_OFFSET($s3)		#  argument a2: &ball->x_fraction

	lw	$a3, BALL_DX_OFFSET($s3)		#  argument a3: ball->dx

	jal	move_ball_in_axis			#  move_ball_in_axis(ball, axis, fraction, delta);

move_balls__y_grid_height_cond:

	lw	$t1, BALL_Y_OFFSET($s3)			#  ball->y

	ble	$t1, GRID_HEIGHT, move_balls__y_grid_height_false	
							#  if (ball->y <= GRID_HEIGHT) 
							#  goto move_balls__y_grid_height_false;

move_balls__y_grid_height_true:

	li	$t2, BALL_NONE				#  load BALL_NONE
	sb	$t2, BALL_STATE_OFFSET($s3)		#  ball->state = BALL_NONE;
	b	move_balls__i_loop_step			

move_balls__y_grid_height_false:

move_balls__i_loop_step:

	addi	$s2, $s2, 1				#  i++;
	j	move_balls__i_loop_cond

move_balls__i_loop_end:
move_balls__step_loop_step:

	addi	$s0, $s0, 1				# step++;
	j	move_balls__step_loop_cond

move_balls__step_loop_end:

move_balls__epilogue:
	pop	$s4					#  remove return address and
	pop	$s3					#  saved registers from stack
	pop	$s2	
	pop	$s1	
	pop	$s0		
	pop	$ra	
	end	
	jr	$ra					#  return void;


################################################################################
# .TEXT <move_ball_in_axis>
        .text
move_ball_in_axis:
	# Subset:   3
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3]   
	# Uses:     [$ra, $s0, $s1, $s2, $s3, $a0, $a1, $a2, $a3, $t0]
	# Clobbers: [$t0, $a0, $a1, $a2]
	#
	# Locals:          
	#   - $t0:  *fraction for arithmetic in function (e.g. *fraction += delta)
	#   - $s0:  struct ball *ball
	#   - $s1:  int axis
	#   - $s2:  int *fraction
	#   - $s3:  int delta
	#   - $a0:  function arguments [struct ball *ball, &ball]
	#   - $a1:  function arguments [axis]
	#   - $a2:  function arguments [int *fraction, 1, -1]
	#   - $a3:  function arguments [int delta]
	#
	# Structure:        
	#   move_ball_in_axis
	#   -> [prologue]
	#       -> body
	#		-> move_ball_in_axis__while_true_loop
	#		-> move_ball_in_axis__if_fraction_negative
	#			-> move_ball_in_axis__fraction_negative_true
	#			-> move_ball_in_axis__fraction_negative_false
	#		-> move_ball_in_axis__fraction_gt_ball_fraction
	#			-> move_ball_in_axis__fraction_gt_ball_fraction_true
	#			-> move_ball_in_axis__fraction_gt_ball_fraction_false
	#   -> [epilogue]

move_ball_in_axis__prologue:
	begin
	push	$ra					#  push	return address and saved registers to stack
	push	$s0
	push	$s1
	push	$s2
	push	$s3
move_ball_in_axis__body:

	la	$s0, ($a0)				#  struct ball *ball;
	move	$s1, $a1				#  int axis;
	move	$s2, $a2				#  int *fraction;
	move	$s3, $a3				#  int delta;

	lw	$t0, ($s2)				#  $t0 = *fraction;
	add	$t0, $t0, $s3				#  fraction += delta;
	sw	$t0, ($s2)				#  *fraction = fraction

move_ball_in_axis__while_true_loop:

move_ball_in_axis__if_fraction_negative:
	lw	$t0, ($s2)				#  *fraction

	bgez	$t0, move_ball_in_axis__fraction_negative_false 
							#  if (fraction >= 0) 
							#  goto move_ball_in_axis__fraction_negative_false
						

move_ball_in_axis__fraction_negative_true:

	lw	$t0, ($s2)				#  *fraction
	add	$t0, $t0, BALL_FRACTION			#  fraction += BALL_FRACTION
	sw	$t0, ($s2)				#  *fraction = fraction + BALL_FRACTION;

	move	$a0, $s0				#  argument 0: &ball
	move	$a1, $s1				#  argument 1: axis
	li	$a2, -1					#  argument 2: -1

	jal	move_ball_one_cell			#  move_ball_one_cell(ball, axis, -1);

	j	move_ball_in_axis__while_true_loop

move_ball_in_axis__fraction_negative_false:

move_ball_in_axis__fraction_gt_ball_fraction:

	blt	$t0, BALL_FRACTION, move_ball_in_axis__fraction_gt_ball_fraction_false
							#  if (*fraction < BALL_FRACTION) break;

move_ball_in_axis__fraction_gt_ball_fraction_true:


	lw	$t0, ($s2)				#  *fraction
	sub	$t0, $t0, BALL_FRACTION			#  fraction -= BALL_FRACTION
	sw	$t0, ($s2)				#  *fraction = fraction + BALL_FRACTION;


	move	$a0, $s0				#  argument 0: &ball
	move	$a1, $s1				#  argument 1: axis
	li	$a2, 1					#  argument 2: 1

	jal	move_ball_one_cell			#  move_ball_one_cell(ball, axis, 1);
	
	j	move_ball_in_axis__while_true_loop	#  goto move_ball_in_axis__while_true_loop;


move_ball_in_axis__fraction_gt_ball_fraction_false:


move_ball_in_axis__epilogue:
	pop	$s3					#  remove return address and
	pop	$s2					#  saved registers from stack
	pop	$s1
	pop	$s0
	pop	$ra	
	end						#  return void;
	jr	$ra


################################################################################
# .TEXT <hit_brick>
        .text
hit_brick:
	# Subset:   3
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3, $s4, $s5]   
	# Uses:     [$s0, $s1, $s2, $s3, $s4, $s5, $t0, $t1, $t2, $t3, $t4]
	# Clobbers: [$a0, $a1, $t0, $t1, $t2, $t3, $t4]
	#
	# Locals:           
	#   - $t0: &bricks
	#   - $t1: bricks[row][col] 
	#   - $t2: brick_num
	#   - $t3: bricks_destroyed
	#   - $t4: bricks_destroyed % 10
	#   - $s0: int row
	#   - $s1: int col
	#   - $s2: row * MAX_GRID_WIDTH
	#   - $s3: bricks[row][original_col]
	#   - $s4: original_row
	#   - $s5: grid_width
	#   - $a0: function argument 1
	#   - $a1: function argument 2
	#
	# Structure:        
	#   hit_brick
	#   -> [prologue]
	#       -> body
	#		-> hit_brick__init_brick_num
	#		-> hit_brick__right_loop_init
	#			-> hit_brick__right_loop_cond
	#			-> hit_brick__right_loop_body
	#			-> hit_brick__right_loop_step
	#		-> hit_brick__right_loop_end
	#		-> hit_brick__left_loop_init
	#			-> hit_brick__left_loop_cond
	#			-> hit_brick__left_loop_body
	#			-> hit_brick__left_loop_step
	#		-> hit_brick__left_loop_end
	#		-> hit_brick__spawn_ball
	#		-> hit_brick__spawn_ball_cond
	#			-> hit_brick__spawn_ball_true
	#			-> hit_brick__spawn_ball_false
	#   -> [epilogue]

hit_brick__prologue:
	begin
	push	$ra					#  push	return address and saved registers to stack
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push	$s4
	push 	$s5
hit_brick__body:

hit_brick__init_brick_num:

	move	$s0, $a0				#  int row;					
	move	$s1, $a1				#  int original_col;

	mul	$s2, $s0, MAX_GRID_WIDTH 		# row * MAX_GRID_WIDTH
	la	$t0, bricks				#  &bricks
	add	$s2, $t0, $s2		

	add	$s3, $s2, $s1				#  &bricks + (row * MAX_GRID_WIDTH) + original_col
	lb	$s3, ($s3)				#  bricks[row][original_col]

hit_brick__right_loop_init:

	move	$s4, $s1				#  int col = original_row;
	lw	$s5, grid_width				#  load grid_width;

hit_brick__right_loop_cond:
	add	$t1, $s2, $s4				#  bricks[row][col]
	lb	$t2, ($t1)				#  brick_num

	bge	$s4, $s5, hit_brick__right_loop_end	#  if (col >= grid_width) 
							#  goto hit_brick__right_loop_end;

	bne	$t2, $s3, hit_brick__right_loop_end	#  if (bricks[row][col] != brick_num; col++)
							#  goto hit_brick__right_loop_end

hit_brick__right_loop_body:

	li	$t2, 0			
	sb	$t2, ($t1)				#  bricks[row][col] = 0;

	move	$a0, $s4				#  argument 0: col
	move	$a1, $s0				#  argument 1: row

	jal	register_screen_update			#  register_screen_update(col, row);

hit_brick__right_loop_step:

	addi	$s4, $s4, 1				#  col;

	b	hit_brick__right_loop_cond

hit_brick__right_loop_end:

hit_brick__left_loop_init:
	sub	$s4, $s1, 1				#  int col = original_col - 1;

hit_brick__left_loop_cond:
	add	$t1, $s2, $s4		
	lb	$t2, ($t1)				#  bricks[row][col];

	bltz	$s4, hit_brick__left_loop_end		#  if (col <= 0) goto hit_brick__left_loop_end;

	bne	$t2, $s3, hit_brick__left_loop_end	#  if (bricks[row][col] != brick_num) 
							#  goto hit_brick__left_loop_end;		

hit_brick__left_loop_body:

	li	$t2, 0
	sb	$t2, ($t1)				#  bricks[row][col] = 0;

	move	$a0, $s4				#  argument 0: col
	move	$a1, $s0				#  argument 1: row

	jal	register_screen_update			#  register_screen_update(col, row);

hit_brick__left_loop_step:

	sub	$s4, $s4, 1				#  col--;

	b	hit_brick__left_loop_cond

hit_brick__left_loop_end:

	lw	$t3, bricks_destroyed
	addi	$t3, $t3, 1
	sw	$t3, bricks_destroyed			#  bricks_destroyed++;

hit_brick__spawn_ball:

	rem	$t4, $t3, 10				#  $t4 = bricks_destroyed % 10;


hit_brick__spawn_ball_cond:

	bnez	$t4, hit_brick__spawn_ball_false	#  if ($t4 != 0) goto hit_brick__spawn_ball_false;

	jal	spawn_new_ball				#  spawn_new_ball();

	bne	$v0, TRUE, hit_brick__spawn_ball_false	#  if (!spawn_new_ball) goto hit_brick__spawn_ball_false;

hit_brick__spawn_ball_true:

	li	$v0, 4
	la	$a0, str_hit_brick_bonus_ball		#  printf("\n!! Bonus ball !!\n");
	syscall

	b	hit_brick__epilogue

hit_brick__spawn_ball_false:

hit_brick__epilogue:
	pop	$s5					#  remove return address and  
	pop	$s4					#  saved registers from stack
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	end
	jr	$ra					#  return void;


################################################################################
# .TEXT <check_ball_paddle_collision>
        .text
check_ball_paddle_collision:
	# Subset:   3
	#
	# Frame:    [$ra]  
	# Uses:     [$t0..9]
	# Clobbers: [$t0, $t1, $t4, $t5, $t7, $t9]
	#
	# Locals:           
	#   - $t0: int i
	#   - $t1: i * SIZE_OF_BALL -> score
	#   - $t2: &balls + (i * SIZE_OF_BALL)
	#   - $t3: balls[i]->state
	#   - $t4: balls[i]->y
	#   - $t5: balls[i]->dy
	#   - $t6: balls[i]->x
	#   - $t7: balls[i]->dx
	#   - $t8: paddle_x
	#   - $t9: paddle_x + PADDLE_WIDTH -> PADDLE_WIDTH
	#
	# Structure:        <-- FILL THIS OUT!
	#   check_ball_paddle_collision
	#   -> [prologue]
	#       -> body
	#		-> check_ball_paddle_collision__main_loop
	#		-> check_ball_paddle_collision__main_loop_init
	#		-> check_ball_paddle_collision__main_loop_cond
	#		-> check_ball_paddle_collision__main_loop_body
	#			-> check_ball_paddle_collision__if_condition_init
	#			-> check_ball_paddle_collision__if_nest_one
	#				-> 	check_ball_paddle_collision__if_nest_1_true
	#				-> 	check_ball_paddle_collision__if_nest_1_false
	#			-> check_ball_paddle_collision__if_nest_2
	#				-> 	check_ball_paddle_collision__if_nest_2_true
	#				-> 	check_ball_paddle_collision__if_nest_2_false
	#			-> check_ball_paddle_collision__adjust_values
	#			-> check_ball_paddle_collision__adjust_values_if
	#				-> 	check_ball_paddle_collision__adjust_values_if_true
	#				-> 	check_ball_paddle_collision__adjust_values_if_false
	#			-> 	check_ball_paddle_collision__adjust_values_if_phi
	#		-> check_ball_paddle_collision__main_loop_step
	#		-> check_ball_paddle_collision__main_loop_end
	#   -> [epilogue]
	#
	# NOTE: Due to length of some label names, this function's name at the 
	# beginning of these labels will begin with "check...[section]:" to 
	# account for limited line space.

check_ball_paddle_collision__prologue:
	begin
check_ball_paddle_collision__body:

check_ball_paddle_collision__main_loop:

check_ball_paddle_collision__main_loop_init:
	li	$t0, 0								#  int i = 0;
check_ball_paddle_collision__main_loop_cond:

	bge	$t0, MAX_BALLS, check_ball_paddle_collision__main_loop_end	#  for (int i = 0; i < MAX_BALLS; i++)

check_ball_paddle_collision__main_loop_body:


check_ball_paddle_collision__if_condition_init:

	mul	$t1, $t0, SIZEOF_BALL						#  $t1 = i * SIZE_OF_BALL
	la	$t2, balls							#  $t2 = &balls;
	add	$t2, $t2, $t1							#  $t2 = &balls + (i * SIZE_OF_BALL);
	lb	$t3, BALL_STATE_OFFSET($t2)					#  $t3 = ball[i]->state;
	lw	$t4, BALL_Y_OFFSET($t2)						#  $t4 = ball[i]->y;
	lw	$t5, BALL_DY_OFFSET($t2)					#  $t5 = ball[i]->dy;
	lw	$t6, BALL_X_OFFSET($t2)						#  $t6 = ball[i]->x
	lw	$t7, BALL_DX_OFFSET($t2)					#  $t7 = ball[i]->dx;
	lw	$t8, paddle_x							#  $t8 = paddle_x
	add	$t9, $t8, PADDLE_WIDTH						#  $t9 = paddle_x + PADDLE_WIDTH;

check_ball_paddle_collision__if_nest_one:

	beq	$t3, BALL_NONE, check_ball_paddle_collision__if_nest_1_true	#  if(balls[i].state == BALL_NONE)
										#  goto (check...__if_nest_1_true);
			  
	bne	$t4, PADDLE_ROW, check_ball_paddle_collision__if_nest_1_true	#  if(balls[i].y != PADDLE_ROW)
										#  goto (check...__if_nest_1_true);

	bltz	$t5, check_ball_paddle_collision__if_nest_1_true		#  if(balls[i].dy < 0)
										#  goto (check...__if_nest_1_true);
											

	b	check_ball_paddle_collision__if_nest_1_false			#  else goto (check...if_nest_1_false);

check_ball_paddle_collision__if_nest_1_true:

	b	check_ball_paddle_collision__main_loop_step			#  continue;

check_ball_paddle_collision__if_nest_1_false:

check_ball_paddle_collision__if_nest_2:

	bgt	$t8, $t6, check_ball_paddle_collision__if_nest_2_true		#  if (paddle_x > balls[i].x )
										#  goto (check...__if_nest_2_true);

	bge	$t6, $t9,check_ball_paddle_collision__if_nest_2_true		#  if(balls[i].x >= 
										#  paddle_x + PADDLE_WIDTH))
										#  goto (check...__if_nest_2_true);

	b	check_ball_paddle_collision__if_nest_2_false			#  else goto(check...__if_nest_2_false);

check_ball_paddle_collision__if_nest_2_true:

	b	check_ball_paddle_collision__main_loop_step			#  continue;

check_ball_paddle_collision__if_nest_2_false:

check_ball_paddle_collision__adjust_values:

	sub	$t4, $t4, 1							
	sw	$t4, BALL_Y_OFFSET($t2)						#  balls[i].y -= 1;
										
	mul	$t5, $t5, -1							
	sw	$t5, BALL_DY_OFFSET($t2)					#  balls[i].dy *= -1;
  
	li	$t7, BALL_FRACTION						#  $t7 = BALL_FRACTION
	mul	$t7, $t7, 3							#  $t7 = BALL_FRACTION * 3
	div	$t7, $t7, 2							#  $t7 = BALL_FRACTION * 3 / 2	
	sw	$t7, BALL_DX_OFFSET($t2)					#  balls[i].dx = BALL_FRACTION * 3 / 2;


check_ball_paddle_collision__adjust_values_if:

	li	$t9, PADDLE_WIDTH						#  $t9 = PADDLE_WIDTH;
	div	$t9, $t9, 2							#  PADDLE_WIDTH / 2

	sub	$t0, $t6, $t8							#  balls[i].x - paddle_x

	bgt	$t0, $t9, check_ball_paddle_collision__adjust_values_if_false	#  if ($t0 > $t9)
										#  goto(check...adjust_values_if_false);

check_ball_paddle_collision__adjust_values_if_true:

	mul	$t7, $t7, -1							
	sw	$t7, BALL_DX_OFFSET($t2)					#  balls[i].dx *= -1;

	b	check_ball_paddle_collision__adjust_values_if_phi		#  goto(check..n__adjust_values_if_phi);

check_ball_paddle_collision__adjust_values_if_false:

check_ball_paddle_collision__adjust_values_if_phi:

	li	$t3, BALL_SUPER							#  $t3 = BALL_SUPER
	sb	$t3, BALL_STATE_OFFSET($t2)					#  ball->state = BALL_SUPER

	lw	$t1, score							#  int score;
	add	$t1, $t1, 2							#  score + 2
	sw	$t1, score							#  score += 2;

check_ball_paddle_collision__main_loop_step:

	addi	$t0, $t0, 1							#  i++;

	j	check_ball_paddle_collision__main_loop_cond

check_ball_paddle_collision__main_loop_end:

check_ball_paddle_collision__epilogue:
	end
	jr	$ra								#  return void;


################################################################################
# .TEXT <move_ball_one_cell>
        .text
move_ball_one_cell:
	# Subset:   3
	#
	# Frame:    [$ra, $s0..6]  
	# Uses:     [$a0, $a1, $a2, $t0..9]
	# Clobbers: [$a0, $a1, $a2, $t0..9]
	#
	# Locals:           
	#  - $s0: *ball
	#  - $s1: int axis
	#  - $s2: int direction
	#  - $s3: int *axis_position
	#  - $s4: int *axis_velocity
	#  - $s5: int *axis_fraction
	#  - $s6: int hit 
	#  - $t8: int max_speed = (BALL_FRACTION / BALL_SIM_STEPS)
	#  - $t0..9: temporary registers 
	#
	# Structure:        <-- FILL THIS OUT!
	#   move_ball_one_cell
	#   -> [prologue]
	#       -> body
	#		-> move_ball_one_cell__screen_function_call
	#		-> move_ball_one_cell__direction_check
	#			-> move_ball_one_cell__direction_vertical
	#			-> move_ball_one_cell__direction_horizontal
	#		-> move_ball_one_cell__direction_phi
	#		-> move_ball_one_cell__position_check
	#			-> move_ball_one_cell__position_check_negative
	#				-> move_ball_one_cell__position_check_negative_true
	#				-> move_ball_one_cell__position_check_negative_false
	#			-> move_ball_one_cell__position_horizontal
	#				-> move_ball_one_cell__position_horizontal_true
	#				-> move_ball_one_cell__position_horizontal_false
	#			-> move_ball_one_cell__position_check_with_paddle
	#				-> move_ball_one_cell__position_check_paddle_true
	#			-> move_ball_one_cell__reset_hit
	#			-> move_ball_one_cell__hit_eq_1
	#				-> move_ball_one_cell__hit_eq_1_true
	#			-> move_ball_one_cell__paddle_horizontal
	#				-> move_ball_one_cell__paddle_horizontal_true
	#				-> move_ball_one_cell__paddle_horizontal_false
	#			-> move_ball_one_cell__paddle_vertical_axis
	#				-> move_ball_one_cell__paddle_vertical_axis_true
	#				-> move_ball_one_cell__horizontal_speed
	#					-> move_ball_one_cell__horizontal_speed_true
	#					-> move_ball_one_cell__horizontal_speed_false
	#				-> move_ball_one_cell__max_speed
	#					-> move_ball_one_cell__less_than_neg_max_speed
	#						-> move_ball_one_cell__less_than_neg_max_speed_true
	#						-> move_ball_one_cell__less_than_neg_max_speed_false
	#					-> move_ball_one_cell__more_than_max_speed
	#						-> move_ball_one_cell__more_than_max_speed_true
	#						-> move_ball_one_cell__more_than_max_speed_false
	#				-> move_ball_one_cell__paddle_vertical_axis_false
	#				-> move_ball_one_cell__hit_eq_1_false
	#				-> move_ball_one_cell__position_check_paddle_false
	#					-> move_ball_one_cell__check_hit_brick
	#						-> move_ball_one_cell__check_hit_brick_true
	#						-> move_ball_one_cell__brick_collision
	#						-> move_ball_one_cell__give_score
	#				-> move_ball_one_cell__check_hit_brick_false
	#		-> move_ball_one_cell__position_check_phi
	#		-> move_ball_one_cell__check_if_hit
	#			-> move_ball_one_cell__if_hit_true
	#			-> move_ball_one_cell__if_hit_false
	#		-> move_ball_one_cell__if_hit_phi
	#   -> [epilogue]
	#
	# NOTE: Due to length of some label names, this function's name at the 
	# beginning of these labels will sometimes, in comments, begin as 
	# "move...[section]:" to account for limited line space.

move_ball_one_cell__prologue:
	begin
	push	$ra								#  push	return address and 
	push	$s0								#  saved registers to stack
	push	$s1
	push	$s2
	push	$s3
	push	$s4
	push	$s5
	push	$s6
move_ball_one_cell__body:
	
	move	$s0, $a0							#  store &ball
	move	$s1, $a1							#  store axis
	move	$s2, $a2							#  store direction

move_ball_one_cell__screen_function_call:

	lw	$a0, BALL_X_OFFSET($s0)						#  argument 0: ball->x
	lw	$a1, BALL_Y_OFFSET($s0)						#  argument 1: ball->y
	jal	register_screen_update						#  register_screen_update(ball->x, ball->y);

move_ball_one_cell__direction_check:

	bne	$s1, VERTICAL, move_ball_one_cell__direction_horizontal		#  if (axis != VERTICAL)
										#  goto move...__direction_horizontal;

move_ball_one_cell__direction_vertical:
	la	$s3, BALL_Y_OFFSET($s0)						#  *axis_position = &ball->y
	la	$s4, BALL_DY_OFFSET($s0)					#  *axis_velocity = &ball->dy
	la	$s5, BALL_Y_FRAC_OFFSET($s0)					#  *axis_fraction = &ball->y_fraction

	b	move_ball_one_cell__direction_phi

move_ball_one_cell__direction_horizontal:
	la	$s3, BALL_X_OFFSET($s0)						#  *axis_position = &ball->x
	la	$s4, BALL_DX_OFFSET($s0)					#  *axis_velocity = &ball->dx
	la	$s5, BALL_X_FRAC_OFFSET($s0)					#  *axis_fraction = &ball->x_fraction

	b	move_ball_one_cell__direction_phi				#  goto(move...position_check_phi);

move_ball_one_cell__direction_phi:

	lw	$t0, ($s3)							#  int $t0 = &($s3)
	add	$t0, $t0, $s2							#  $t0 += direction;
	sw	$t0, ($s3)							#  *axis_position += direction;
	li	$s6, FALSE							#  int hit = FALSE;

move_ball_one_cell__position_check:

move_ball_one_cell__position_check_negative:

	bgez	$t0, move_ball_one_cell__position_check_negative_false		#  if (*axis_position >= 0)
										#  goto move_..._check_negative_false

move_ball_one_cell__position_check_negative_true:

	li	$s6, TRUE							#  hit = TRUE
	b	move_ball_one_cell__position_check_phi				#  goto(move...position_check_phi);

move_ball_one_cell__position_check_negative_false:

move_ball_one_cell__position_horizontal:

	bne	$s1, HORIZONTAL, move_ball_one_cell__position_horizontal_false	#  if (axis != HORIZONTAL) 
										#  goto (move..._horizontal_false);
	lw	$t4, grid_width							#  int grid_width;

	blt	$t0, $t4, move_ball_one_cell__position_horizontal_false		#  if (*axis_position < grid_width)
										#  goto (move...horizontal_false);

move_ball_one_cell__position_horizontal_true:

	li	$s6, TRUE							#  hit = TRUE;
	b	move_ball_one_cell__position_check_phi				#  goto(move...position_check_phi);	

move_ball_one_cell__position_horizontal_false:

move_ball_one_cell__position_check_with_paddle:
	lw	$t5, BALL_Y_OFFSET($s0)						#  $t5 = &ball->y;
	bne	$t5, PADDLE_ROW, move_ball_one_cell__position_check_paddle_false#  if (ball->y != PADDLE_ROW)
										#  goto (move...check_paddle_false);

move_ball_one_cell__position_check_paddle_true:

move_ball_one_cell__reset_hit:

	lw	$t1, paddle_x							#  $t1 = int paddle_x;
	add	$t2, $t1, PADDLE_WIDTH						#  $t2 = paddle_x + PADDLE_WIDTH;
	lw	$t3, BALL_X_OFFSET($s0)						#  $t3 = &ball->x;
	sle	$s6, $t1, $t3							#  hit = $t1 <= $t3
	slt	$t4, $t3, $t2							#  hit = $t3 < $t2;
	and	$s6, $s6, $t4

move_ball_one_cell__hit_eq_1:

	bne	$s6, 1, move_ball_one_cell__hit_eq_1_false			#  if (hit != 1)
										#  goto (move_ball_...hit_eq_1_false);

move_ball_one_cell__hit_eq_1_true:

move_ball_one_cell__paddle_horizontal:

	bne	$s1, HORIZONTAL, move_ball_one_cell__paddle_horizontal_false	#  if (axis != HORIZONTAL)
										#  goto(move...paddle_horizontal_false);
	lw	$t6, BALL_DY_OFFSET($s0)					#  $t6 = &ball->dy;
	blez	$t6, move_ball_one_cell__paddle_horizontal_false		#  if (ball->dy <= 0)
										#  goto(move...paddle_horizontal_false);

move_ball_one_cell__paddle_horizontal_true:

	mul	$t6, $t6, -1							
	sw	$t6, BALL_DY_OFFSET($s0)					#  ball->dy *= -1;

	b	move_ball_one_cell__position_check_phi				#  goto(move...position_check_phi);

move_ball_one_cell__paddle_horizontal_false:

move_ball_one_cell__paddle_vertical_axis:

	bne	$s1, VERTICAL, move_ball_one_cell__paddle_vertical_axis_false	#  if (axis != VERTICAL)
										#  goto(move...vertical_axis_false);

move_ball_one_cell__paddle_vertical_axis_true:

move_ball_one_cell__horizontal_speed:
	lw	$t7, BALL_DX_OFFSET($s0)					#  $t7 = &ball->dx;
	li	$t2, PADDLE_WIDTH						#  $t2 = PADDLE_WIDTH;
	div	$t2, $t2, 2							#  PADDLE_WIDTH / 2;
	add	$t2, $t2, $t1							#  $t2 = paddle_x + PADDLE_WIDTH / 2;
	bge	$t3, $t2, move_ball_one_cell__horizontal_speed_false		#  if($t7 >= $t2) 
										#  goto(move...horizontal_speed_false);

move_ball_one_cell__horizontal_speed_true:

	sub	$t7, $t7, 3							
	sw	$t7, BALL_DX_OFFSET($s0)					#  ball->dx -= 3;

	b	move_ball_one_cell__max_speed					#  goto(move..one_cell__max_speed);

move_ball_one_cell__horizontal_speed_false:

	add	$t7, $t7, 3
	sw	$t7, BALL_DX_OFFSET($s0)					#  ball->dx += 3;

	b	move_ball_one_cell__max_speed					#  goto(move..one_cell__max_speed);

move_ball_one_cell__max_speed:

	li	$t8, BALL_FRACTION						#  $t8 = BALL_FRACTION;
	div	$t8, $t8, BALL_SIM_STEPS					#  $t8 = BALL_FRACTION / BALL_SIM_STEPS;

move_ball_one_cell__less_than_neg_max_speed:

	mul	$t8, $t8, -1							#  -max_speed;

	bge	$t7, $t8, move_ball_one_cell__less_than_neg_max_speed_false	#  if (ball->dx >= -max_speed)
										#  goto (move...less_than_
										#  neg_max_speed_false)

move_ball_one_cell__less_than_neg_max_speed_true:

	sw	$t8, BALL_DX_OFFSET($s0)					#  ball->dx = -max_speed;

move_ball_one_cell__less_than_neg_max_speed_false:

	mul	$t8, $t8, -1							#  return to max_speed;

move_ball_one_cell__more_than_max_speed:

	ble	$t7, $t8, move_ball_one_cell__more_than_max_speed_false		#  if (ball->dx <= max_speed)
										#  goto(move...more_than_
										#  max_speed_false);

move_ball_one_cell__more_than_max_speed_true:

	sw	$t8, BALL_DX_OFFSET($s0)					#  ball->dx = max_speed;

	b	move_ball_one_cell__hit_eq_1_false				#  goto(move...hit_eq_1_false);

move_ball_one_cell__more_than_max_speed_false:

	b	move_ball_one_cell__hit_eq_1_false				#  goto(move...hit_eq_1_false);

move_ball_one_cell__paddle_vertical_axis_false:

move_ball_one_cell__hit_eq_1_false:

	lw	$t9, combo_bonus						#  int combo_bonus;
	li	$t9, 0								
	sw	$t9, combo_bonus						#  combo_bonus = 0;	

	b	move_ball_one_cell__position_check_phi				#  goto(move...position_check_phi);



move_ball_one_cell__position_check_paddle_false:

move_ball_one_cell__check_hit_brick:

	lw	$t5, BALL_Y_OFFSET($s0)						#  &ball->y

	bge	$t5, GRID_HEIGHT, move_ball_one_cell__check_hit_brick_false	#  if (ball->y >= GRID_HEIGHT)
										#  goto(move...__check_hit_brick_false);
	lw	$t3, BALL_X_OFFSET($s0)						#  $t3 = &ball->x;
	mul	$t0, $t5, MAX_GRID_WIDTH					#  $t0 = ball->y * MAX_GRID_WIDTH;
	add	$t1, $t0, $t3							#  $t1 = $t0 + ball->x
	la	$t2, bricks 							#  &bricks;
	add	$t2, $t1, $t2							#  bricks[ball->y][ball->x]
	lb	$t2, ($t2)
	beq	$t2, 0, move_ball_one_cell__check_hit_brick_false		#  if (bricks[ball->y][ball->x] != 1)
										#  goto(move...check_hit_brick_false);

move_ball_one_cell__check_hit_brick_true:

move_ball_one_cell__brick_collision:

	li	$t9, BALL_SUPER							#  $t9 = BALL_SUPER;
	lb	$t0, BALL_STATE_OFFSET($s0)					#  $t0 = &ball->state;
	sne 	$s6, $t0, $t9							#  hit = ball->state != BALL_SUPER;

	lw	$a0, BALL_Y_OFFSET($s0)						#  argument 0: ball->y
	lw	$a1, BALL_X_OFFSET($s0)						#  argument 1: ball->x

	jal	hit_brick							#  hit_brick(ball->y, ball->x);

move_ball_one_cell__give_score:

	lw	$t0, combo_bonus						#  int combo_bonus;
	addi	$t0, $t0, 1							#  combo_bonus + 1;
	mul	$t1, $t0, 5							#  5 * (combo_bonus + 1);
	lw	$t2, score							#  int score;
	add	$t2, $t1, $t2							#  score + 5 * (combo_bonus + 1); 
	sw	$t2, score							#  score += 5 * (combo_bonus + 1);
	sw	$t0, combo_bonus

	b	move_ball_one_cell__position_check_phi				#  goto(move...position_check_phi);


move_ball_one_cell__check_hit_brick_false:

	b	move_ball_one_cell__position_check_phi				#  goto(move...position_check_phi);


move_ball_one_cell__position_check_phi:

move_ball_one_cell__check_if_hit:

	bne	$s6, TRUE, move_ball_one_cell__if_hit_phi			#  if (hit != 1)
										#  goto(move_ball_one_cell__if_hit_phi);


move_ball_one_cell__if_hit_true:

	li	$t0, BALL_NORMAL						#  $t0 = BALL_NORMAL
	sb	$t0, BALL_STATE_OFFSET($s0)					#  ball->state = BALL_NORMAL;
	li	$t1, BALL_FRACTION						#  $t1 = BALL_FRACTION
	sub	$t1, $t1, 1							#  BALL_FRACTION - 1

	lw	$t0, ($s5)							#  point to *axis_fraction
	sub	$t0, $t1, $t0							#  (BALL_FRACTION - 1) - *axis_fraction;
	sw	$t0, ($s5)							#  stored into *axis_fraction

	lw	$t1, ($s3)							#  point to *axis_position
	sub	$t1, $t1, $s2							#  *axis_position -= direction;
	sw	$t1, ($s3)							#  stored into *axis_position

	lw	$t2, ($s4)							#  point to *axis_velocity
	mul	$t2, $t2, -1							#  *axis_velocity *= -1;
	sw	$t2, ($s4)							#  stored into *axis_velocity

	b	move_ball_one_cell__if_hit_phi					#  goto(move_ball_one_cell__if_hit_phi);

move_ball_one_cell__if_hit_false:


move_ball_one_cell__if_hit_phi:

	lw	$a0, BALL_X_OFFSET($s0)						#  argument 0: ball->x
	lw	$a1, BALL_Y_OFFSET($s0)						#  argument 1: ball->y

	jal	register_screen_update						#  register_screen_update(
										#  			ball->x, ball->y
										#  );

move_ball_one_cell__epilogue:
	pop	$s6								#  remove return address and
	pop	$s5								#  saved registers from stack
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	end
	jr	$ra								#  return void;



################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

################################################################################
# .TEXT <run_command>
        .text
run_command:
	# Provided
	#
	# Frame:    [$ra]
	# Uses:     [$ra, $t0, $a0, $v0]
	# Clobbers: [$t0, $a0, $v0]
	#
	# Locals:
	#   - $t0: char command
	#
	# Structure:
	#   run_command
	#   -> [prologue]
	#     -> body
	#       -> cmd_a
	#       -> cmd_d
	#       -> cmd_A
	#       -> cmd_D
	#       -> cmd_dot
	#       -> cmd_semicolon
	#       -> cmd_comma
	#       -> cmd_question_mark
	#       -> cmd_s
	#       -> cmd_h
	#       -> cmd_p
	#       -> cmd_q
	#       -> bad_cmd
	#       -> ret_true
	#   -> [epilogue]

run_command__prologue:
	push	$ra

run_command__body:
	li	$v0, 4						# syscall 4: print_string
	li	$a0, str_run_command_prompt			# " >> "
	syscall							# printf(" >> ");

	li	$v0, 12						# syscall 4: read_charactera
	syscall							# scanf(" %c",
	move	$t0, $v0					#              &command);

	beq	$t0, 'a', run_command__cmd_a			# if (command == 'a') { ...
	beq	$t0, 'd', run_command__cmd_d			# } else if (command == 'd') { ...
	beq	$t0, 'A', run_command__cmd_A			# } else if (command == 'A') { ...
	beq	$t0, 'D', run_command__cmd_D			# } else if (command == 'D') { ...
	beq	$t0, '.', run_command__cmd_dot			# } else if (command == '.') { ...
	beq	$t0, ';', run_command__cmd_semicolon		# } else if (command == ';') { ...
	beq	$t0, ',', run_command__cmd_comma		# } else if (command == ',') { ...
	beq	$t0, '?', run_command__cmd_question_mark	# } else if (command == '?') { ...
	beq	$t0, 's', run_command__cmd_s			# } else if (command == 's') { ...
	beq	$t0, 'h', run_command__cmd_h			# } else if (command == 'h') { ...
	beq	$t0, 'p', run_command__cmd_p			# } else if (command == 'p') { ...
	beq	$t0, 'q', run_command__cmd_q			# } else if (command == 'q') { ...
	b	run_command__bad_cmd				# } else { ...

run_command__cmd_a:						# if (command == 'a') {
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	b	run_command__ret_true

run_command__cmd_d:						# } else if (command == 'd') { ...
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	b	run_command__ret_true

run_command__cmd_A:						# } else if (command == 'A') { ...
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	li	$a0, -1
	jal	move_paddle					#   move_paddle(-1);
	b	run_command__ret_true

run_command__cmd_D:						# } else if (command == 'D') { ...
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	li	$a0, 1
	jal	move_paddle					#   move_paddle(1);
	b	run_command__ret_true

run_command__cmd_dot:						# } else if (command == '.') { ...
	li	$a0, BALL_SIM_STEPS
	jal	move_balls					#   move_balls(BALL_SIM_STEPS);
	b	run_command__ret_true

run_command__cmd_semicolon:					# } else if (command == ';') { ...
	li	$a0, BALL_SIM_STEPS
	mul	$a0, $a0, 3					#   BALL_SIM_STEPS * 3
	jal	move_balls					#   move_balls(BALL_SIM_STEPS * 3);
	b	run_command__ret_true

run_command__cmd_comma:						# } else if (command == ',') { ...
	li	$a0, 1
	jal	move_balls					#   move_balls(1);
	b	run_command__ret_true

run_command__cmd_question_mark:					# } else if (command == '?') { ...
	jal	print_debug_info				#   print_debug_info();
	b	run_command__ret_true

run_command__cmd_s:						# } else if (command == 's') { ...
	jal	print_screen_updates				#   print_screen_updates();
	b	run_command__ret_true

run_command__cmd_h:						# } else if (command == 'h') { ...
	jal	print_welcome					#   print_welcome();
	b	run_command__ret_true

run_command__cmd_p:						# } else if (command == 'p') { ...
	li	$a0, TRUE
	sw	$a0, no_auto_print				#   no_auto_print = 1;
	jal	print_game					#   print_game();
	b	run_command__ret_true

run_command__cmd_q:						# } else if (command == 'q') { ...
	li	$v0, 10						#   syscall 10: exit
	syscall							#   exit(0);

run_command__bad_cmd:						# } else { ...

	li	$v0, 4						#   syscall 4: print_string
	li	$a0, str_run_command_bad_cmd_1			#   "Bad command: '"
	syscall							#   printf("Bad command: '");

	li	$v0, 11						#   syscall 11: print_character
	move	$a0, $t0					#           command
	syscall							#   putchar(       );

	li	$v0, 4						#   syscall 4: print_string
	li	$a0, str_run_command_bad_cmd_2			#   "'. Run `h` for help.\n"
	syscall							#   printf("'. Run `h` for help.\n");

	li	$v0, FALSE
	b	run_command__epilogue				#   return FALSE;

run_command__ret_true:						# }
	li	$v0, TRUE					# return TRUE;

run_command__epilogue:
	pop	$ra
	jr	$ra

################################################################################
# .TEXT <print_debug_info>
        .text
print_debug_info:
	# Provided
	#
	# Frame:    []
	# Uses:     [$v0, $a0, $t0, $t1, $t2, $t3]
	# Clobbers: [$v0, $a0, $t0, $t1, $t2, $t3]
	#
	# Locals:
	#   - $t0: int i, int row
	#   - $t1: struct ball *ball, int col
	#   - $t2: temporary copy of grid_width
	#   - $t3: temporary bricks[row][col] address calculations
	#
	# Structure:
	#   print_debug_info
	#   -> [prologue]
	#     -> body
	#       -> ball_loop_init
	#       -> ball_loop_cond
	#       -> ball_loop_body
	#       -> ball_loop_step
	#       -> row_loop_init
	#       -> row_loop_cond
	#       -> row_loop_body
	#         -> row_loop_init
	#         -> row_loop_cond
	#         -> row_loop_body
	#         -> row_loop_step
	#         -> row_loop_end
	#       -> row_loop_step
	#       -> row_loop_end
	#   -> [epilogue]

print_debug_info__prologue:

print_debug_info__body:
	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_1	# "      grid_width = "
	syscall					# printf("      grid_width = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, grid_width			#              grid_width
	syscall					# printf("%d",           );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_2	# "        paddle_x = "
	syscall					# printf("        paddle_x = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, paddle_x			#              paddle_x
	syscall					# printf("%d",         );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_3	# "bricks_destroyed = "
	syscall					# printf("bricks_destroyed = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, bricks_destroyed		#              bricks_destroyed
	syscall					# printf("%d",                 );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_4	# "    total_bricks = "
	syscall					# printf("    total_bricks = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, total_bricks		#              total_bricks
	syscall					# printf("%d",             );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_5	# "           score = "
	syscall					# printf("           score = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, score			#              score
	syscall					# printf("%d",      );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_6	# "     combo_bonus = "
	syscall					# printf("     combo_bonus = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, combo_bonus		#              combo_bonus
	syscall					# printf("%d",            );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_7	# "        num_screen_updates = "
	syscall					# printf("        num_screen_updates = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, num_screen_updates		#              num_screen_updates
	syscall					# printf("%d",                   );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');


	li	$v0, 4				# syscall 4: print_string
	li	$a0, str_print_debug_info_8	# "whole_screen_update_needed = "
	syscall					# printf("whole_screen_update_needed = ");

	li	$v0, 1				# sycall 1: print_int
	lw	$a0, whole_screen_update_needed	#              whole_screen_update_needed
	syscall					# printf("%d",                           );

	li	$v0, 11				# syscall 11: print_character
	li	$a0, '\n'
	syscall					# putchar('\n');
	syscall					# putchar('\n');

print_debug_info__ball_loop_init:
	li	$t0, 0				# int i = 0;

print_debug_info__ball_loop_cond:		# while (i < MAX_BALLS) {
	bge	$t0, MAX_BALLS, print_debug_info__ball_loop_end

print_debug_info__ball_loop_body:
	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_9	#   "ball["
	syscall					#   printf("ball[");

	li	$v0, 1				#   sycall 1: print_int
	move	$a0, $t0			#                i
	syscall					#   printf("%d",  );

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_21	#   "]:\n"
	syscall					#   printf("]:\n");

	mul	$t1, $t0, SIZEOF_BALL		#   i * sizeof(struct ball)
	addi	$t1, $t1, balls			#   ball = &balls[i]

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_10	#   "  y: "
	syscall					#   printf("  y: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_Y_OFFSET($t1)		#   ball->y
	syscall					#   printf("%d", ball->y);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_11	#   "  x: "
	syscall					#   printf("  x: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_X_OFFSET($t1)		#   ball->x
	syscall					#   printf("%d", ball->x);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_12	#   "  x_fraction: "
	syscall					#   printf("  x_fraction: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_X_FRAC_OFFSET($t1)	#   ball->x_fraction
	syscall					#   printf("%d", ball->x_fraction);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_13	#   "  y_fraction: "
	syscall					#   printf("  y_fraction: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_Y_FRAC_OFFSET($t1)	#   ball->y_fraction
	syscall					#   printf("%d", ball->y_fraction);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_14	#   "  dy: "
	syscall					#   printf("  dy: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_DY_OFFSET($t1)	#   ball->dy
	syscall					#   printf("%d", ball->dy);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_15	#   "  dx: "
	syscall					#   printf("  dx: ");

	li	$v0, 1				#   sycall 1: print_int
	lw	$a0, BALL_DX_OFFSET($t1)	#   ball->dx
	syscall					#   printf("%d", ball->dx);

	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_16	#   "  state: "
	syscall					#   printf("  state: ");

	li	$v0, 1				#   sycall 1: print_int
	lb	$a0, BALL_STATE_OFFSET($t1)	#   ball->state
	syscall					#   printf("%d", ball->state);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_17	#   " ("
	syscall					#   printf(" (");

	li	$v0, 11				#   sycall 11: print_character
	lb	$a0, BALL_STATE_OFFSET($t1)	#   ball->state
	syscall					#   printf("%c", ball->state);

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_18	#   ")\n"
	syscall					#   printf(")\n");

print_debug_info__ball_loop_step:
	addi	$t0, $t0, 1			#   i++;
	b	print_debug_info__ball_loop_cond

print_debug_info__ball_loop_end:		# }


print_debug_info__row_loop_init:
	li	$t0, 0				# int row = 0;

print_debug_info__row_loop_cond:		# while (row < GRID_HEIGHT) {
	bge	$t0, GRID_HEIGHT, print_debug_info__row_loop_end

print_debug_info__row_loop_body:
	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_19	#   "\nbricks["
	syscall					#   printf("\nbricks[");

	li	$v0, 1				#   sycall 1: print_int
	move	$a0, $t0			#                i
	syscall					#   printf("%d",  );

	li	$v0, 4				#   syscall 4: print_string
	li	$a0, str_print_debug_info_20	#   "]: "
	syscall					#   printf("]: ");

print_debug_info__col_loop_init:
	li	$t1, 0				#   int col = 0;

print_debug_info__col_loop_cond:		#   while (col < grid_width) {
	lw	$t2, grid_width
	bge	$t1, $t2, print_debug_info__col_loop_end

print_debug_info__col_loop_body:
	mul	$t3, $t0, MAX_GRID_WIDTH	#     row * MAX_GRID_WIDTH
	add	$t3, $t3, $t1			#     row * MAX_GRID_WIDTH + row
	addi	$t3, $t3, bricks		#     &bricks[row][col]

	li	$v0, 1				#     sycall 1: print_int
	lb	$a0, ($t3)			#     bricks[row][col]
	syscall					#     printf("%d", bricks[row][col]);

	li	$v0, 11				#     sycall 11: print_character
	li	$a0, ' '
	syscall					#     printf(" ");

print_debug_info__col_loop_step:
	addi	$t1, $t1, 1			#     row++;
	b	print_debug_info__col_loop_cond

print_debug_info__col_loop_end:			#   }

print_debug_info__row_loop_step:
	addi	$t0, $t0, 1			#   row++;
	b	print_debug_info__row_loop_cond

print_debug_info__row_loop_end:			# }
	li	$v0, 11				#   syscall 11: print_character
	li	$a0, '\n'
	syscall					#   putchar('\n');

print_debug_info__epilogue:
	jr	$ra


################################################################################
# .TEXT <print_screen_updates>
        .text
print_screen_updates:
	# Provided
	#
	# Frame:    [$ra, $s0, $s1, $s2]
	# Uses:     [$ra, $s0, $s1, $s2, $t0, $t1, $t2, $t3, $t4, $v0, $a0]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $v0, $a0]
	#
	# Locals:
	#   - $t0: print_cell return value, temporary screen_updates address calculations
	#   - $t1: copy of num_screen_updates
	#   - $t2: copy of whole_screen_update_needed
	#   - $t3: copy of grid_width
	#   - $t4: FALSE/0
	#   - $s0: int row, int i
	#   - $s1: int col, int y
	#   - $s2: int x
	#
	# Structure:
	#   print_screen_updates
	#   -> [prologue]
	#       -> body
	#       -> whole_screen
	#         -> row_loop_init
	#         -> row_loop_cond
	#         -> row_loop_body
	#           -> col_loop_init
	#           -> col_loop_cond
	#           -> col_loop_body
	#           -> col_loop_step
	#           -> col_loop_end
	#         -> row_loop_step
	#         -> row_loop_end
	#       -> not_whole_screen
	#         -> update_loop_init
	#         -> update_loop_cond
	#         -> update_loop_body
	#         -> update_loop_step
	#         -> update_loop_end
	#       -> final_newline
	#   -> [epilogue]

print_screen_updates__prologue:
	push	$ra
	push	$s0
	push	$s1
	push	$s2

print_screen_updates__body:
	li	$v0, 11							# sycall 11: print_character
	li	$a0, '&'
	syscall								# putchar('&');

	li	$v0, 1							#   syscall 1: print_int
	lw	$a0, score						#                score
	syscall								#   printf("%d",      );

	lw	$t2, whole_screen_update_needed

	beqz	$t2, print_screen_updates__not_whole_screen		# if (whole_screen_update_needed) {

print_screen_updates__whole_screen:
	lw	$t3, grid_width

print_screen_updates__row_loop_init:
	li	$s0, 0							#   int row = 0;

print_screen_updates__row_loop_cond:
	bge	$s0, GRID_HEIGHT, print_screen_updates__row_loop_end	#   while (row < GRID_HEIGHT) {

print_screen_updates__row_loop_body:
print_screen_updates__col_loop_init:
	li	$s1, 0							#     int col = 0;

print_screen_updates__col_loop_cond:
	lw	$t3, grid_width
	bge	$s1, $t3, print_screen_updates__col_loop_end		#     while (col < grid_width) {

print_screen_updates__col_loop_body:
	move	$a0, $s0						#       row
	move	$a1, $s1						#       col
	jal	print_cell						#       print_cell(row, col);
	move	$t0, $v0

	li	$v0, 11							#       sycall 11: print_character
	li	$a0, ' '
	syscall								#       printf(" ");

	li	$v0, 1							#       sycall 1: print_int
	move	$a0, $s0						#                    row
	syscall								#       printf("%d",    );

	li	$v0, 11							#       sycall 11: print_character
	li	$a0, ' '
	syscall								#       printf(" ");

	li	$v0, 1							#       sycall 1: print_int
	move	$a0, $s1						#                    col
	syscall								#       printf("%d",    );

	li	$v0, 11							#       sycall 11: print_character
	li	$a0, ' '
	syscall								#       printf(" ");

	li	$v0, 1							#       sycall 1: print_int
	move	$a0, $t0						#                    print_cell(...)
	syscall								#       printf("%d",                );

print_screen_updates__col_loop_step:

	addi	$s1, $s1, 1						#       col++;
	b	print_screen_updates__col_loop_cond			#     }

print_screen_updates__col_loop_end:
print_screen_updates__row_loop_step:
	addi	$s0, $s0, 1						#     row++;
	b	print_screen_updates__row_loop_cond			#   }


print_screen_updates__row_loop_end:
	b	print_screen_updates__final_newline			# } else {

print_screen_updates__not_whole_screen:
print_screen_updates__update_loop_init:
	li	$s0, 0							#   int i = 0;

print_screen_updates__update_loop_cond:
	lw	$t1, num_screen_updates
	bge	$s0, $t1, print_screen_updates__update_loop_end		#   while (i < num_screen_updates) {

print_screen_updates__update_loop_body:
	mul	$t0, $s0, SIZEOF_SCREEN_UPDATE				#     i * sizeof(struct screen_update)
	addi	$t0, $t0, screen_updates				#     &screen_updates[i]

	lw	$s1, SCREEN_UPDATE_Y_OFFSET($t0)			#     int y = screen_updates[i].y;
	lw	$s2, SCREEN_UPDATE_X_OFFSET($t0)			#     int x = screen_updates[i].x;

									#     if (y >= GRID_HEIGHT) continue;
	bge	$s1, GRID_HEIGHT, print_screen_updates__update_loop_step

	bltz	$s2, print_screen_updates__update_loop_step		#     if (x < 0) continue;

									#     if (x >= MAX_GRID_WIDTH) continue;
	bge	$s2, MAX_GRID_WIDTH, print_screen_updates__update_loop_step

	move	$a0, $s1						#     y
	move	$a1, $s2						#     x
	jal	print_cell						#     print_cell(y, x);
	move	$t0, $v0

	li	$v0, 11							#     sycall 11: print_character
	li	$a0, ' '
	syscall								#     printf(" ");

	li	$v0, 1							#     sycall 1: print_int
	move	$a0, $s1						#                  y
	syscall								#     printf("%d",  );

	li	$v0, 11							#     sycall 11: print_character
	li	$a0, ' '
	syscall								#     printf(" ");

	li	$v0, 1							#     sycall 1: print_int
	move	$a0, $s2						#                  x
	syscall								#     printf("%d",  );

	li	$v0, 11							#     sycall 11: print_character
	li	$a0, ' '
	syscall								#     printf(" ");

	li	$v0, 1							#     sycall 1: print_int
	move	$a0, $t0						#                  print_cell(...)
	syscall								#     printf("%d",                );

print_screen_updates__update_loop_step:
	addi	$s0, $s0, 1						#     col++;
	b	print_screen_updates__update_loop_cond			#   }

print_screen_updates__update_loop_end:
print_screen_updates__final_newline:					# }
	li	$v0, 11							# syscall 11: print_character
	li	$a0, '\n'
	syscall								# putchar('\n');

	li	$t4, FALSE
	sw	$t4, whole_screen_update_needed				# whole_screen_update_needed = FALSE;

	li	$t4, 0
	sw	$t4, num_screen_updates					# num_screen_updates = 0;

print_screen_updates__epilogue:

	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra

	jr	$ra
