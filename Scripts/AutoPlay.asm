KeyLogger:
	LDA LoggerCurKey
	CMP C1Data
	BNE .store
	INC LoggerCounter
	RTS
	
.store
	LDA LoggerCounter
	LDY #$00
	STY LoggerCounter
	STA [LoggerLow], Y
	INC LoggerLow
	
	LDA LoggerCurKey
	STA [LoggerLow], Y
	INC LoggerLow
	
	LDA C1Data
	STA LoggerCurKey
	
	RTS

GetAutoKey:
	DEC AutoPlayCounter
	BEQ .skip
	LDA AutoPlayCurrentKey
	STA C1Data
	RTS
.skip
	
	;Set up the new data
	LDY #$00
	LDA [AutoPlayLow], Y
	STA AutoPlayCounter
	INC AutoPlayCounter		;Add 1 to offset data
	JSR NextAutoPointer
	
	LDA [AutoPlayLow], Y
	STA AutoPlayCurrentKey
	STA C1Data
	JSR NextAutoPointer
	
	RTS


ResetAutoPointer:
	LDA AutoPlayLayout
	ASL A
	ASL A			;Figure out which data to get pointer for (4 possible)
	STA Temp1
	
	;Pick a random path to follow (From 4 possible)
	JSR GetRandom1
	AND #%00000011
	ASL A	;Multiply by 2
	CLC
	ADC Temp1
	TAX
	
	LDA MovementData, X
	STA AutoPlayLow	
	LDA MovementData+1, X
	STA AutoPlayHigh
	
	;Set up the default values
	LDY #$00
	LDA [AutoPlayLow], Y
	STA AutoPlayCounter
	INC AutoPlayCounter		;Add 1 to offset data
	JSR NextAutoPointer
	
	LDA [AutoPlayLow], Y
	STA AutoPlayCurrentKey
	JSR NextAutoPointer
	
	RTS
	
;Go to the next memory location for the autoplay pointer
NextAutoPointer
	INC AutoPlayLow
	BNE .skip
	INC AutoPlayHigh
.skip
	RTS
	
	
SetUpKeyLogger:
	LDA #$00
	STA LoggerLow
	STA LoggerCurKey
	STA LoggerCounter
	LDA #$05
	STA LoggerHigh
	RTS
	