ShowTitle:
	JSR DisableScreen
	JSR LoadTitlePalette
	
	LDX #$00			;Load the background
	LDY #$00
	
	LDA $2002             ; read PPU status to reset the high/low latch
	LDA #$20
	STA $2006             ; write the high byte of $2000 address
	LDA #$40
	STA $2006             ; write the low byte of $2000 address

	LDA #LOW(TitleData)
	STA Temp1
	LDA #HIGH(TitleData)
	STA Temp2
	LDY #$00
	
	LDA #20			;Use Temp 3 as a scan line counter 1F
	STA Temp3
.loop1
	LDX #$00
.loop2
	LDA [Temp1], Y
	STA $2007
;Update the pointer
	INC Temp1
	BNE .next
	INC Temp2
.next
	INX
	CPX #32
	BNE .loop2
	DEC Temp3
	BNE .loop1

	
;Set up the attributes for the text at the bottom	
	LDA $2002             ; read PPU status to reset the high/low latch
	LDA #$23
	STA $2006             ; write the high byte of $2000 address
	LDA #$E8
	STA $2006             ; write the low byte of $2000 address
	
	LDX #$00
.loop3	
	LDA TitleAttrib, X
	STA $2007
	INX
	CPX #$08
	BNE .loop3
	
	;Set up palette pointers for the title
	LDA #$01
	STA Temp1
	LDA #$06
	STA Temp2
	LDA #$0C
	STA Temp3
	
	LDA #01			;Temp4 = Counter
	STA Temp4

	LDA #$80
	STA $2000
	
	JSR WaitNMI			;Wait for NMI before turning on the screen

	JSR UpdatePPU

	JSR WaitStart
	
	
	LDA #01			;Reset the level counter
	STA LevelNumber
	
	LDA #$02			;Reset the number of invincibles left
	STA InvincibleLeft
	
	RTS 
	
	
WaitStart:
	JSR UpdateTitlePal
	JSR GetControls
	LDA C1Data
	AND #%00010000		;Test for start key
	BEQ WaitStart
	RTS 