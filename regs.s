@ EE 304 - STM32F107 Regs

@ Addresses for registers
	.equ     RCC_CR,        0x40021000      @ clock control register
	.equ     RCC_CFGR,      0x40021004      @ clock config register
	.equ     RCC_CFGR2,     0x4002102C

	.equ     RCC_APB2RSTR,  0x4002100C      @ peripheral reset register
	.equ     RCC_APB2ENR,   0x40021018      @ enable clock

	.equ     GPIOA_CRL,     0x40010800      @ PORTA control low
	.equ     GPIOA_CRH,     0x40010804      @ PORTA control high
	.equ     GPIOA_IDR,     0x40010808      @ PORTA input data
	.equ     GPIOA_ODR,     0x4001080C      @ PORTA output data
	.equ     GPIOA_BSR,     0x40010810      @ PORTA bit set/reset
	.equ     GPIOA_BRR,     0x40010814      @ PORTA bit reset

	.equ     GPIOB_CRL,     0x40010C00      @ PORTB control register low
	.equ     GPIOB_CRH,     0x40010C04      @ PORTB control register high
	.equ     GPIOB_IDR,     0x40010C08      @ PORTB input data
	.equ     GPIOB_ODR,     0x40010C0C      @ PORTB output data
	.equ     GPIOB_BSR,     0x40010C10      @ PORTB bit set/reset
	.equ     GPIOB_BRR,     0x40010C14      @ PORTB bit reset

	.equ     GPIOC_CRL,     0x40011000      @ PORTC control register low
	.equ     GPIOC_CRH,     0x40011004      @ PORTC control register high
	.equ     GPIOC_IDR,     0x40011008      @ PORTC input data
	.equ     GPIOC_ODR,     0x4001100C      @ PORTC output data
	.equ     GPIOC_BSR,     0x40011010      @ PORTC bit set/reset
	.equ     GPIOC_BRR,     0x40011014      @ PORTC bit reset

	.equ     GPIOD_CRL,     0x40011400      @ PORTD control register low
	.equ     GPIOD_CRH,     0x40011404      @ PORTD control register high
	.equ     GPIOD_IDR,     0x40011408      @ PORTD input data
	.equ     GPIOD_ODR,     0x4001140C      @ PORTD output data
	.equ     GPIOD_BSR,     0x40011410      @ PORTD bit set/reset
	.equ     GPIOD_BRR,     0x40011414      @ PORTD bit reset

	.equ     GPIOE_CRL,     0x40011800      @ PORTE control register low
	.equ     GPIOE_CRH,     0x40011804      @ PORTE control register high
	.equ     GPIOE_IDR,     0x40011808      @ PORTE input data
	.equ     GPIOE_ODR,     0x4001180C      @ PORTE output data
	.equ     GPIOE_BSR,     0x40011810      @ PORTE bit set/reset
	.equ     GPIOE_BRR,     0x40011814      @ PORTE bit reset

	.equ     GPIOF_CRL,     0x40011C00      @ PORTF control register low
	.equ     GPIOG_CRL,     0x40012000      @ PORTG control register low
