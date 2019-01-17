	.thumb
	.syntax unified
	.equ GPIOD_ODR, 0x40010C00

.section .text
	.org 0
	.word 0x20008000
	.word _start + 1

_start:
	ldr r4, =GPIOD_ODR
	adr r1, scissors
	ldr r2, [r1], #4
	bx  r2
	ldr r3, [r4] 
	eors r3, 0x80
	str r3, [r4]
	ldr r2, [r1], #4
	bx r2

scissors:
	.word 0x800012
	.word 0x80000A
