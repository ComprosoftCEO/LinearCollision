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
	;Initiate the sound
	JSR sound_init

	;Clear screen to write new stuff
	JSR DisableScreen
	JSR ResetBackground
	JSR ResetAttrib
	JSR ResetSprites

	JSR LoadPlayField
	JSR LoadGameplayPalette
	JSR LoadEnergy
	JSR LoadExit
	JSR LoadSprites
	JSR LoadLevelData
	JSR FinalData
	
	LDA #$00				;Disable Autoplay
	STA AutoPlayEnabled	
	
	JSR SetUpKeyLogger
	
	JSR StartLevel

	RTS
	
	
LoadAutoPlay:
	;Clear screen to write new stuff
	JSR DisableScreen
	JSR ResetBackground
	JSR ResetAttrib
	JSR ResetSprites

	;Pick a random layout
	JSR GetRandom1
	AND #$03
	STA AutoPlayLayout
	TAX
	LDA AutoPlayLayouts, X
	STA LayoutNumber
	
	JSR LoadPlayField
	JSR LoadGameplayPalette
	JSR LoadEnergy
	JSR LoadExit
	JSR LoadSprites
	JSR LoadLevelData
	JSR FinalData
	
	;Set up custom timer data
	LDA #$3C
	STA TimeMin
	
	;Set up the default pointer for the auto data
	JSR ResetAutoPointer
	
	LDA #$01				;Enable Autoplay
	STA AutoPlayEnabled	
	
	;Disable the audio
	JSR sound_disable
	
	JSR CheatCounter		;Draw infinity symbols if cheats are enabled
	JSR CheatTimer
	
	
	JSR StartLevel

	JMP Gameplay
	
	
	
NextLevel:
;Delay for a bit
	LDX #120
.loop
	JSR WaitNMI
	DEX
	CPX #$00
	BNE .loop

	;If autoplay is enabled, return to title
	LDA AutoPlayEnabled
	BEQ .lvlcont
	JMP Title

.lvlcont
	
;Add 1 to the level number
	LDX LevelNumber
	INX
	CPX #100
	BNE .cont
	LDX #99		;Overflows at level 100. You cannot advance past 99.
.cont
	STX LevelNumber
	
	;Pick a new random layout
	JSR NewLayout
	
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
	
	;Play the intro sound
	LDA #$00
	JSR sound_load

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
	
	JSR UpdateReady
	
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
	
	;Reset player XY
	LDA PlayerX
	STA $0203
	STA $0207
	LDA PlayerY
	STA $0200
	STA $0204
	
	RTS
	
UpdateReady:
	TYA
	PHA

	LDA ReadySprites+1
	CMP #$00
	BEQ .turnOn
	
	;Turn off sprites
	LDA #$00
	LDY #$00
.loop2
	STA ReadySprites+1, Y
	INY
	INY
	INY
	INY
	CPY #20
	BNE .loop2
	PLA
	TAY
	RTS

.turnOn
	LDY #$00
.loop
	LDA GetReady, Y
	STA ReadySprites, Y
	INY
	CPY #20
	BNE .loop
	PLA
	TAY
	RTS
	
	
	
NewLayout:
	LDA #$00
	STA RandMin		;Pick layout from 0 to 10
	LDA #LevelCount
	STA RandMax
	JSR RandInt
	LDX #$00
.loop
	CMP PreviousLayouts, X		;Don't allow the same layout for 3 more levels
	BEQ NewLayout
	INX
	CPX #$03
	BNE .loop
	
	STA LayoutNumber	;The layout number
	TAX
	
	;Update the other layouts
	LDA PreviousLayouts+1
	STA PreviousLayouts
	LDA PreviousLayouts+2
	STA PreviousLayouts+1
	STX PreviousLayouts+2
	RTS