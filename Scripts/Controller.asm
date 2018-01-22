;Stores the controls into variable Control Data
GetControls:
	PHA
	TXA			;Backup registers onto stack
	PHA				
	
	LDA #$01
	STA $4016
	LDA #$00		;Latch the controller to begin
	STA $4016
	
	LDX #$08
.loop				;Control data will read (A,B,Sel,Start,U,D,L,R)
	LDA $4016		;Player 1 Data
	LSR A
	ROL C1Data
	
	LDA $4017		;Player 2 Data
	LSR A
	ROL C2Data
	
	DEX
	BNE .loop
	
	PLA
	TAX
	PLA		;Get back the registers
	RTS