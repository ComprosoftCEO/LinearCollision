TestWallCollision:	

	;Use a macro to make this job easier
	.include "Macros/CollisionCode.asm"

	;Reset the various counters
	LDA #$00
	STA TileX		;Reset tile positions
	STA TileY

	;Figure out the XY location in regards to 8 tiles
	LDA NewX
.loop1
	INC TileX
	SEC
	SBC #$08
	BCS .loop1
	
	DEC TileX		;Always floor the number
	CLC
	ADC #$08
	STA TileXRem	;Store the X remainder
	
	
	LDA NewY
	CLC
	ADC #$01		;Y is off by 1 scaleline, so add 1 extra
.loop2
	INC TileY
	SEC
	SBC #$08
	BCS .loop2

	DEC TileY	;Since the loop returns the roof, always decrament
	CLC
	ADC #$08
	STA TileYRem			;Store the Y remainder
	
	
	
	LDA TileX
	STA Temp1
	LDA TileY		;All Floor
	STA Temp2
	
	TestCode TileTL
	
	LDA TileXRem
	CMP #$00			;Roof X, Floor Y
	BEQ .skip1
	INC Temp1
.skip1
	
	TestCode TileTR
	
	LDA TileYRem
	CMP #$00			;Roof X and Roof Y
	BEQ .skip2
	INC Temp2
.skip2

	TestCode TileBR
	
	LDA TileX
	STA Temp1		;Floor X, Roof Y
	
	TestCode TileBL
	
	
;Once all of the quadrants have been tested, move the player if it checks out
	LDX #$00
.loop3
	LDA Check, X		;Test if you need to test
	BEQ .next	
	LDA TileTL, X		;Test if it is indeed 0
	BEQ .next
	JMP .exit		;Don't move
.next	
	INX
	CPX #$04
	BNE .loop3
	
	;With teh loop done, move the player
	LDA NewX
	STA $0203
	STA $0207
	LDA NewY
	STA $0200
	STA $0204
	
.exit	
	RTS
	
ResetCollision:
	LDA #00
	STA Check
	STA Check+1
	STA Check+2		;Reset check numbers
	STA Check+3
	LDA $0203		;Reset default XY coordinates
	STA NewX
	LDA $0200
	STA NewY
	RTS
	
	
	
	
	
	
TestEnergyCollision:
	;Include macro to make some of the code easier
	.include "Macros/TestEnergyX.asm"

	;Make sure the hit timer is 0
	LDA HitTimer
	CMP #$00
	BEQ .red
	RTS
.red
	
	;Get energy values from memory
	LDA $0200
	STA Temp1		;Test Y row 1
	LDA RedY
	STA Temp2
	
	JSR GetDifference		
	CMP #$06		;Should be within a range of 5
	BCS .yellow
	
	;Now compare X values
	TestEnergyX RedX,ERed,#ColRed
	
	
.yellow

	;Get energy values from memory
	LDA $0200
	STA Temp1		;Test Y row 1
	LDA YellowY
	STA Temp2
	
	JSR GetDifference		
	CMP #$06		;Should be within a range of 5
	BCS .green
	
	;Now compare X values
	TestEnergyX YellowX,EYellow,#ColYellow
	
.green	
	LDA $0200
	STA Temp1
	LDA GreenY
	STA Temp2
	
	JSR GetDifference		
	CMP #$06		;Should be within a range of 5
	BCS .blue

	;Now compare X values
	TestEnergyX GreenX,EGreen,#ColGreen
	
.blue
	LDA $0200
	STA Temp1
	LDA BlueY
	STA Temp2
	
	JSR GetDifference		
	CMP #$06		;Should be within a range of 5
	BCS .exit

	;Now compare X values
	TestEnergyX BlueX,EBlue,#ColBlue


.exit
	JSR AllEnergyCollected
	RTS
	
	
	
;Sets ACC to difference between Temp1 and Temp2
GetDifference:
	LDA Temp1
	CMP Temp2
	BCC .smallerA
	
	SEC
	SBC Temp2		;Accumulator is bigger
	RTS

.smallerA			;Accumulator is smaller
	LDA Temp2
	SEC
	SBC Temp1
	RTS 
	

	
	
	
TestEnemyCollision:

	;Don't test if player is invincible
	LDA InvensibleMS
	CMP #$FF
	BEQ .cont
	RTS
	
.cont
	LDX #$00
	LDY #$00
.loop
	;First, test if the enemy is enabled
	LDA EnemySprites+1, X
	CMP #$00
	BEQ .skip

	LDA $0203		;Test X difference value
	STA Temp1
	LDA EnemySprites+3, X
	STA Temp2
	JSR GetDifference		
	CMP #$08		;Should be within a range of 7
	BCS .skip
	
	LDA $0200		;Test Y difference
	STA Temp1
	LDA EnemySprites, X
	STA Temp2
	JSR GetDifference
	CMP #$08		;Should be within a range of 7
	BCS .skip

	JMP EnemyHit
.skip
	INX
	INX
	INX
	INX
	INY
	
	CPY EnemyCount
	BNE .loop
	
	RTS
	
	
	
	
	
	
	
	
;What to execute when the player hits an enemy
EnemyHit:
	
	;Reset player colors
	LDA #$30
	STA ERed+12
	STA EYellow+12
	STA EGreen+12
	STA EBlue+12
	
	LDA #$0D
	STA $0201		;Set enemy sprite to hurt
	STA $0205
	
	LDA #$FF			;Reset invincible timer
	STA InvensibleMS
	
	LDA #$30			;Hit timer = 48 ticks
	STA HitTimer
	
	RTS 
	
	
	
	
	
	
;Test if all energy has been collected
AllEnergyCollected:
	LDA ERed
	CMP #$0F
	BNE .exit
	
	LDA EYellow		;All energies should be null
	CMP #$0F
	BNE .exit
	
	LDA EGreen
	CMP #$0F
	BNE .exit
	
	LDA EBlue
	CMP #$0F
	BNE .exit
	
	;Set up the timer for the colorful exit tiles
	LDA ExitTimer		;Only enable the exit if it is in the off state
	CMP #$FF
	BNE .exit
	LDA #$01
	STA ExitTimer
	
.exit
	RTS 