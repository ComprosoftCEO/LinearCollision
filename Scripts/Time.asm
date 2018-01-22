UpdateTime:
	;Make sure the player isn't in the exit
	LDX ExitAnimTimer
	CPX #$FF
	BEQ .run
	RTS
	
.run
	DEC TimeCounter
	BEQ .cont			;Only tick timer every 60 frames
	RTS
	
.cont
	LDA #60
	STA TimeCounter		;Reset this counter

	

	;Test seconds
	LDX TimeOSec
	DEX
	CPX #$3A
	BEQ .tens
	STX TimeOSec
	JMP .sound
	
.tens
	LDX #$44		;Reset the ones seconds
	STX TimeOSec
	
	LDX TimeTSec
	DEX
	CPX #$3A
	BEQ .min
	STX TimeTSec
	JMP .sound
	
.min
	LDX #$40
	STX TimeTSec
	
	LDX TimeMin
	DEX
	CPX #$3A
	BEQ GameOver
	STX TimeMin
	
.sound
	;Play a tick if the minutes = 0 and T sec = 0
	LDA TimeMin
	CMP #$3B
	BNE .nosound
	LDA TimeTSec
	CMP #$3B
	BNE .nosound
	
	;Play a tick sound
	LDA #$05
	JSR sound_load
	
.nosound	
	RTS
	
GameOver:
	;Make sure all timers read 00
	LDA #$3B
	STA TimeTSec
	STA TimeOSec
	
	;Reset player color
	LDA #$30
	STA ERed+12
	STA EYellow+12
	STA EGreen+12
	STA EBlue+12
	
	;Turn player into hurt player
	LDA #13
	STA $0201
	STA $0205

;Load explosion and game over sound
	LDA #$01
	JSR sound_load
	LDA #$06
	JSR sound_load

	LDX #240
.loop
	JSR WaitNMI
	DEX
	CPX #$00
	BNE .loop
	
	;If autoplay is enabled, return to title
	LDA AutoPlayEnabled
	BEQ .timecont
	JMP Title
	
.timecont
	JMP Reset