@ Shift 3 LEDs on PORTD LEDs

@ Start with enabling thumb mode since Cortex-M3 do not work with arm mode
	.thumb
	.syntax unified

@ Equates start
@ Variables
	.equ     STACKINIT,     0x20008000
	.equ     DELAY,         400000

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

@ Enable clock on GPIOD (bit 5) and GPIOE (bit 6)
@ (RCC_APB2ENR |= 0x60)
	ldr r6, = RCC_APB2ENR
	ldr r2, [r6]
	orr r2, r2, 0x00000060
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

@ Set GPIOE to 0
	ldr r6, = GPIOE_ODR
	ldr r2, = 0x00000000
	str r2, [r6]

@ Load the address to a register
	ldr r6, = GPIOD_ODR

	ldr r2, = 0x00070007
@ start blinking
loop:
	ror r2, #1
	str r2, [r6]

	ldr r1, = DELAY
	bl 0x8000044

	b loop

delay:
	subs r1, 1
	bne delay
	bx lr
