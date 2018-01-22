TestEnemyX	.macro

	LDA $0203		;Player X
	STA Temp1
	LDA \1,Y		;Enemy X
	STA Temp2
	
	JSR GetDifference		
	CMP #$05		;Should be within a range of 4
	BCS .exit1\@
	JMP EnemyHit
	
.exit1\@

	.endm
	
	
TestEnemyY	.macro

	LDA $0200		;Player Y
	STA Temp1
	LDA \1,Y		;Enemy Y
	STA Temp2
	
	JSR GetDifference		
	CMP #$05		;Should be within a range of 4
	BCS .exit2\@
	JMP EnemyHit
	
.exit2\@

	.endm