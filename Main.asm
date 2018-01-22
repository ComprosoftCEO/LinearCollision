;Linear Collision NES
;Programmed by Bryan McClain


;iNES Header
	.inesprg 2   ; one (1) bank of 16 K program code
	.ineschr 1   ; one (1) bank of 8 K picture data
	.inesmap 0   ; we use mapper 0
	.inesmir 0   ; Vertical mirroring
	

;-------------Define some basic constants----------------
PPUC1_Default=%10000000
PPUC2_Default=%00011000


;------------------Define Variables----------------------
  .rsset $0000
  
Temp1		.rs 1
Temp2		.rs 1
Temp3		.rs 1		;Some random temp locations
Temp4		.rs 1		
Temp5		.rs 1  
Temp6		.rs 1  
TempX		.rs 1		;Temp locations for XY values
TempY		.rs 1

sound_ptr .rs 2			;Sound pointers
sound_ptr2 .rs 2  
  
Seed1		.rs 1
XorVal1 	.rs 1			;All random number generators (1 - 3)
Seed2 		.rs 1	
XorVal2		.rs 1
Seed3		.rs 1
XorVal3		.rs 1
RandMin		.rs 1
RandMax		.rs 1
RandDif		.rs 1

PPU_Setting1	.rs 1			;Change the PPU settings for the NMI
PPU_Setting2  	.rs 1
PPU_High		.rs 1			;Temp locations for PPU high and low addresses
PPU_Low			.rs 1
PPU_Attrib		.rs 1			;Temp location for the attribute
NMI_Fired		.rs 1			;Had a NMI occured?
PaletteData		.rs 32			;Palette is stored in RAM to write to on next NMI

C1Data		.rs 1		;Controller 1
C2Data		.rs 1		;Controller 2
StKeyPress	.rs 1		;Start key press
AKeyPress	.rs 1		;A key press
CheatMode	.rs 1		;All data for the Cheat Mode

CheatBit = $10

EnemyReleaseTimer	.rs 48		;Counters for when the enemies should be released
EnemyCount			.rs 1		;The total enemy count
TopEnemyCount		.rs 1	
BottomEnemyCount	.rs 1		;Counters for the number of enemies on various sides
LeftEnemyCount		.rs 1
RightEnemyCount		.rs 1
EnemySprites = $0220			;Where the enemy sprites start

Probability			.rs 1		;Which numbers to AND so the result is 0
DigitsAllowed		.rs 1		;Cancel out some timer digits to make it more likely to release an enemy

PlayFieldTimer		.rs 1
PlayFieldColor		.rs 1

LevelNumber			.rs 1		;The current level
LayoutNumber		.rs 1		;The current layout (There are 16 total)
PreviousLayouts		.rs 3		;Store the 3 previous layouts

CollisionData = $0400			;Where the collsion data is stored
ChangeX				.rs 1		;How much to move the player
ChangeY				.rs 1		
NewX				.rs 1		;The new xy locations
NewY				.rs 1
TileX				.rs 1		;The XY tile positions
TileY				.rs 1
TileXRem			.rs 1		;Remainders of Tile X and Y
TileYRem			.rs 1
CollisionByte		.rs 1		;The byte number to look for in the collision data
CollisionBit		.rs 1		;The bit to look for in the collision data
TileTL				.rs 1
TileTR				.rs 1		;What tile is located in each quadrant
TileBL				.rs 1
TileBR				.rs 1
Check				.rs 4		;What tile quadrants to check (TL, TR, BL, BR)
Tiles				.rs 8		;The true/false of the surrounding tiles when loading the playing field

PlayerX				.rs 1		;The XY location of the player
PlayerY				.rs 1
HitTimer			.rs 1		;The timer for when the player can move again
InvensibleS			.rs 1		;The timer for when the play cannot be hit
InvensibleMS		.rs 1		
DefaultInvensible	.rs 1		;The default number of seconds of invensibility for this level
InvincibleLeft		.rs 1
InvincibleSpr = $021D		;This is the number of times the player can be invincible

ReadySprites = $02E0		;Where the get ready sprites should be

