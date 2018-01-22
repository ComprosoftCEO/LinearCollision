;Cheats are indicated by a series of sprites and palettes
LoadCheatSprites:
	LDX #$00
.loop
	LDA CheatSprData, X
	STA $0200, X
	INX
	CPX #14*4
	BNE .loop
	RTS

;Turns on or off colors based on the cheat mode
UpdateCheatPalette:

	.include "Macros/CheatColor.asm"

	;Make sure cheat mode is enabled
	LDA CheatMode
	AND #CheatBit			;You must press select 64 times
	BNE .cont
	
	;If disabled, reset colors
	LDA #$0F
	LDX #$00
.loop
	STA PaletteData+16,X
	INX
	CPX #$10
	BNE .loop
	RTS
	
.cont
	CheatColor #$01,CheatPal1,PaletteData+16+1
	CheatColor #$02,CheatPal2,PaletteData+16+1+4
	CheatColor #$04,CheatPal3,PaletteData+16+1+8
	CheatColor #$08,CheatPal4,PaletteData+16+1+12
	RTS
	
	
	
CheatKeyPress:
	LDA C1Data
	AND #%00100000
	BEQ .noKey
	
	LDA AKeyPress		;If the key is currently pressed, then skip
	BNE .exit
	
	;Make sure both A and B are pressed
	LDA C1Data
	AND #%10000000
	BEQ .notAllowed
	LDA C1Data
	AND #%01000000
	BEQ .notAllowed
	
	LDA CheatMode
	AND #CheatBit		;Once enabled, it is always enabled
	BEQ	.next
	LDX CheatMode
	INX
	TXA
	AND #$0F
	ORA #CheatBit
	STA CheatMode
	JMP .notAllowed
	
.next	
	LDX CheatMode
	INX
	TXA
	STA CheatMode

.notAllowed
	LDA #$01
	STA AKeyPress		;Key is now pressed
	RTS
	
.noKey
	STA AKeyPress		;Turn off the A Key Press
.exit
	RTS
	
	
;Set up the cheat counter
CheatCounter:	
	LDA CheatMode		;Test if cheat mode is enabled?
	AND #CheatBit
	BEQ .noCheat
	
	LDA CheatMode
	AND #$01
	BEQ .noCheat

	;Load the invincible sprites
	LDA #$66
	STA InvincibleSpr
	
	LDX #$00
.cheatLoop
	LDA CheatInvincibleSprite, X
	STA $0300-4,X
	INX
	CPX #$04
	BNE .cheatLoop
	
.noCheat	
	RTS

	
	;Draw infinity for timer
CheatTimer:
	LDA CheatMode		;Test if cheat mode is enabled?
	AND #CheatBit
	BEQ .noCheat
	
	LDA CheatMode
	AND #$02
	BEQ .noCheat

	;Overwrite the colon
	LDA $2002
	LDA #$20
	STA $2006
	LDA #$3B
	STA $2006
	LDA #$70
	STA $2007
	
	LDX #$00		;Reprogram the sprites
.loop
	LDA CheatTimerSprite, X
	STA $0210, X
	INX
	CPX #12
	BNE .loop
	
	;Reprogram the timer sprite data
	
.noCheat
	RTS
	
	
;Collect all of the energy items
CheatEnergy:
	
	;Make sure this hasn't happened yet
	LDA ExitTimer
	CMP #$FF
	BEQ .cont
	RTS

.cont	
	;Play the energy collect sound
	LDA #$02
	JSR sound_load
	
	;Turn on all colors
	LDA #ColRed
	STA ERed+12
	LDA #ColYellow
	STA EYellow+12
	LDA #ColGreen
	STA EGreen+12
	LDA #ColBlue
	STA EBlue+12

	;Disable the palettes
	LDA #$0F
	STA ERed
	STA EYellow
	STA EGreen
	STA EBlue

	RTS
	
CheatSprData:
	;Y, Tile, Information, X
	
	;Infinite Energy 	(0x*)
  .db $78,$68,$00,$08+64
  .db $78,$1F,$00,$10+64
  .db $78,$66,$00,$18+64
  .db $78,$67,$00,$20+64
  
  ;No Time	(No 0)
  .db $78,$2E,$01,$08+144
  .db $78,$2F,$01,$10+144
  .db $78,$69,$01,$20+144
  
  ;Can't be hurt    (* OFF)
  .db $82,$0D,$02,$08+64
  .db $82,$2F,$02,$14+64
  .db $82,$26,$02,$1C+64
  .db $82,$26,$02,$24+64
  
  ;B = All Energy (B=[])
  .db $82,$22,$03,$08+144
  .db $82,$57,$03,$14+144
  .db $82,$03,$03,$20+144
  
  
;The palettes for the cheat sprites
CheatPal1:
  .db $30,$30,$30
CheatPal2:
  .db $30,$30,$30
CheatPal3:
  .db $30,$30,$30
CheatPal4:
  .db $30,$30,$30
  
CheatInvincibleSprite:
  .db 7,$67,03,136
  
CheatTimerSprite:
  .db 7,$66,03,212, 7,$67,03,220, 7,00,03,232		;Time counter