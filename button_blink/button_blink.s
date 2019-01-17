@ Blink PORTD Pins fast with button

@ Start with enabling thumb mode since Cortex-M3 do not work with arm mode
	.thumb
	.syntax unified

@ Equates start
@ Variables
	.equ     STACKINIT,     0x20008000
	.equ     LED_DELAY,     400000
	.equ     BUTTON_DELAY,  1000000

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
@ RCC_APB2ENR |= 0x60
	ldr r6, = RCC_APB2ENR
	ldr r2, [r6]
	orr r2, r2, 0x00000070
	str r2, [r6]

@ Set GPIOD Low pins as output
	ldr r6, = GPIOD_CRL
	ldr r2, = 0x33333333
	str r2, [r6]

@ Set GPIOD High pins as output
	ldr r6, = GPIOD_CRH
	ldr r2, = 0x33333333
	str r2, [r6]

@ Set GPIOE High pins as output
	ldr r6, = GPIOE_CRH
	ldr r2, = 0x33333333
	str r2, [r6]

@ Set GPIOC Pin0 as input
	ldr r6, = GPIOC_CRL
	ldr r2, [r6]
	and r2, 0xFFFFFFF0
	orr r2, 0x00000008
	str r2, [r6]

@ Set GPIOE to 0
	ldr r6, = GPIOE_ODR
	ldr r2, = 0x00000000
	str r2, [r6]

@ Load the addresses to registers
	ldr r6, = GPIOD_ODR
	ldr r5, = GPIOC_IDR

@ Initial load the LEDs.
@ Since the port has 16 LEDs attached to it, and rotate works on 32-bits
@ added one more set to keep the flow going...
	ldr r2, = 0x00070007
	str r2, [r6]

@ wait for button press to start blinking

@ jump here to eliminate debouncing and button press time
delayed_wait:
	ldr r1, = BUTTON_DELAY
	bl delay

@ wait for button press
wait:
	ldr r3, [r5]
	and r3, 0x00000001
	cmp r3, 0
	beq wait

	@ eliminate debouncing and button press time
	ldr r1, = BUTTON_DELAY
	bl delay

@ keep rotating LEDs
loop:
	ror r2, #1
	str r2, [r6]

	@ check button press
	ldr r3, [r5]
	and r3, 0x00000001
	cmp r3, 1
	beq delayed_wait

	ldr r1, = LED_DELAY
	bl delay

	b loop

delay:
	subs r1, 1
	bne delay
	bx lr
