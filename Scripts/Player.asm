MovePlayer:
	
	;Test the hit timer
	LDA HitTimer
	BEQ .allowMovement
	DEC HitTimer
	BNE .Return
	JMP ResetPlayer
.Return	
	RTS

.allowMovement
	;Also test the exit animation
	LDA ExitAnimTimer
	CMP #$FF
	BEQ .cont
	RTS
	
.cont
	;Get the controls
	JSR GetControls
	JSR KeyLogger

	;Create a pause menu
	LDA C1Data
	AND #%00010000
	BEQ .resetKey		;If button is not pressed, reset key press
	
	;If autoplay is enabled, then return to title
	LDA AutoPlayEnabled
	BEQ .pausecont
	JMP Title

.pausecont	
	LDA StKeyPress		;Make sure the key isn't currently down
	CMP #$00
	BNE .a				;If yes, then skip
	LDA #$01			;If no, then tell that it is down
	STA StKeyPress
	
	LDA #%11111110		;Make the nes slightly darker with color emphasis
	STA PPU_Setting2
	
	JSR Pause
	JMP .a
	
	
.resetKey
	LDA #$00
	STA StKeyPress
	
	;The controller hiearchy is Up,Down,Left,Right
	;Update the player position in this order
	
.a	

	;If autokey is enabled, get the data
	LDA AutoPlayEnabled
	BEQ .noKey
	JSR GetAutoKey
	
.noKey
	LDA C1Data
	AND #%10000000
	BEQ .resetA
	
	;Make sure the A key isn't pressed
	LDA AKeyPress
	CMP #$00
	BNE .b
	
	LDA #$01			;Do turn on the A key press
	STA AKeyPress
	
	;Make sure the timer isn't on
	LDA InvensibleMS
	CMP #$FF
	BNE .b
	
	JSR SetUpInvincible
	JMP .b
	
.resetA
	LDA #$00
	STA AKeyPress
	
	
.b
	;Test for cheat mode enabled
	LDA CheatMode
	AND #CheatBit
	BEQ .up
	
	LDA CheatMode	;See if this cheat is enabled
	AND #$08
	BEQ .up
	
	LDA C1Data
	AND #%01000000
	BEQ .up
	
	JSR CheatEnergy
	
.up
	LDA C1Data
	AND #%00001000
	BEQ .down
	
	JSR GetRandom1			;Mess with random numbers
	
	JSR ResetCollision
	LDA #$01
	STA Check
	STA Check+1
	DEC NewY
	JSR TestWallCollision
	
.down
	LDA C1Data
	AND #%00000100
	BEQ .left
	
	JSR GetRandom2			;Mess with random numbers
	
	JSR ResetCollision
	LDA #$01
	STA Check+2
	STA Check+3
	INC NewY
	JSR TestWallCollision

.left	
	LDA C1Data
	AND #%00000010
	BEQ .right
	
	JSR GetRandom3			;Mess with random numbers
	
	JSR ResetCollision
	LDA #$01
	STA Check
	STA Check+2
	DEC NewX
	JSR TestWallCollision
	
.right
	LDA C1Data
	AND #%00000001
	BNE .rightC
	RTS
	
.rightC
	JSR MixNumbers			;Mess with random numbers

	JSR ResetCollision
	LDA #$01
	STA Check+1
	STA Check+3
	INC NewX
	JSR TestWallCollision
	
	RTS
	
	
	
	
	
	
	
ResetPlayer:
	;Reset player sprite
	LDX #$00
.loop
	LDA OtherSprites, X
	STA $0200, X
	INX
	CPX #$08
	BNE .loop
	
	;Reset player XY
	LDA PlayerX
	STA $0203
	STA $0207
	LDA PlayerY
	STA $0200
	STA $0204
	
	;Reset item colors
	LDA #ColRed
	STA ERed
	LDA #ColYellow
	STA EYellow
	LDA #ColGreen
	STA EGreen
	LDA #ColBlue
	STA EBlue
	
	;Reset the exit animation
	LDA #$FF
	STA ExitTimer
	STA ExitAnimTimer
	
	;And reset the colors of the exit
	LDA #$0F
	STA PaletteData+13
	STA PaletteData+14
	
	;If autoplay is enabled, reset the pointer
	LDA AutoPlayEnabled
	BEQ .diecont
	JSR ResetAutoPointer
	
