LoadPlayField:

	
	;Playfield starts at row 3
	LDA $2002
	LDA #$20
	STA $2006
	LDA #$20
	STA $2006
	
;Set up the address access for the playfield data
	LDA #LOW(PlayField)
	STA Temp1
	LDA #HIGH(PlayField)
	STA Temp2
	
;Use Temp3 as a counter for the number of scan lines
	LDA #$1F			;Add 2 scan lines for the palette
	STA Temp3

;Temp 4 is the shift counter
;Temp 5 is the counter for the byte
	LDA #$08
	STA Temp4
	LDA #$04
	STA Temp5

	
	
.loop1
	LDX #$20
.loop2
	LDY #$00
	LDA [Temp1],Y		;Store the value from memory
	STA $2007
	
	;Now, do the collision data:
	;$70, $03, $04, $0E, and $0F are to be skipped
	CMP #$70
	BEQ .noWall
	CMP #$03
	BEQ .noWall
	CMP #$04
	BEQ .noWall
	CMP #$0E
	BEQ .noWall
	CMP #$0F
	BEQ .noWall
	
	;So there is a wall
	SEC
	JMP .updateCollision
.noWall
	CLC
	
.updateCollision	
	TXA				;Save X
	PHA
	LDX Temp5
	ROL CollisionData, X
	PLA
	TAX				;Restore X
	
	DEC Temp4
	BNE .updateP		;Test when to move to the next byte
	LDA #$08
	STA Temp4
	INC Temp5
	
.updateP	
	LDY Temp1		;Update the pointer
	INY
	BNE .skip	
	INC Temp2
.skip
	STY Temp1
	
	DEX
	BNE .loop2
	
	DEC Temp3		;Loop through the lines
	BNE .loop1

	RTS
	
	
	
	
	
LoadSprites:
;Now, load in the default location of sprites:

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
	CPY #36
	BNE .defloop
	
;Now, do the top and bottom enemies
	LDX #00
	LDY #00
.toploop
	LDA #15
	STA EnemySprites, X
	LDA #239
	STA EnemySprites+40, X
	
	LDA HorPos, Y
	STA EnemySprites+3, X
	STA EnemySprites+43, X
	
	INX
	INX
	INX
	INX
	INY
	CPY #10
	BNE .toploop
	

;And the left and right enemies
	LDX #00
	LDY #00
.sideloop
	LDA #$FF
	STA EnemySprites+83, X
	STA EnemySprites+115, X
	
	LDA VertPos, Y
	STA EnemySprites+80, X
	STA EnemySprites+112, X
	
	INX
	INX
	INX
	INX
	INY
	CPY #$08
	BNE .sideloop
	
	
	
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
	CPX #$10				;Level 16 is the same as level 15
	BCC .skip
	LDX #$0F			;If greater than 15, set equal to 15
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
	
	RTS 