LoadPlayField:

	.include "Macros/SurroundingWalls.asm"
	
	;Playfield starts at row 2
	LDA $2002
	LDA #$20
	STA $2006
	LDA #$20
	STA $2006
	
	;Load the status screen:
	LDX #$00
.loop1
	LDA StatusScreen, X
	STA $2007
	INX
	CPX #32
	BNE .loop1
	
	;Also, load in a row entirely of $FD's
	LDA #$FD
	LDX #00
.loop2
	STA $2007
	INX
	CPX #32
	BNE .loop2
	
	;Now, copy the collision data
	;First, do 3 lines of FF on top and bottom (12 Bytes total)
	LDA #$FF
	LDX #00
.loop3
	STA $0404, X
	STA $0474, X
	INX
	CPX #12
	BNE .loop3
	
	LDA LayoutNumber
	ASL A	;Shift to multiply by 2
	TAX
	LDA LVLLayout, X
	STA Temp1
	LDA LVLLayout+1, X		;[Temp1,Temp2] is used for indirect indexing
	STA Temp2
	
	;There are exactly 100 bytes to copy
	LDY #$00
.loop4
	LDA [Temp1], Y
	STA $0410, Y
	INY
	CPY #100
	BNE .loop4
	
	
	;Convert this collision data into tiles
	;Loop through every tile in the game
	
	;Temp1 represents the bit
	LDA #$80
	STA Temp1
	
	;This should take 108 bytes, so use Y as a counter
	LDY #$00
.loop5
	LDA $040C, Y
	AND Temp1
	BNE .wall
	LDA #$70
	STA $2007	;No wall, by default, = $70
	JMP .next
	
.wall
	;Figure out the surrounding walls
	PreviousWalls
	NextWalls
	CurrentWalls

	;Now, or all of these together
	LDX #$00
	LDA #$00
.orLoop	
	ORA Tiles, X
	INX
	CPX #$08
	BNE .orLoop
	
	;And find the value in the lookup table
	TAX
	LDA LookupTable, X
	STA $2007
	
.next
	LSR Temp1
	BCS .nextByte
	JMP .loop5
.nextByte
	LDA #$80		;Shift through 8 bits before moving to next byte
	STA Temp1
	INY
	CPY #108		;Copy exactly 108 bits
	BEQ .exit
	JMP .loop5
	
.exit	
	RTS
		
	
	
	
	
	
LoadEnergy:
	;Load the energy balls into the PPU
	
	LDA LayoutNumber
	ASL A	;Shift to multiply by 2
	TAX
	LDA LVLLayout, X
	STA Temp1
	LDA LVLLayout+1, X		;[Temp1,Temp2] is used for indirect indexing
	STA Temp2
	
	;Temp3/Temp4 used to calculate XY location of energies
	
	LDY #100	;Jump ahead bytes tiles
	LDX #$00
	LDA $2002		;Reset the latch
.loop
	LDA [Temp1], Y
	STA PPU_Low
	INY				;DW are backwards, so store them backwards
	LDA [Temp1], Y
	STA PPU_High
	
	;Mark the location in the PPU memory
	LDA $2002
	LDA PPU_High
	STA $2006
	LDA PPU_Low
	STA $2006
	
	LDA EnergyTiles, X
	STA $2007
	
	;Calculate the XY position in reguards to the screen
	JSR CalculatePPUXY
	
	;Store these values into the appropirate Slots
	LDA TempX
	STA RedX, X
	LDA TempY
	STA RedY, X
	
	;Figure out which attribute to modify
	;Store in PPU_Low and PPU_High
	
	JSR GetAttributeXY
	
	LDA AttribData, X		;Tell which attribute to poke into this value
	STA Temp3
	
	JSR PutAttribute
	
	INX
	INY
	CPX #$04
	BNE .loop
	RTS
	
	
	
	
	
	
	;Load the energy into the PPU
LoadExit:
	
	;Lookup table should already be in memory under [Temp1,Temp2]
	LDY #108		;This data starts at 108 bytes
	LDA [Temp1], Y
	STA PPU_Low
	STA Temp6		;Also store in Temp6 Low for backup
	INY
	LDA [Temp1], Y
	STA PPU_High
	STA Temp5		;Also store in Temp5 High for backup
	
	;Figure out the exit XY locations
	JSR CalculatePPUXY		;Convert PPU to XY
	LDA TempX
	CLC
	ADC #$04		;X 4 to X to find center
	STA ExitX
	LDA TempY
	CLC				;Add 8 to Y to find center
	ADC #$08
	STA ExitY
	
	;Copy back into values
	LDA Temp5
	STA PPU_High
	LDA Temp6
	STA PPU_Low
	
	LDA $2002		;Reset high/low latch
	LDA PPU_High
	STA $2006
	LDA PPU_Low
	STA $2006
	
	LDX #$00
.loop	
	JSR WriteExitData

	;Add 31 to PPU HighLow
	LDA Temp6
	CLC
	ADC #31
	STA Temp6
	BCC .skip
	INC Temp5		;Incrament on overflow
.skip

	;Copy back into values
	LDA Temp5
	STA PPU_High
	LDA Temp6
	STA PPU_Low

	;Reset the PPU data location
	LDA $2002		;Reset high/low latch
	LDA PPU_High
	STA $2006
	LDA PPU_Low
	STA $2006
	
	INX
	CPX #$03
	BNE .loop
	
	RTS
	
	
	
WriteExitData:
	;Write the data for the exit
	LDA #$0E
	STA $2007
	LDA #$0F
	STA $2007
	
	;Figure out the XY coordinates of this attribute
	JSR CalculatePPUXY		;Convert PPU to XY
	JSR GetAttributeXY		;Convert XY to attribute
	
	LDA #$03		;Tell which attribute to poke into this value
	STA Temp3
	JSR PutAttribute		;Poke in the new value
	
	INC Temp6			;Incrament low
	BNE .skip			;If not equal to 0 (no overflow), then don't update next address
	INC Temp5
