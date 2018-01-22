ShowTitle:
	JSR DisableScreen
	
	JSR ResetBackground
	JSR ResetAttrib
	JSR ResetSprites
	
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
	
.loop1
	LDA [Temp1], Y		;Load the counter
	BEQ .exit			;Stop the counter when it reaches 0
	STA Temp3
	
	JSR NextByte
	
.next1
	LDA [Temp1], Y
.loop3
	STA $2007
	DEC Temp3
	BNE .loop3

;Update the pointer
	JSR NextByte
	JMP .loop1

	
.exit	
	
;Set up the attributes for the text at the bottom	
	LDA $2002             ; read PPU status to reset the high/low latch
	LDA #$23
	STA $2006             ; write the high byte of $2000 address
	LDA #$E8
	STA $2006             ; write the low byte of $2000 address
	
	LDX #$00
.loop4	
	LDA TitleAttrib, X
	STA $2007
	INX
	CPX #16
	BNE .loop4
	
	;Set up palette pointers for the title
	LDA #$01
	STA Temp1
	LDA #$06
	STA Temp2
	LDA #$0C
	STA Temp3
	
	LDA #01			;Temp4 = Counter for colors
	STA Temp4
	LDA #60		;Temp5 = Counter for Press Start
	STA Temp5

	LDA #$80
	STA $2000
	
	JSR WaitNMI			;Wait for NMI before turning on the screen
	
	
	LDA #01			;Reset the level counter
	STA LevelNumber
	STA StKeyPress	;Wait for start to be released
	
	LDA #$02			;Reset the number of invincibles left
	STA InvincibleLeft
	
	LDA #$00
	STA LayoutNumber		;Always start with default layout
	STA AutoPlayTimer		;Reset the autoplay counter
	
	;Reset the previous layouts counter
	LDX #$00
.layout
	STA PreviousLayouts, X
	INX
	CPX #$03
	BNE .layout
	
	JSR WaitStart
	
	RTS 
	
	
WaitStart:
	JSR UpdateTitlePal
	JSR GetControls
	LDA C1Data
	AND #%00010000		;Test for start key
	BEQ .nokey
	
	LDA StKeyPress
	BNE WaitStart
	
	RTS
	
.nokey
	LDA #$00
	STA StKeyPress
	JMP WaitStart
	
	
	
NextByte:
	INC Temp1		;move counter forward
	BNE .return
	INC Temp2
.return
	RTS
