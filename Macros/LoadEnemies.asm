;Code to load the enemies into the game
LoadEnemy		.macro
	;1 = Enemy Counter location
	;2 = Default value (Y for top enemies, X for side enemies)
	;3 = Where to store default value 
	;4 = Where to store variable number

	;Get the counter for the number of enemies to load
	;Store in temp3
	LDA [Temp1], Y
	STA Temp3
	STA \1
	INY
	
	CMP #$00
	BEQ .skip\@		;Skip if there are no enemies to store

.loadLoop\@
	
	LDA \2		;Load default value
	STA \3, X
	LDA [Temp1], Y
	STA \4, X
	INY
	
	INX
	INX		;Add 4 to X
	INX
	INX
	
	DEC Temp3
	BNE .loadLoop\@
	
.skip\@

	.endm