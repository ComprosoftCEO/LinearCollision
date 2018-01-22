MoveEnemy:

	;A macro to make this code easier
	.include "Macros/MoveEnemy.asm"
		
	LDX #$00		;X = Counter
	LDY #00			;Y = Sprite location
	
	MoveEnemySegInc TopEnemyCount, EnemySprites,   #239, #15, #7, #$0F	 		;Up
	MoveEnemySegDec BottomEnemyCount, EnemySprites,   #$15, #239, #5, #$03	 	;Down
	MoveEnemySegInc LeftEnemyCount, EnemySprites+3, #$FF, #$FF, #9, #03 		;Left
	MoveEnemySegDec RightEnemyCount, EnemySprites+3, #$FF, #$FF, #12, #07 		;Right
	
	RTS 