;---------------------Random Numbers--------------------------

;This program uses 3 random number generators that run simultaneously
;To produce many types of mazes possible

GetRandom1:			;Get the next random number in a sequence
	LDA Seed1
	BEQ .DoEor
	ASL A
	BEQ .NoEor
	BCC .NoEor
.DoEor:
	EOR XorVal1
.NoEor:
	STA Seed1
	RTS
	
	
GetRandom2:
	LDA Seed2
	BEQ .DoEor
	ASL A
	BEQ .NoEor
	BCC .NoEor
.DoEor:
	EOR XorVal2
.NoEor:
	STA Seed2
	RTS

	
GetRandom3:
	LDA Seed3
	BEQ .DoEor
	ASL A
	BEQ .NoEor
	BCC .NoEor
.DoEor:
	EOR XorVal3
.NoEor:
	STA Seed3
	RTS
	
	
MixNumbers:
	JSR GetRandom3
	AND #$0F
	TAX
	LDA XorVals, X
	STA XorVal1
	
	JSR GetRandom2
	AND #$0F
	TAX
	LDA XorVals, X
	STA XorVal3
	
	JSR GetRandom1
	AND #$0F
	TAX
	LDA XorVals, X
	STA XorVal2
	RTS
	
	
MixNumbers2:
	JSR GetRandom3
	STA Seed1
	
	JSR GetRandom2
	STA Seed3
	
	JSR GetRandom1
	STA Seed2
	RTS	
	
	
RandInt:		;Produce a random number RandMin<= X <= RandMax 
	LDA RandMax
	SEC
	SBC RandMin
	CLC
	ADC #$01			;Find the difference between the range
	STA RandDif
	JSR GetRandom2
	
.TestMax
	CMP RandMax
	BCC .TestMin
	SEC
	SBC RandDif
	JMP .TestMax
.TestMin
	CMP RandMin
	BCS .Return
	CLC
	ADC RandDif
	JMP .TestMin
	
.Return
	RTS 
	