ExitX				.rs 1		;The XY location for the exit, used for checking exit
ExitY				.rs 1
ExitColor			.rs 1		;The location for the exit tiles on the screen		
ExitTimer			.rs 1		;FF = No color. Timer value 0-X-80
ExitAnimTimer		.rs 1		;The timer for the end of the game
ExitAnimSprite		.rs 1		;the sprite to be used in the exit

ERed = PaletteData+5
EYellow = PaletteData+9
EGreen = PaletteData+6		;Define the memory spots for the various colors
EBlue = PaletteData+10
RedX 		.rs 1
YellowX		.rs 1		;XY Values for all of the color locations
GreenX		.rs 1
BlueX		.rs 1
RedY		.rs 1
YellowY		.rs 1
GreenY		.rs 1
BlueY		.rs 1

ColRed = $16
ColYellow = $28		;Constants for the energy colors
ColGreen = $1A
ColBlue = $12	

LVLTens = $0209		;Locations for level sprites
LVLOnes = $020D

TimeMin = $0211			;Time for minutes
TimeTSec = $0215		;Time for tens of seconds
TimeOSec = $0219		;Time for hundreds of seconds
TimeCounter		.rs 1	;Frames until the next timer tick

AutoPlayLow			.rs 1	;Low and High pointers for automatic play
AutoPlayHigh		.rs 1
AutoPlayCounter		.rs 1
AutoPlayCurrentKey	.rs 1
AutoPlayTimer		.rs 1		;How many frames until the autoplay
AutoPlayEnabled		.rs 1		;Is Autoplay Enabled?
AutoPlayLayout		.rs 1

LoggerLow		.rs 1
LoggerHigh		.rs 1		;Various data spots for the key logger
LoggerCurKey	.rs 1
LoggerCounter	.rs 1


;------------------Start of Code-------------------------	
  .bank 0
  .org $8000
  
Reset:

	.include "Scripts/Reset.asm"
	
	;Set up random numbers
	LDA XorVals
	STA XorVal1
	LDA XorVals+1
	STA XorVal2
	LDA XorVals+2
	STA XorVal3
	
	JSR ComprosoftIntro
	
	LDA #$00		;Turn off display to load default assets
	STA $2000
	STA $2001

;Load the basic palette into the RAM
	
	JSR LoadGameplayPalette
	
Title:
	;Reset any sound data
	LDX #$00
	LDA #$00
.loop
	STA $0300, X
	INX
	BNE .loop

	;Enable sound channels
    jsr sound_init

	JSR ShowTitle

	JSR LoadGame
	
	JMP Gameplay

	
	
	
	
	
	
	
	
;----------------------NMI Code----------------------	
	
	
NMI:
	PHA			;Backup the accumulator & X to the stack
	TXA
	PHA
	TYA
	PHA
	
	LDA #$00   ;Disable NMI until end of NMI Code
    STA $2000
	
	;Use DMA to copy the sprites on every frame
    LDA #$00
    STA $2003  ; set the low byte (00) of the RAM address
    LDA #$02
    STA $4014  ; set the high byte (02) of the RAM address, start the transfer	

  ;Update the palette using the data stored in the RAM
	JSR UpdatePalette
	
  ;This is the PPU clean up section, so rendering the next frame starts properly.
	JSR NoScroll       ;tell the ppu there is no background scrolling
	JSR UpdatePPU
	
	LDA #$FF
	STA NMI_Fired		;Let the person know that the NMI fired
	
	JSR GetRandom1
	JSR GetRandom2
	JSR GetRandom3
	JSR MixNumbers
	
	JSR sound_play_frame    ;run our sound engine after all drawing code is done.
                            ;this ensures our sound engine gets run once per frame.
	
	PLA 		;And retrieve the accumulator & X
	TAY
	PLA
	TAX
	PLA
	
	RTI   
  

;--------------------Other Data--------------------------
  
Palette:
  .db $0F,$0F,$30,$2, $0F,$16,$1A,$37, $0F,$28,$12,$3B, $0F,$0F,$0F,$0F	;Background (0,1,2,3)
  .db $0F,$30,$30,$27,$0F,$30,$30,$3C,$0F,$1C,$30,$14,$0F,$02,$30,$3C	;Sprites (0,1,2,3)  

