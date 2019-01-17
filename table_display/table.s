@ table.s
@
@ Decription:
@   Display the array of numbers on PORTD LEDs in binary.
@   It goes back to beginning when a 0 is detected.
@
@ Author: Furkan Cayci
@
@ Project Setup:
@   EasyMX Pro V7 board
@   Cortex-M3 arch
@   STM32F107 chip
@
@   PORTD Pins are output LEDs

@ Start with enabling thumb mode since Cortex-M3 do not work with arm mode
	.thumb
	.syntax unified

@ Equates start
@ Variables
	.equ     STACKINIT,     0x20008000
	.equ     LED_DELAY,     1000000

@ Addresses for registers
	.equ     RCC_APB2ENR,   0x40021018      @ enable clock (Page 49 from RM0008)
	.equ     GPIOD_CRL,     0x40011400      @ PORTD control register low
	.equ     GPIOD_CRH,     0x40011404      @ PORTD control register high
	.equ     GPIOD_ODR,     0x4001140C      @ PORTD output data (Page 172 from RM0008)
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
@ RCC_APB2ENR |= 0x60
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

@ Load the LED addresses to register
	ldr r6, = GPIOD_ODR

@ Initial load the LEDs.
	ldr r2, = 0x00000000
	str r2, [r6]

main:
	ldr r4, = ARRAY_START   @ Copy the starting address of the array to r4

loop:
    @ Copy the content of r4 to r2 and increment r4 by 4
	@  since the array values are word aligned (4 bytes)
	ldr r2, [r4], #4
	cmp r2, #0
	beq main

	@ Display the number
	str r2, [r6]

	@ Delay
	ldr r1, = LED_DELAY
	bl delay

	b loop

delay:
	subs r1, 1
	bne delay
	bx lr


.section .data
	.org 0

ARRAY_START:
	.word 1
	.word 2
	.word 4
	.word 8
	.word 16
	.word 32
	.word 64
	.word 128
	.word 256
	.word 512
	.word 1024
	.word 2048
	.word 4096
	.word 12345
	.word 0
