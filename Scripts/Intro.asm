;Draw the Comprosoft Intro

	LDA #%00011000	;Enable display for the intro, but not NMI
	STA $2001
	
	;Use places 00 and 01 for temp data storage 
	;00 = # of tiles (*2)
	;01 = X Position
	LDA #$02
	STA $00
	LDA #$6E
	STA $01
	
	JSR Wait1Sec		;Wait before starting
	
;Load the starting address into the PPU for the underscore
	LDA $2002	;Reset the High/Low Latch
	LDA #$21
	STA $2006
	LDA #$AF
	STA $2006	
	
	JSR DrawUndrscore
	
	
	
	;The C:\> text
InitialText:
	JSR Wait1Sec
	LDY #$00
	
InitialDrawLoop:
	
	JSR InputNextLine
	LDX #$00
	
DrawILetter1:		;Line 1
	LDA ComprosoftFirstText1, X
	STA $2007
	INX
	CPX $00
	BNE DrawILetter1
	
	JSR IncramentLineAddress
	JSR InputNextLine
	LDX #$00
	
DrawILetter2:		;Line 2
	LDA ComprosoftFirstText2, X
	STA $2007
	INX
	CPX $00
	BNE DrawILetter2	
	
	JSR IncramentLineAddress
	JSR InputNextLine
	LDX #$00
	
DrawILetter3:		;Line 3
	LDA ComprosoftFirstText3, X
	STA $2007
	INX
	CPX $00
	BNE DrawILetter3
	
	JSR DrawUndrscore
	JSR Wait1Sec
	
	;Do the math to run the loop again
	LDA $00
	CLC
	ADC #$02	;The number of tiles
	STA $00
	
	LDA $01
	SEC
	SBC #$41	;Reset the x position of the tile
	STA $01
	
	INY
	CPY #$04
	BEQ InitialCont
	JMP InitialDrawLoop
	
	
	
	
	
InitialCont:
	;JSR Wait1Sec
	
	;Now, prepare the data for the long copying process
	LDA #$04		;Tiles in the word Comprosoft
	STA $00
	LDA #$6B		;X positon
	STA $01
	
	LDY #$00
	
	
	
	
	
;Copy the full Comprosoft Text, then add the colon on to the end of each row
ComprosoftTextLoop:
	JSR InputNextLine
	LDX #$00
	
DrawCLetter1:		;Line 1
	LDA ComprosoftLogo1, X
	STA $2007
	INX
	CPX $00
	BNE DrawCLetter1
	
	LDX #$00
DrawColon1:
	LDA ComprosoftColon1, X
	STA $2007
	INX
	CPX #$06
	BNE DrawColon1
	
	JSR IncramentLineAddress
	JSR InputNextLine
	LDX #$00	

DrawCLetter2:		;Line 2
	LDA ComprosoftLogo2, X
	STA $2007
	INX
	CPX $00
	BNE DrawCLetter2
	
	LDX #$00
DrawColon2:
	LDA ComprosoftColon2, X
	STA $2007
	INX
	CPX #$06
	BNE DrawColon2
	
	JSR IncramentLineAddress
	JSR InputNextLine
	LDX #$00	

DrawCLetter3:		;Line 3
	LDA ComprosoftLogo3, X
	STA $2007
	INX
	CPX $00
	BNE DrawCLetter3
	
	LDX #$00
DrawColon3:
	LDA ComprosoftColon3, X
	STA $2007
	INX
	CPX #$06
	BNE DrawColon3
	
	JSR IncramentLineAddress
	JSR InputNextLine
	LDX #$00		
	
	JSR WaitHalfSec

;Do the math to run the loop again
	LDA $00
	CLC
	ADC #$02	;The number of tiles
	STA $00
	
	LDA $01
	SEC
	SBC #$61	;Reset the x position of the tile
	STA $01
	
	INY
	CPY #$09
	BEQ PresentsText
	JMP ComprosoftTextLoop	
	
PresentsText:

	JSR WaitHalfSec
	JSR WaitHalfSec
	
	LDX #$00
	LDA #$22
	STA $2006
	LDA #$2C
	STA $2006
	
PresentsLoop:
	LDA ComprosoftPresents, X
	STA $2007
	INX
	CPX #$08
	BNE PresentsLoop

	JSR Wait1Sec
	JSR Wait1Sec
	
	JMP LoadTitle
	
	
	
;--------------Subroutines Used---------------------	
	
	
Wait1Sec:	;Wait 1 second before updating the frame
	LDA #$00        ;tell the ppu there is no background scrolling
	STA $2005
	STA $2005 
	LDX #$00
.waitvblank:       ; do exactly 256 vblanks
	BIT $2002
	BPL .waitvblank
	INX
	CPX #$40
	BNE .waitvblank
	RTS

WaitHalfSec:	;Wait 1 second before updating the frame
	LDA #$00        ;tell the ppu there is no background scrolling
	STA $2005
	STA $2005 
	LDX #$00
.waitvblank:       ; do exactly 256 vblanks
	BIT $2002
	BPL .waitvblank
	INX
	CPX #$08
	BNE .waitvblank
	RTS	
	
DrawUndrscore:		;Draw the underscore
	LDA #$F9
	STA $2007
	LDA #$FA
	STA $2007
	RTS
		
IncramentLineAddress:		;Sets the line to the next line
	LDA $01
	CLC
	ADC #$20
	STA $01
	RTS
	
InputNextLine:
	LDA #$21
	STA $2006		;Configure the PPU starting
	LDA $01
	STA $2006
	RTS
	