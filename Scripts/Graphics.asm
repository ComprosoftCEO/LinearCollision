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