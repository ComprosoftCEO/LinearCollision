MoveEnemySegInc:	.macro 		;Macro to move the enemies

	;Arguments:
	;1 = Counter Stop
	;2 = Memory addreess to Move
	;3 = Value to Stop at
	;4 = Reset value
	;5 = Default tile value
	;6 = Xor Value
	
	CPX \1
	BEQ .exit\@		;Skip if the counter is equal to 0
	
.loopT\@
	LDA EnemySprites+1, Y			;Is enemy enabled?
	BNE .moveT\@			;Yes = Move Enemy
	
	DEC EnemyReleaseTimer, X		;No = Counter
	BNE .nextT\@
	
	JSR GetRandom1
	AND DigitsAllowed
	STA EnemyReleaseTimer, X	;Set up the next timer
	
	JSR GetRandom2		;Randomly release the enemy when the counter reaches 0
	AND Probability
	BNE .nextT\@
	
	LDA \5		;Set up the enemy
	STA EnemySprites+1, Y
	JMP .nextT\@

.moveT\@		;Move the enemy
	TXA
	PHA
	TYA		;Temporarily store the X value on the stack
	TAX
	INC \2, X		;Incrament the sprite position
	LDA EnemySprites+1, X
	EOR \6		;Change the sprite
	STA EnemySprites+1, X
	PLA
	TAX			;And get X back
	
	LDA \2, Y	;Get the position of the sprite
	CMP \3
	BNE .nextT\@ ;Keep moving the sprite until it is outside the region
	
	LDA \4
	STA \2, Y	;Restore dormant settings
	LDA #$00
	STA EnemySprites+1, Y
	
.nextT\@
	INY
	INY
	INY
	INY
	
	INX
	CPX \1
	BNE .loopT\@

.exit\@
	.endm
	
	
	
MoveEnemySegDec:	.macro 		;Macro to move the enemies

	;Arguments:
	;1 = Counter Stop
	;2 = Memory addreess to Move
	;3 = Value to Stop at
	;4 = Reset value
	;5 = Default tile value
	;6 = Xor Value
	
	CPX \1
	BEQ .exit\@		;Skip if the counter is equal to 0
	
.loopT\@
	LDA EnemySprites+1, Y			;Is enemy enabled?
	BNE .moveT\@			;Yes = Move Enemy
	
	DEC EnemyReleaseTimer, X		;No = Counter
	BNE .nextT\@
	
	JSR GetRandom2
	AND DigitsAllowed
	STA EnemyReleaseTimer, X	;Set up the next timer
	
	JSR GetRandom3		;Randomly release the enemy when the counter reaches 0
	AND Probability
	BNE .nextT\@
	
	LDA \5		;Set up the enemy
	STA EnemySprites+1, Y
	JMP .nextT\@

.moveT\@		;Move the enemy
	TXA
	PHA
	TYA		;Temporarily store the X value on the stack
	TAX
	DEC \2, X		;Decrament the sprite position
	LDA EnemySprites+1, X
	EOR \6		;Change the sprite
	STA EnemySprites+1, X
	PLA
	TAX			;And get X back
	
	LDA \2, Y	;Get the position of the sprite
	CMP \3
	BNE .nextT\@ ;Keep moving the sprite until it is outside the region
	
	LDA \4
	STA \2, Y	;Restore dormant settings
	LDA #$00
	STA EnemySprites+1, Y
	
.nextT\@
	INY
	INY
	INY
	INY
	
	INX
	CPX \1
	BNE .loopT\@
	
.exit\@
	
	.endm