@ EE304 Project #1 - Fibonacci Series
@
@ Decription:
@   The code calculates the next number in the series and divides the number
@   to each digit, then displays the digit in morse code using a lookup table
@   stored in the RAM area.
@
@ Author: Furkan Cayci
@
@ Project Setup:
@   EasyMX Pro V7 board
@   Cortex-M3 arch
@   STM32F107 chip
@
@   PORTC Pin0 is the button to start the operation
@   PORTD Pins0-3 displays the group number (1010)
@   PORTD Pin8 displays the morse code

@ Morse codes for digits:
@   0 - - - - -
@   1 . - - - -
@   2 . . - - -
@   3 . . . - -
@   4 . . . . -
@   5 . . . . .
@   6 - . . . .
@   7 - - . . .
@   8 - - - . .
@   9 - - - - .

@ Start with enabling thumb mode since Cortex-M3 do not work with arm mode
	.thumb
	.syntax unified

@ Equates start
@ Variables
	.equ     STACKINIT,     0x20008000
	.equ     UNIT_DELAY,    600000
	.equ     FIB_SEQ,       20
	.equ     DIVISOR,       1000
	.equ     TEAM_NUMBER,   0b1010

@ Addresses for registers
	.include "../regs.s"        @"@"
@ Equates end

.section .text
	.org 0

@ Vector table start
	.long    STACKINIT
	.long    _start + 1
@ Vector table end

@ Main program starts from here
_start:

@ Enable clock on GPIOC (bit 4) and GPIOD (bit 5) and GPIOE (bit 6)
@ (RCC_APB2ENR |= 0x60)
	ldr r7, = RCC_APB2ENR
	ldr r2, [r7]
	orr r2, 0x00000070
	str r2, [r7]

@ Set GPIOD Pins 0-3 as output
	ldr r7, = GPIOD_CRL
	ldr r2, = 0x00003333
	str r2, [r7]

@ Set GPIOD Pin 8 as output
	ldr r7, = GPIOD_CRH
	ldr r2, = 0x00000003
	str r2, [r7]

@ Set GPIOE High pins as output
	ldr r7, = GPIOE_CRH
	ldr r2, = 0x33333333
	str r2, [r7]

@ Set GPIOC Pin0 as input
	ldr r7, = GPIOC_CRL
	ldr r2, [r7]
	and r2, 0xFFFFFFF0
	orr r2, 0x00000008
	str r2, [r7]

@ Set GPIOE to 0
	ldr r7, = GPIOE_ODR
	ldr r2, = 0x00000000
	str r2, [r7]

beginning:

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ MODE 1: set the LEDs and wait for button press to start execution

@ Set GPIOD Pins 0 -3 to dispaly 1010
	ldr r7, = GPIOD_ODR
	ldr r2, = TEAM_NUMBER
	str r2, [r7]

@ Load button addresses to registers
	ldr r7, = GPIOC_IDR

wait_for_button:
	ldr r2, [r7]
	and r2, 0x00000001
	cmp r2, #0
	beq wait_for_button

	ldr r7, = GPIOD_ODR
	ldr r2, = 0x5
	str r2, [r7]

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ MODE 2: Start calculation and display

@ Initial values of Finonacci Series
@ r5 should always hold the last value
	ldr r4, = #3
	ldr r5, = #5

@ Value to be displayed
	ldr r6, = FIB_SEQ @ Calculate 20 sequences

next_number_in_series:
	ldr r3, = DIVISOR @ Divisor 4 digits max (1000)
	subs r6, #1   @ If 20 of them are displayed go back to beginning
	beq beginning

@ Calculate next value
	add r4, r5
	@ Value swap trick so r5 shows the last value
	eor r4, r5
	eor r5, r4
	eor r4, r5
	mov r10, r5	 @ Copy the value so it doesnt get lost

@ r6 number counter
@ r5 Fibonacci series #1 (current)
@ r4 Fibonacci series #2 (previous)
@ r3 divisor (1000, 100, 10, 1)
next_digit_in_number:
	udiv r2, r10, r3        @ Divide the number get the most significant digit.
	cmp r2, #0
	beq next_digit         @ If msd is 0, then skip displaying

	ldr r1, = UNIT_DELAY
	ldr r0, = #2
	mul r1, r0
	bl delay

	bl display_digit       @ Call display_digit function

	@ Delay 1 second
	ldr r1, = UNIT_DELAY
	bl delay

	muls r2, r3            @ Calculate the value to be subtracted from dividend
	subs r10, r2           @ Subtract the msd from the number
	bne next_digit         @ If the result is not zero, the divisor is too big

	@ Operation is complete, delay 6 more seconds and go to the next number
	ldr r1, = UNIT_DELAY
	ldr r0, = #6
	mul r1, r0
	bl delay
	@ If reached here - number is displayed. Go to next number
	b next_number_in_series


next_digit:  @ Divide the divisor by 10 and jump back to beginning
	ldr r2, = #10
	udiv r3, r2
	b next_digit_in_number

delay:
	subs r1, 1
	bne delay
	bx lr

@ r6 number counter
@ r5 Fibonacci series #1 (current)
@ r4 Fibonacci series #2 (previous)
@ r3 divisor (1000, 100, 10, 1)
@ r2 number to be displayed
display_digit:
	adr r0, morse           @ Assign the starting point of the array to r0
	lsl r1, r2, #2              @ Multiply r2 with 4 since each word is 4 bytes
	ldr r8, [r0, r1]        @ Assign the contents of offset address (r8 = r0[r2])
	clz r0, r8              @ Count the leading zeros in the loaded value
	rsb r0, #33             @ Reverse subtract from 33 to get the max shift value
	                        @ This should be 32 but the way it is checked, we increase by 1

shifter:
	and r9, r8, #0x00000001 @ r1 LSB is either 0 or 1
	lsl r9, #8              @ Move that number 8 times to display on LED 8
	ldr r1, [r7]            @ Read the register content
	and r1, #0xFFFFF0FF     @ Isolate the bits
	orr r9, r1              @ Or the result so the rest wouldnt change
	str r9, [r7]            @ Store back the result

	subs r0, #1             @ See if we rotated enough
	beq end_digit
	lsr r8, #1
	ldr r1, = UNIT_DELAY

char_delay:
	subs r1, 1
	bne char_delay

	b shifter

end_digit:
	@ Zero out the contents
	ldr r0, [r7]            @ Read the register content
	and r0, #0xFFFFF0FF
	str r0, [r7]
	bx lr                   @ Return back to the main program

.align @ Align the address to 4 bytes (optional)

@ Put these in RAM area (optional)
@section .data
@	.org 0
@ Morse code section, reversed since LSB is displayed first
@ Each dash is represented with three 1s and each dot is one 1
@ In between there are 0s for one unit delay
morse:
	.word 0b1110111011101110111 @ 0
	.word 0b11101110111011101   @ 1
	.word 0b111011101110101     @ 2
	.word 0b1110111010101       @ 3
	.word 0b11101010101         @ 4
	.word 0b101010101           @ 5
	.word 0b10101010111         @ 6
	.word 0b1010101110111       @ 7
	.word 0b101011101110111     @ 8
	.word 0b10111011101110111   @ 9
	.word 0b0000000000000000000 @ undefined
	
