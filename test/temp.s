	.thumb
	.syntax unified

.section .text
	.org 0
	.long    0x20008000
	.long    _start + 1

_start:
	ldr r5, = #1234
	ldr r4, = #1234
	ldr r8, = #20
	mov r8, #20
	ldr r3, = #1000
