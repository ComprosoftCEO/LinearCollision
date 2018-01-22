CheatColor:	.macro
	;Arguments:
	;  1 = Number to test
	;  2 = Palette to load
	;  3 = Place to store


	LDA CheatMode
	
	AND \1
	BEQ .colorOff\@
	LDX #$00
.loop\@
	LDA \2, X
	STA \3, X
	INX
	CPX #$03
	BNE .loop\@
	JMP .skip\@
	
.colorOff\@
	LDA #$0F
	STA \3
	STA \3+1
	STA \3+2

.skip\@	
	.endm