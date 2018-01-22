;The code that is run every tick in the game	
Gameplay:
	JSR MoveEnemy
	JSR MovePlayer
	
	JSR TestEnergyCollision
	JSR TestEnemyCollision
	JSR TestExitLocation
	
	JSR ShufflePalette
	JSR UpdatePlayField
	JSR UpdateExitPalette
	JSR InvincibleTimer
	JSR UpdateTime
	
	JSR WaitNMI
	JMP Gameplay
	
	
;Load the game	
LoadGame:

	;Clear screen to write new stuff
	JSR DisableScreen
	JSR ResetBackground
	JSR ResetAttrib
	JSR ResetSprites

	JSR LoadPlayField
	JSR LoadGameplayPalette
	JSR LoadSprites
	JSR LoadLevelData
	JSR FinalData

	JSR StartLevel

	RTS
	
	
	
	
NextLevel:
;Delay for a bit
	LDX #120
.loop
	JSR WaitNMI
	DEX
	CPX #$00
	BNE .loop

;Add 1 to the level number
	LDX LevelNumber
	INX
	CPX #100
	BNE .cont
	LDX #99		;Overflows at level 100. You cannot advance past 99.
.cont
	STX LevelNumber
	
;Incrament the invincibile
	LDX InvincibleLeft
	CPX #$09			;You can only have a max of 9
	BCS .skip
	INC InvincibleLeft
.skip
	JSR LoadGame
	JMP Gameplay
	
	
	
	
;Wait until user presses start	
Pause:
	JSR GetControls
	LDA C1Data
	AND #%00010000
	BNE .exit
	
	LDA #$00
	STA StKeyPress		;If the key is not down, indicate it
	JMP Pause
.exit
	LDA StKeyPress		;Test if the key is currently down
	CMP #$00
	BNE Pause
	LDA #$01
	STA StKeyPress		;If no, then update
	
	LDA #%00011110		;Turn off the color emphasis
	STA PPU_Setting2
	RTS



	
StartLevel:

	LDA #$80			;Enable NMI
	STA $2000
	
	JSR WaitNMI		;Wait for a NMI before turning on the screen
	
	;Turn on the screen
	JSR UpdatePPU
	
	;Load in the "Ready" sprites
	LDX #$00 
.spr	
	LDA GetReady, X
	STA ReadySprites, X
	INX
	CPX #20
	BNE .spr

	;Now, wait for 2 seconds
	LDY #04
	LDX #30
.loop
	JSR WaitNMI
	DEX
	BNE .loop
	LDX #30
	
	;Update the palette data
	LDA PaletteData+26
	CMP #$30
	BEQ .opt2		;If color is not white
	LDA #$30		;Make it white
	STA PaletteData+26
	JMP .next
.opt2
	LDA #$0F		;Else make it black
	STA PaletteData+26
	
.next	
	DEY
	BNE .loop
	
	;Turn off the ready sprites
	LDA #$FE
	LDX #$00
.loop2
	STA ReadySprites, X
	INX
	CPX #20
	BNE .loop2
	
	;Wait for 1/2 more second
	LDX #$30
.loop3
	JSR WaitNMI
	DEX
	BNE .loop3
	
	;Set up the player
	LDX #$00
.loop4
	LDA OtherSprites, X
	STA $0200, X
	INX
	CPX #$08
	BNE .loop4
	
	
	RTS
	
	