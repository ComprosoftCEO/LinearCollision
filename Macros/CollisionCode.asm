TestCode	.macro 
	
	;Temp1 = XTile
	;Temp2 = YTile
	
;Reset various registers
	LDA #$00
	STA CollisionByte	;Reset collision byte
	STA CollisionBit	;And collision bit
	
	
	;Divide X tile by 8 to find out what bit to use
	LDA Temp1			;Temp1 = XTile 
.loopT1\@
	INC CollisionByte
	SEC
	SBC #$08
	BCS .loopT1\@
	DEC CollisionByte	;Loop returns the roof, so make the collision byte the floor
	
	
	;Calculate the collision bit
	CLC
	ADC #$09
	TAX
	SEC
.loopT2\@
	ROR CollisionBit			;Roll left to find out which bit to chedk
	CLC
	DEX
	BNE .loopT2\@
	
	
	;Add the Y value*4 to the collision byte
	LDX Temp2
	INX				;Add 1 so there is no overflow
	LDA CollisionByte
	SEC
	SBC #$04		;Each line number = 4 bytes, so subtract 4 to offset
.loopT3\@
	CLC
	ADC #$04
	DEX
	BNE .loopT3\@
	STA CollisionByte
	TAX
	
	
	;Now, get the data, and test for a collision
	LDA CollisionData, X
	AND CollisionBit
	STA \1
	
	.endm