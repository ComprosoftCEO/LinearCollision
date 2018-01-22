;Draw the Comprosoft Intro
ComprosoftIntro:

	LDA #$80
	STA $2000
	JSR WaitNMI

	JSR DisableScreen

	;Start by loading the Comprosoft palette
	LDA $2002
	LDA #$3F
	STA $2006		;Palette data is at $3F00
	LDA #$00
	STA $2006
	
	LDA #$0f		;Make sure BG is black
	STA $2007
	
	LDX #$03
	LDA #$29		;Default color is $29
.loop
	STA $2007
	DEX
	BNE .loop
	

	LDA #$00
	STA $2000
	LDA #%00011000	;Enable display for the intro, but not NMI
	STA $2001
	
	;Use places 00 and 01 for temp data storage 
	;Temp1 = # of tiles (*2)
	;Temp2 = X Position
	LDA #$02
	STA Temp1
	LDA #$6E
	STA Temp2
	
	JSR CWait1Sec		;Wait before starting
	
;Load the starting address into the PPU for the underscore
	LDA $2002	;Reset the High/Low Latch
	LDA #$21
	STA $2006	;Fill in the address to draw
	LDA #$AF
	STA $2006	
	
	JSR DrawUndrscore
	
	
	
	;--------------The C:\> text---------------
InitialText:
	JSR CWait1Sec
	LDY #$00
	
InitialDrawLoop:
	
	JSR InputNextLine
	LDX #$00
	
DrawILetter1:		;Line 1
	LDA ComprosoftFirstText1, X
	STA $2007
	INX
	CPX Temp1
	BNE DrawILetter1
	
	JSR IncramentLineAddress
	JSR InputNextLine
	LDX #$00
	
DrawILetter2:		;Line 2
	LDA ComprosoftFirstText2, X
	STA $2007
	INX
	CPX Temp1
	BNE DrawILetter2	
	
	JSR IncramentLineAddress
	JSR InputNextLine
	LDX #$00
	
DrawILetter3:		;Line 3
	LDA ComprosoftFirstText3, X
	STA $2007
	INX
	CPX Temp1
	BNE DrawILetter3
	
	JSR DrawUndrscore
	JSR CWait1Sec
	
	;Do the math to run the loop again
	LDA Temp1
	CLC
	ADC #$02	;The number of tiles
	STA Temp1
	
	LDA Temp2
	SEC
	SBC #$41	;Reset the x position of the tile
	STA Temp2
	
	INY
	CPY #$04
	BEQ InitialCont
	JMP InitialDrawLoop
	
	
	
	
	
InitialCont:
	
	;Now, prepare the data for the long copying process
	LDA #$04		;Tiles in the word Comprosoft
	STA Temp1
	LDA #$6B		;X positon
	STA Temp2
	
	LDY #$00
	
	
	
	
	
;------------Copy the full Comprosoft Text, then add the colon on to the end of each row---------
ComprosoftTextLoop:
	JSR InputNextLine
	LDX #$00
	
DrawCLetter1:		;===Line 1===
	LDA ComprosoftLogo1, X
	STA $2007
	INX
	CPX Temp1
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

DrawCLetter2:		;===Line 2===
	LDA ComprosoftLogo2, X
	STA $2007
	INX
	CPX Temp1
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

DrawCLetter3:		;===Line 3===
	LDA ComprosoftLogo3, X
	STA $2007
	INX
	CPX Temp1
	BNE DrawCLetter3
	
	LDX #$00
DrawColon3:			;Add the :\>
	LDA ComprosoftColon3, X
	STA $2007
	INX
	CPX #$06
	BNE DrawColon3
	
	JSR IncramentLineAddress
	JSR InputNextLine
	LDX #$00		
	
	JSR CWaitHalfSec

	

;Do the math to run the loop again
	LDA Temp1
	CLC
	ADC #$02	;The number of tiles
	STA Temp1
	
	LDA Temp2
	SEC
	SBC #$61	;Reset the x position of the tile
	STA Temp2
	
	INY
	CPY #$09
	BEQ PresentsText
	JMP ComprosoftTextLoop	
	
	
	
PresentsText:		;--Finally, add the text that says "PResents"

	LDA $02
	CMP #$FF
	BEQ EndIntro

	JSR CWaitHalfSec		;Wait 2 half seconds
	JSR CWaitHalfSec
	
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

EndIntro:
	JSR CWaitSecNoSkip
	JSR CWaitSecNoSkip	
	
	RTS
	
	
	
;--------------Subroutines Used---------------------	
	
DrawUndrscore:		;Draw the underscore
	LDA #$F9
	STA $2007
	LDA #$FA
	STA $2007
	RTS
		
IncramentLineAddress:		;Sets the line to the next line
	LDA Temp2
	CLC
	ADC #$20
	STA Temp2
	RTS
	
InputNextLine:
	LDA #$21
	STA $2006		;Configure the PPU starting
	LDA Temp2
	STA $2006
	RTS
	
	
;Write the whole bit of text on the screen	
SkipComprosoft:
	PLA
	PLA		;Remove last JSR

	LDA #$14
	STA Temp1
	LDA #$63
	STA Temp2

	LDA #$FF
	STA $02
	
	LDX #$00
	LDA #$22
	STA $2006
	LDA #$2C
	STA $2006
	
.Presents:
	LDA ComprosoftPresents, X
	STA $2007
	INX
	CPX #$08
	BNE .Presents
	
	LDY #$08
	JMP ComprosoftTextLoop
	
	
	
;-----------Comprosoft Intro Timing Codes-------

CWait1Sec:	;Wait 1 second before updating the frame
	LDA #$00        ;tell the ppu there is no background scrolling
	STA $2005
	STA $2005 
	LDX #$00
.waitvblank:       ; do exactly 256 vblanks
	BIT $2002
	BPL .waitvblank
	JSR GetControls
	LDA C1Data		;Test for the start key
	AND #%00010000
	BEQ .Skip2
	JMP SkipComprosoft
.Skip2						;Repeat 64 times to delay approx. 1 sec
	INX
	CPX #$40
	BNE .waitvblank
	
	JSR GetRandom1
	JSR GetRandom2
	JSR GetRandom3
	JSR MixNumbers
	
	RTS
	

CWaitHalfSec:	;Wait a half second before updating the frame
	LDA #$00        ;tell the ppu there is no background scrolling
	STA $2005
	STA $2005 
	LDX #$00
.waitvblank:       ; do exactly 256 vblanks
	BIT $2002
	BPL .waitvblank
	JSR GetControls
	LDA C1Data
	AND #%00010000
	BEQ .Skip
	JMP SkipComprosoft
.Skip						;Repeat 8 times to delay a short "half" second
	INX
	CPX #$08
	BNE .waitvblank

	JSR GetRandom1
	JSR GetRandom2
	JSR GetRandom3
	JSR MixNumbers
	
	RTS		
	
	
CWaitSecNoSkip:		;Wait 1 second before updating the frame, no skipping
	LDA #$00        ;tell the ppu there is no background scrolling
	STA $2005
	STA $2005 
	LDX #$00
.waitvblank:       ; do exactly 256 vblanks
	BIT $2002
	BPL .waitvblank
	INX
	CPX #$40			;Repeat 64 times
	BNE .waitvblank
	
	JSR GetRandom1
	JSR GetRandom2
	JSR GetRandom3
	JSR MixNumbers
	
	RTS