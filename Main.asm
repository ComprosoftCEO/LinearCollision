;Linear Collision NES
;Programmed by Bryan McClain


;iNES Header
	.inesprg 1   ; one (1) bank of 16 K program code
	.ineschr 1   ; one (1) bank of 8 K picture data
	.inesmap 0   ; we use mapper 0
	.inesmir 0   ; Vertical mirroring
	

;-------------Define some basic constants----------------
PPUC1_Default=%10000000
PPUC2_Default=%00011000
	
	
;------------------Start of Code-------------------------	
  .bank 0
  .org $8000
  
Start:

	BIT $2002
vblankwait1:      ; First, wait for vblank to make sure PPU is ready
	BIT $2002
	BPL vblankwait1
vblankwait2:      ; First, wait for vblank to make sure PPU is ready
	BIT $2002
	BPL vblankwait2	

	LDA #$00		;Turn off display to load default assets
	STA $2000
	STA $2001

;Load the basic palette into the memory
	LDA $2002             ; read PPU status to reset the high/low latch
	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
	
	LDX #$00
	
PaletteLoop:
	LDA Palette, X
	STA $2007
	INX
	CPX #$20
	BNE PaletteLoop

	.include "Scripts/Intro.asm"
	
vblankwait3:      ; Wait for another vBlank before messing with settings
	BIT $2002
	BPL vblankwait3	
	
LoadTitle:
	LDA #$00		;Turn off display to load in title
	STA $2000
	STA $2001
	.include "Scripts/LoadTitle.asm"


;Turn the screen on
	LDA #%10000000
	STA $2000
	LDA #%00110000		;Turn off display to load default assets
	STA $2001
	
Forever:
	JMP Forever
	
	
NMI:
	LDA #%10000000
	STA $2000
	LDA #%00011110
	STA $2001
	LDA #$00
	STA $2005
	STA $2005
	RTI   
  
  
  
;--------------------Other Data--------------------------
	
  .bank 1
  .org $E000
  
Palette:
  .db $0F,$1A,$0A,$2,$0F,$35,$36,$37,$0F,$39,$3A,$3B,$0F,$3D,$3E,$0F	;Background (0,1,2,3)
  .db $0F,$07,$17,$27,$0F,$02,$38,$3C,$0F,$1C,$15,$14,$0F,$02,$38,$3C	;Sprites (0,1,2,3)  

	.include "Data/TitleData.asm"
	.include "Data/ComprosoftData.asm"
;------------------Interrupts-----------------------------
  
  
  .org $FFFA     ;interrupts start at $FFFA

	.dw NMI      ; location of NMI Interrupt
	.dw Start    ; code to run at reset
	.dw 0		 ;IQR interrupt (not used)
	


;--------------------Graphics-----------------------------
	
  .bank 2        ; change to bank 2 - Graphics information
  .org $0000     ;Graphics start at $0000

	.incbin "Graphics.chr"  ; Include Binary file that will contain all program graphics