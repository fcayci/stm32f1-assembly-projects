@ Blink PORTD Pin 0 at roughly 1 second
@ blink_led
@
@ Decription:
@   Blink PORTD Pin 0 at roughly 1 second using SYSTICK timer
@
@ Author: Furkan Cayci
@
@ Project Setup:
@   EasyMX Pro V7 board
@   Cortex-M3 arch
@   STM32F107 chip
@
@   PORTD Pin0 is the LED

@ Main clock source is running with HSI by default which is at 8 Mhz.
@ SysTick clock source can be set with CTRL register (Bit 2) (pm0056 - page 151)
@ Bit2 -> 0: AHB/8 -> (1 MHz)
@ Bit2 -> 1: Processor clock (AHB) -> (8 MHz)


@ Start with enabling thumb mode since Cortex-M3 do not work with arm mode
	.thumb
	.syntax unified

@ Equates start
@ Variables
	.equ     STACKINIT,     0x20008000

@ Addresses for registers
	.equ     RCC_APB2ENR,   0x40021018      @ enable clock (Page 49 from RM0008)
	.equ     GPIOD_CRL,     0x40011400      @ PORTD control register low
	.equ     GPIOD_ODR,     0x4001140C      @ PORTD output data (Page 172 from RM0008)
	.equ     SYSTICK_CTRL,  0xE000E010      @ SYSTICK control register
	.equ     SYSTICK_LOAD,  0xE000E014      @ SYSTICK reload value
@ Equates end

.section .text
	.org 0

@ Vector table start
	.word    STACKINIT
	.word    _start + 1
@ Vector table end

@ Main program starts from here
_start:

	@ Enable clock on GPIOD
	@ RCC_APB2ENR |= 0x20
	ldr r6, = RCC_APB2ENR
	ldr r2, [r6]
	orr r2, r2, 0x00000020
	str r2, [r6]

	@ Set GPIOD Pin0 as output
	@ GPIOD_CRL = 0x00000003
	ldr r6, = GPIOD_CRL
	ldr r2, = 0x00000003
	str r2, [r6]

	@ Load the reload value for the counter.
	@ This will generate roughly 1 Hz counter (which is 1s)
	ldr r5, = SYSTICK_LOAD
	ldr r2, = #0x100000
	str r2, [r5]

	@ Load the address to a register
	ldr r6, = GPIOD_ODR
	ldr r5, = SYSTICK_CTRL

	@ Enable systick counter
	ldr r1, = 0x00001
	ldr r4, [r5]         @ Read SYSTICK control register
	orr r4, r1           @ Enable the SYSTICK timer
	str r4, [r5]         @ Write back the value

	@ start blinking
	@ 1. GPIOD_ODR = GPIOD_ODR ^ 0x00000001
	@ 2. wait for systick counter
	@ 5. goto 1

loop:
	ldr r2, [r6]         @ Load GPIOD_ODR content to r2
	eor r2, 0x0000001    @ OR the content with 0x1, not to alter the rest of the bits
	str r2, [r6]         @ Store back the result

	bl delay             @ Jump to delay function with setting LR register to return back to here

	b loop               @ Jump back to the loop

delay:
	ldr r4, [r5]
	ands r4, 0x10000	@ Bit 16 is the countflag that shows counter reached to 0
	beq delay
	bx lr                @ Jump to where LR register points to
