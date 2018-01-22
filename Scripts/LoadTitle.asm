
	LDX #$00			;Load the background
	LDY #$00
	
	LDA $2002             ; read PPU status to reset the high/low latch
	LDA #$20
	STA $2006             ; write the high byte of $2000 address
	LDA #$20
	STA $2006             ; write the low byte of $2000 address

LoadR1:					;Load first row
	LDA Row1, X
	INX
	STA $2007
	DEY
	CPY #$00
	BNE LoadR1

	LDX #$00			
	LDY #$A0	
	
LoadR2:				;Load second row
	LDA Row2, X
	INX
	STA $2007
	DEY
	CPY #$00
	BNE LoadR2