.skip
	;Copy back to PPU HighLow
	LDA Temp5
	STA PPU_High
	LDA Temp6
	STA PPU_Low

	;Figure out the XY coordinates of this attribute
	JSR CalculatePPUXY		;Convert PPU to XY
	JSR GetAttributeXY		;Convert XY to attribute
	
	LDA #$03		;Tell which attribute to poke into this value
	STA Temp3
	JSR PutAttribute		;Poke in the new value
	
	RTS
	
	
	
	
	
	
LoadSprites:

	.include "Macros/LoadEnemies.asm"

;Now, load in the default location of sprites:

;First, define the player XY location
	LDY #110		;Data starts at 110 bytes
	LDA [Temp1], Y
	STA PlayerX
	INY
	LDA [Temp1], Y
	STA PlayerY

;Enemy Sprite Defaults:
	LDX #00
	LDY #$00
.defloop
	LDA #$00		;Sprite Image (Default = 0)
	STA EnemySprites+1, X
	
	JSR GetRandom2	
	AND #%00000011	;Random sprite palette to use
	ORA #%00000000	;Enemies are in front of background
	STA EnemySprites+2, X
	
	JSR GetRandom3				;Set up random timers
	STA EnemyReleaseTimer, Y
	
	INY
	
	INX
	INX
	INX
	INX
	CPY #48
	BNE .defloop
	
;Now, load the enemies from the level data
	LDX #00		;Enemy counter starts at Byte 112
	LDY #112

	LoadEnemy TopEnemyCount, #15, EnemySprites, EnemySprites+3 			;Top Enemies
	LoadEnemy BottomEnemyCount, #239, EnemySprites, EnemySprites+3 		;Bottom Enemies
	LoadEnemy LeftEnemyCount, #$FF, EnemySprites+3, EnemySprites 		;Left Enemies
	LoadEnemy RightEnemyCount, #$FF, EnemySprites+3, EnemySprites 		;Right Enemies
	
	;Configure the counters
	LDA BottomEnemyCount
	CLC
	ADC TopEnemyCount		;Bottom = Top + Bottom
	STA BottomEnemyCount
	
	LDA LeftEnemyCount
	CLC
	ADC BottomEnemyCount	;Left = Top + Bottom + Left
	STA LeftEnemyCount
	
	LDA RightEnemyCount
	CLC						;Right = Top + Bottom + Left + Right
	ADC LeftEnemyCount
	STA RightEnemyCount
	
;Set up the other sprites:
	LDX #$08
.otherloop
	LDA OtherSprites, X
	STA $0200, X
	INX
	CPX #32
	BNE .otherloop
	
	
;Set up the playfield color
	JSR GetRandom1
	AND #$0F
	STA PlayFieldColor
	LDA #$01
	STA PlayFieldTimer
	JSR UpdatePlayField
	JSR UpdatePalette

	RTS
	
	
	
	
	
;Get the data for the current level
LoadLevelData:
	LDX LevelNumber
	DEX						;Level number is 1 greater than level
	CPX #24				;Level 25 is the same as level 24
	BCC .skip
	LDX #23			;If greater than 24, set equal to 24
.skip

	;Information for enemy release probability
	LDA LVLPrb, X
	STA Probability
	LDA LVLDig
	STA DigitsAllowed
	
	;Set up the level counter
	LDA LevelNumber
	
	;Divide by 10 for first number
	LDY #$00
.loop1
	INY
	SEC
	SBC #10
	BCS .loop1
	DEY				;Since the above loop always return the roof, floor it
	STY LVLTens		;Store in sprite position

	CLC
	ADC #10+$3B
	STA LVLOnes		;Store in ones place
	
	;And fix the tens
	LDA #$3B
	CLC
	ADC LVLTens
	STA LVLTens
	
	
	;Set up the timer data
	LDA LVLTM, X		;Minutes
	CLC
	ADC #$3B
	STA TimeMin
	
	LDA LVLTS, X		;Seconds
	LDY #$00
.loop2
	INY
	SEC
	SBC #10
	BCS .loop2
	DEY				;Since the above loop always return the roof, floor it
	STY TimeTSec	;Store in tens of seconds
	
	CLC
	ADC #10+$3B
	STA TimeOSec		;Store in ones place
	
	;And fix the tens
	LDA #$3B
	CLC
	ADC TimeTSec
	STA TimeTSec

	;Reset the timer counter
	LDA #60
	STA TimeCounter
	
	
;Load the invincible data
	LDA LVLInv, X
	STA DefaultInvensible
	
	RTS
	
	
	
	
	
	
	
FinalData:
	
;Set up some final things
	LDA #$00
	STA HitTimer
	LDA #$01
	STA StKeyPress
	STA AKeyPress
	
	LDA RightEnemyCount
	STA EnemyCount
	
;Set up data for the exit animation
	LDA #$00
	STA ExitColor
	LDA #$FF
	STA ExitTimer
	STA ExitAnimTimer
	
;Set up the invincible timer
	STA InvensibleMS
	LDA InvincibleLeft
	CLC
	ADC #$3B
	STA InvincibleSpr
	
;Reset item colors
	LDA #ColRed
	STA ERed
	LDA #ColYellow
	STA EYellow
	LDA #ColGreen
	STA EGreen
	LDA #ColBlue
	STA EBlue
	
	JSR CheatCounter		;Draw infinity symbols if cheats are enabled
	JSR CheatTimer
	RTS 