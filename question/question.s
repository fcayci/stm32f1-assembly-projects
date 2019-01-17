@ Question
	.thumb
	.syntax unified

.section .text
	.org 0
	.word    0x20008000
	.word    _start + 1

_start:
	ldr r0, =#0
	push {r0-r12}
	pop {r0-r12}

	adr r7, scissors
	adr r6, paper
	adr r0, lizard

	ldr r5, = #0xc
	ldr r1, = #17

rock:
	ldr r2, [r7], #4
	cbz r2, spock
	ldr r4, [r6], #4
	cbz r4, spock
	mla r3, r2, r4, r5
	eors r3, r1
	push {r3}
	b rock

spock:
	b spock

scissors:
	.word 0x0c
	.word 0x02
	.word 0x02
	.word 0x06
	.word 0x05
	.word 0x05
	.word 0x03
	.word 0x06
	.word 0x0a
	.word 0x02
	.word 0x04
	.word 0x00

lizard:
	.word 0x21
	.word 0x14
	.word 0x2b
	.word 0x3
	.word 0x35
	.word 0x0b
	.word 0x15
	.word 0x10
	.word 0x01
	.word 0x23
	.word 0x45
	.word 0x00

paper:
	.word 0x06
	.word 0x34
	.word 0x0b
	.word 0x13
	.word 0x05
	.word 0x0b
	.word 0x07
	.word 0x11
	.word 0x0b
	.word 0x2b
	.word 0x09
	.word 0x00