.diecont	
	RTS
	
	
	
	
	
	
	
	
;Test if the player is on the exit and it is active
TestExitLocation:
	;Test if exit is active
	LDA ExitTimer
	CMP #$FF
	BEQ .exit

	;Make sure exit isn't currently active
	LDA ExitAnimTimer
	CMP #$FF
	BEQ .cont
	JMP EndLoop
	
.cont
	LDA $0203
	STA Temp1
	LDA ExitX			;X Middle
	STA Temp2
	JSR GetDifference
	
	CMP #$06			;If X is less than 6, go on
	BCS .exit
	
	LDA $0200
	STA Temp1
	LDA ExitY			;Y Middle = 127
	STA Temp2
	JSR GetDifference
	
	CMP #10			;If Y is less than 10, go on
	BCS .exit
	
	;Player is indeed on exit
	JMP SetUpExitAnim
	
.exit
	RTS 
	
	
	
	
;The set up code for an invincible player	
SetUpInvincible:
	;Test that you have some invincible left
	LDA InvincibleLeft
	CMP #$00
	BNE .allowed
	RTS
	
.allowed
;Play the sound effect
	LDA #$04
	JSR sound_load

;If the cheat is enabled, skip this step
	LDA CheatMode
	AND #CheatBit
	BEQ .noCheat
	
	LDA CheatMode
	AND #$01
	BEQ .noCheat
	JMP .yesCheat
	
.noCheat
;Update the sprite counter
	DEC InvincibleLeft
	LDA InvincibleLeft
	CLC
	ADC #$3B
	STA InvincibleSpr
	
.yesCheat
;Set up the invincible timer
	LDA DefaultInvensible
	CMP #$00			;00 = no timer
	BNE .cont
	RTS
.cont	
	STA InvensibleS		;Store into sec
	LDA #60
	STA InvensibleMS	;Set up Milliseconds
	
	LDA #$18
	STA $0201		;Invincible sprite
	LDA #$19
	STA $0205
	
	RTS
	
	
	
SetUpExitAnim:
	;Move player into center
	LDA ExitX
	STA $0203
	STA $0207
	
	LDA ExitY
	STA $0200
	STA $0204
	
	;Turn off invincibility
	LDA #$FF
	STA InvensibleMS
	
	;Reset the player sprite, in case they are in invincible mode
	LDA #1
	STA $0201
	LDA #2
	STA $0205
	
	;Configure the timer and sprite
	LDA #$08
	STA ExitAnimTimer
	LDA #$10
	STA ExitAnimSprite
	
	;Play the sound
	LDA #$03
	JSR sound_load
	
	RTS

;Run the exit color animation
EndLoop:
	DEC ExitAnimTimer
	BNE .exit
	
	LDX ExitAnimSprite
	CPX #$16
	BNE .cont			;Test if the exit animation is finished
	
	JMP NextLevel
	
.cont	
	;Update the animation by one frame
	INX
	INX
	STX ExitAnimSprite
	STX $0201
	INX
	STX $0205
	
	LDA #$03
	STA ExitAnimTimer
	
.exit	
	RTS
	
	
	
	
	
	
InvincibleTimer:
	;Test if the timer is on
	LDA InvensibleMS
	CMP #$FF
	BEQ .exit
	
	DEC InvensibleMS	;Subtract 1 from MS
	BNE .sprite
	
	LDA #60
	STA InvensibleMS
	DEC InvensibleS
	LDA InvensibleS
	CMP #$FF
	BNE .exit
	
	;Turn off the timer
	STA InvensibleMS
	LDA #1
	STA $0201			;Reset player sprites
	LDA #2
	STA $0205
	JMP .exit
	
.sprite		;Do custom sprites when there is only 1 second left	
	
	;Only do this if there are 0 seconds left
	LDA InvensibleS
	BNE .exit
	
	LDA InvensibleMS
	CMP #40
	BNE .next		;First shift is at 40 MS
	
	LDA #$1A
	STA $0201
	LDA #$1B
	STA $0205
	RTS
	
.next
	LDA InvensibleMS
	CMP #20			;Second shift is at 20 MS
	BNE .exit
	
	LDA #$1C
	STA $0201
	LDA #$1D
	STA $0205
	RTS
	
.exit	
	RTS 