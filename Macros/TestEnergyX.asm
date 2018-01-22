;Used for checking the X location in energy
TestEnergyX	.macro 
	LDA $0203
	STA Temp1
	LDA \1			;Argument1 = Value to test for
	STA Temp2
	
	JSR GetDifference
	CMP #$05
	BCS .skipX\@

	;The value is within X range, so set the color
	LDA #$0F
	STA \2
	LDA \3
	STA \2+12
	
.skipX\@	

	.endm