;The bits are as follows:
;[7][3][6]
;[1]   [0]
;[5][2][4]


PreviousWalls	.macro

	TYA		;Make sure X = Y
	CLC
	ADC #12	;Add 12 to avoid overflows on lines above 4
	TAX

	LDA Temp1	;Backup temp1 into temp2
	STA Temp2
	
	LDA Temp2	;Shift to the previous bit
	ASL A
	BCC .cont\@		;If there is a carry, shift into the previous byte
	DEX
	LDA #$01
	
.cont\@	
	STA Temp2
	LDA $0400, X
	AND Temp2
	BEQ .zero1\@
	LDA #%00000010
	STA Tiles+1
	JMP .next1\@
	
.zero1\@
	LDA #$00
	STA Tiles+1
	
.next1\@
	DEX
	DEX
	DEX		;Subtract x four times, to go back 4 bits
	DEX
	
	;And repeat this code
	LDA $0400, X
	AND Temp2
	BEQ .zero2\@
	LDA #%10000000
	STA Tiles+7
	JMP .next2\@
	
.zero2\@
	LDA #$00
	STA Tiles+7
	
.next2\@
	TXA
	CLC
	ADC #$08	;Add 8 to X
	TAX
	
	;And repeat this code
	LDA $0400, X
	AND Temp2
	BEQ .zero3\@
	LDA #%00100000
	STA Tiles+5
	JMP .next3\@
	
.zero3\@	
	LDA #$00
	STA Tiles+5
	
.next3\@
	
	.endm
	
	
	
	
	
NextWalls	.macro

	TYA		;Make sure X = Y
	CLC
	ADC #12	;Add 12 to avoid overflows on lines above 4
	TAX

	LDA Temp1	;Backup temp1 into temp2
	STA Temp2
	
	LDA Temp2	;Shift to the previous bit
	LSR A
	BCC .cont\@		;If there is a carry, shift into the next byte
	INX
	LDA #$80
	
.cont\@	
	STA Temp2
	LDA $0400, X
	AND Temp2
	BEQ .zero1\@
	LDA #%00000001
	STA Tiles
	JMP .next1\@
	
.zero1\@
	LDA #$00
	STA Tiles
	
.next1\@	
	DEX
	DEX
	DEX		;Subtract x four times, to go back 4 bits
	DEX
	
	;And repeat this code
	LDA $0400, X
	AND Temp2
	BEQ .zero2\@
	LDA #%01000000
	STA Tiles+6
	JMP .next2\@
	
.zero2\@
	LDA #$00
	STA Tiles+6
	
.next2\@
	TXA
	CLC
	ADC #$08	;Add 8 to X
	TAX
	
	;And repeat this code
	LDA $0400, X
	AND Temp2
	BEQ .zero3\@
	LDA #%00010000
	STA Tiles+4
	JMP .next3\@
	
.zero3\@	
	LDA #$00
	STA Tiles+4
	
.next3\@	
	.endm
	
	
	
	
	
CurrentWalls	.macro
	TYA		;Make sure X = Y
	CLC
	ADC #12	;Add 12 to avoid overflows on lines above 4
	TAX

	;Go forward 4 bytes
	INX
	INX
	INX
	INX
	
	LDA $0400, X
	AND Temp1
	BEQ .zero1\@
	LDA #%00000100
	STA Tiles+2
	JMP .next1\@
	
.zero1\@	
	LDA #$00
	STA Tiles+2
	
.next1\@	
	TXA
	SEC		;Subtract 8 to go backwards
	SBC #$08
	TAX
	
	LDA $0400, X
	AND Temp1
	BEQ .zero2\@
	LDA #%000001000
	STA Tiles+3
	JMP .next2\@
	
.zero2\@	
	LDA #$00
	STA Tiles+3
	
.next2\@
	
	.endm