ShufflePalette:
	LDX #$03

.loop
	JSR RandomColor
	STA PaletteData+16, X
	INX
	INX
	INX
	INX
	CPX #19
	BNE .loop
	JSR GetRandom2


RandomColor:		;Return a valid color from the table
	LDA #$00
	STA RandMin
	LDA #48
	STA RandMax
	JSR RandInt
	TAY
	LDA AllowedColors, Y
	RTS
	
UpdatePlayField:
	DEC PlayFieldTimer
	BNE .exit		;Skip if the timer isn't 0
	INC PlayFieldColor
	LDA PlayFieldColor
	AND #$0F
	STA PlayFieldColor
	TAX
	LDA PlayFieldColors, X
	STA PaletteData+3
	STA PaletteData+7		;Store in the 3rd spot of every bg palette
	STA PaletteData+11
	STA PaletteData+15
.exit
	RTS
	
	
UpdatePalette:
	LDA $2002		;Reset latch
	LDA #$3F
	STA $2006		;Palette data is at $3F00
	LDA #$00
	STA $2006
	LDX #$00
.loop
	LDA PaletteData, X
	STA $2007
	INX
	CPX #$20
	BNE .loop	
	RTS
	
	
UpdateExitPalette:
	;Update the special exit palette
	LDX ExitTimer
	CPX #$FF			;FF = Do nothing
	BEQ .exit
	
	DEX
	STX ExitTimer
	CPX #$00
	BNE .exit
	
	INC ExitColor
	LDA ExitColor	;Move the exit color forward by 1
	AND #$0F
	STA ExitColor
	TAX
	LDY #$01
.loop
	TXA
	CLC
	ADC #$01		;Update the next set of colors starting at Exit color
	AND #$0F
	TAX
	LDA PlayFieldColors, X
	STA PaletteData+12, Y
	INY
	CPY #$03
	BNE .loop

	;Reset the timer
	LDA #$04
	STA ExitTimer
.exit	
	RTS
	
	
LoadGameplayPalette:
	LDX #$00
.PaletteLoop
	LDA Palette, X
	STA PaletteData, X
	INX
	CPX #$20
	BNE .PaletteLoop
	RTS
	
LoadTitlePalette:
	LDX #$00
.PaletteLoop
	LDA TitlePalette, X
	STA PaletteData, X
	INX
	CPX #$20
	BNE .PaletteLoop
	RTS	
	
	
UpdateTitlePal:
	.include "Macros/TitlePal.asm"
	LDA NMI_Fired		;Wait for a NMI
	BEQ .skip
	
	LDA #$00
	STA NMI_Fired
	
	DEC Temp4
	BNE .skip		;Only update every 2 seconds
	LDA #240
	STA Temp4
	
	TitlePal Temp1, PaletteData+1
	TitlePal Temp2, PaletteData+2
	TitlePal Temp3, PaletteData+3
.skip
	RTS
	
	
	

AllowedColors:		;Totals about 48
  .db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C
  .db $11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C
  .db $21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C
  .db $31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C
  
PlayFieldColors:
  .db $15,$16,$26,$27,$28,$39,$29,$2A,$2B,$2C,$21,$11,$12,$13,$14,$25