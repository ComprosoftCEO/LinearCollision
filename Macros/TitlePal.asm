TitlePal	.macro
	LDX \1
	LDA PlayFieldColors, X
	STA \2
	INX
	TXA
	AND #$0F
	STA \1
	
	.endm