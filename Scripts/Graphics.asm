;Various graphic functions
DisableScreen:
	PHA
	LDA #$00
	STA $2000
	STA $2001
	PLA
	RTS

;Update the PPU with the settings stored in memory
UpdatePPU:
	PHA	
	LDA PPU_Setting1
	STA $2000
	LDA PPU_Setting2
	STA $2001
	PLA
	RTS
	
;Reset the $2005 latch to remove any scrolling
NoScroll:
	PHA
	LDA $2002
	LDA #$00
	STA $2006
	STA $2006
	STA $2005
	STA $2005
	PLA
	RTS 
	
	
;Reset all graphics on the screen
ResetBackground:
	
	PHA
	TXA
	PHA		;Store registers
	TYA
	PHA
	
	LDA $2002
	LDA #$20
	STA $2006
	LDA #$00
	STA $2006
	
	LDY #$1E
.loop
	LDX #$20
.loop2
	STA $2007
	DEX
	BNE .loop2
	DEY
	BNE .loop

	PLA
	TAY
	PLA		;Get registers
	TAX
	PLA
	
	RTS
	
	
ResetAttrib:
	
	PHA
	TXA		;Store registers
	PHA
	
	LDA $2002
	LDA #$23
	STA $2006
	LDA #$C0
	STA $2006
	
	LDX #$40
	LDA #$00
.loop
	STA $2007
	DEX
	BNE .loop
	
	PLA
	TAX		;Get registers
	PLA
	
	RTS
	
WaitNMI:
	LDA #$00
	STA NMI_Fired
.loop
	LDA NMI_Fired
	BEQ .loop
	RTS 
	
	
ResetSprites:
	LDA #$00
	LDX #$00
.loop
	STA $0200, X
	INX
	BNE .loop
	RTS
	
	
	
	
CalculatePPUXY:
	;Get a PPU address with PPU_High and PPU_Low
	;Return TempX and TempY
	
	LDA #$00
	STA TempX		;Reset TempX and Y
	STA TempY
	
	LDA PPU_High		;Subtract #$1F to zero this number, but allow for one subtraction
	SEC
	SBC #$1F
	STA PPU_High
	
	;First, calculate the Y value
	;Subtract 32 from X until temp3 = 0
.loop
	LDA TempY
	CLC			;Add 8 to Y every time
	ADC #$08
	STA TempY
	
	LDA PPU_Low	;Load Low Byte
	SEC
	SBC #32		;Subtract 32 until a carry occurs
	STA PPU_Low
	BCS .loop
	
	DEC PPU_High	;Subtract one from high byte
	BNE .loop	;Keep looping until this equals 0
	
	LDA TempY
	SEC				;This loop returns the roof, so do the floor
	SBC #$09
	STA TempY

	LDA PPU_Low		;Load the low byte
	CLC
	ADC #32		;Add 32 to fix the overflow
	ASL A
	ASL A			;Shift left 4 times to multiply by 8
	ASL A
	STA TempX
	
	RTS 
	
	
	
GetAttributeXY:
	;Takes in an XY coordinate from TempX and TempY
	;Turn these into PPU Coordinates
	
	LDA TempX	;Load X
	LSR A
	LSR A
	LSR A	;Divide by 32
	LSR A
	LSR A
	STA Temp3
	
	LDA TempY	;Load Y
	CLC
	ADC #$01	;Y is off by 1 scanline
	AND #%11100000	;Cancel out last 5 digits
	LSR A	;Divide by 32, multiply by 8
	LSR A
	
	CLC
	ADC #$C0		;Attributes start at $C0
	CLC
	ADC Temp3
	STA PPU_Low
	
	LDA #$23
	STA PPU_High
	
	RTS 
	
	
PutAttribute:
	;Grabs the attribute from Temp3
	;Replaces the TempX,TempY attribute

	TXA	
	PHA			;Store X and Y onto stack
	TYA
	PHA
	
	;Now set up the PPU to read the current attribute
	LDA $2002
	LDA PPU_High
	STA $2006
	LDA PPU_Low
	STA $2006
	
	LDA $2007		;First read is invalid
	LDA $2007
	STA PPU_Attrib		;Store the attribute in $2007
	
	;And reset again
	LDA $2002
	LDA PPU_High
	STA $2006
	LDA PPU_Low
	STA $2006
	
	LDX #$00		;X = Counter
	
	LDA TempX		;Get X
	AND #%00010000	;Divide by 16, and find the remainder
	BEQ .skip	;Skip when not 0
	INX		;Add 1 to counter
.skip

	LDA TempY		;Get Y
	CLC
	ADC #$01		;Y if off by 1 scanline
	AND #%00010000	;Divide by 16, and find the remainder
	BEQ .skip2		;Skip when 0
	INX
	INX		;Add 2 to counter
	
.skip2	
	TXA
	TAY		;Backup X to Y

	;Now shift
	LDA #%00000011
	CPX #$00
	BEQ .exitLoop
.loop1
	ASL A
	ASL A
	DEX
	BNE .loop1
	
.exitLoop	
	EOR #$FF		;Figure out which digits to cancel out
	AND PPU_Attrib	;Cancel
	TAX				;Store this value into X
	
	LDA Temp3		;Shift the replacement value into the replace position
	CPY #$00
	BEQ .exitLoop2
.loop2
	ASL A
	ASL A
	DEY
	BNE .loop2
.exitLoop2
	STA Temp3
	TXA
	STA $0301
	ORA Temp3		;And replace
	STA $2007
	
	PLA
	TAY
	PLA		;Get register values back
	TAX
	
	RTS	