XorVals:
  .db $1d,$2b,$2d,$4d,$5f,$63,$65,$69,$71,$87,$8d,$a9,$c3,$cf,$e7,$f5
   
  
	.include "Data/TitleData.asm"
	.include "Data/ComprosoftData.asm"
	.include "Data/PlayFieldData.asm"	
	.include "Data/SpriteData.asm"	
	.include "Data/LevelData.asm"
	.include "Data/LookupTable.asm"
	.include "Data/AutoPlayData.asm"
		
  .bank 1
    .org $A000	
	
;-----------------Subroutines------------------ 
	.include "Scripts/Intro.asm"
	.include "Scripts/Controller.asm"
	.include "Scripts/Graphics.asm"
	.include "Scripts/Title.asm"	
	.include "Scripts/LoadGame.asm"
	.include "Scripts/Random.asm"
	.include "Scripts/Enemy.asm"
	.include "Scripts/Player.asm"
	.include "Scripts/Palette.asm"
	.include "Scripts/Collision.asm"
	.include "Scripts/Gameplay.asm"	
	.include "Scripts/Time.asm"	
	.include "Scripts/AutoPlay.asm"
	.include "Scripts/Cheat.asm"
	
	
;---------------------Maze Layouts----------
  .bank 2
	.org $C000
	
LevelCount = 25
	
	.include "Data/Levels/Default.asm"
	.include "Data/Levels/Abstract1.asm"
	.include "Data/Levels/Clumps1.asm"
	.include "Data/Levels/Clumps2.asm"
	.include "Data/Levels/Grid1.asm"
	.include "Data/Levels/Diamond.asm"
	.include "Data/Levels/Circuits.asm"
	.include "Data/Levels/Highway.asm"
	.include "Data/Levels/Arena.asm"
	.include "Data/Levels/Oval.asm"
	.include "Data/Levels/Abstract2.asm"
	.include "Data/Levels/XShape.asm"
	.include "Data/Levels/Rain.asm"
	.include "Data/Levels/Triangles1.asm"
	.include "Data/Levels/Circle.asm"
	.include "Data/Levels/Abstract3.asm"
	.include "Data/Levels/Love.asm"
	.include "Data/Levels/Spiral.asm"
	.include "Data/Levels/Triangles2.asm"
	.include "Data/Levels/Stripes.asm"
	.include "Data/Levels/Mines.asm"
	.include "Data/Levels/Grid2.asm"
	.include "Data/Levels/SkyScrapers.asm"
	.include "Data/Levels/Clock.asm"
	.include "Data/Levels/Clumps3.asm"
		
	
;-------------Sound Engine----------------------	
  .bank 3
    .org $E000
	
	.include "Audio/sound_engine.asm"
	.include "Audio/sound_opcodes.asm"
	.include "Audio/note_length_table.i"
	.include "Audio/note_table.i"
	.include "Audio/vol_envelopes.i"
	
;------------Sound Effects--------------            
song_headers:
    .word intro_header
    .word explosion_header
	.word coin_header
	.word warp_header
	.word invincible_header
	.word tick_header
    .word gameover_header
    
	.include "Audio/My Songs/Intro.asm"
	.include "Audio/My Songs/Explosion.asm"
	.include "Audio/My Songs/Coin.asm"
	.include "Audio/My Songs/Warp.asm"
	.include "Audio/My Songs/Invincible.asm"
	.include "Audio/My Songs/Tick.asm"
	.include "Audio/My Songs/GameOver.asm"	
	
;------------------Interrupts-----------------------------
  
  
  .org $FFFA     ;interrupts start at $FFFA

	.dw NMI      ; location of NMI Interrupt
	.dw Reset    ; code to run at reset
	.dw 0		 ;IQR interrupt (not used)
	

;--------------------Graphics-----------------------------
	
  .bank 4        ; change to bank 4 - Graphics information
  .org $0000     ;Graphics start at $0000

	.incbin "Graphics.chr"  ; Include Binary file that will contain all program graphics
