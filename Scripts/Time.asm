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
	RTS 
	
.tens
	LDX #$44		;Reset the ones seconds
	STX TimeOSec
	
	LDX TimeTSec
	DEX
	CPX #$3A
	BEQ .min
	STX TimeTSec
	RTS
	
.min
	LDX #$40
	STX TimeTSec
	
	LDX TimeMin
	DEX
	CPX #$3A
	BEQ GameOver
	STX TimeMin
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
	
	LDX #240
.loop
	JSR WaitNMI
	DEX
	CPX #$00
	BNE .loop
	
	JMP Reset