;Reset the program to the default state

	SEI        ; ignore IRQs
    CLD        ; disable decimal mode
    LDX #$40
    STX $4017  ; disable APU frame IRQ
    LDX #$ff
    TXS        ; Set up stack
    INX        ; now X = 0
    STX $2000  ; disable NMI
    STX $2001  ; disable rendering
    STX $4010  ; disable DMC IRQs

    ; Optional (omitted):
    ; Set up mapper and jmp to further init code here.

    ; If the user presses Reset during vblank, the PPU may reset
    ; with the vblank flag still true.  This has about a 1 in 13
    ; chance of happening on NTSC or 2 in 9 on PAL.  Clear the
    ; flag now so the @vblankwait1 loop sees an actual vblank.
    bit $2002

    ; First of two waits for vertical blank to make sure that the
    ; PPU has stabilized
.vblankwait1:  
    BIT $2002
    BPL .vblankwait1

    ; We now have about 30,000 cycles to burn before the PPU stabilizes.
    ; One thing we can do with this time is put RAM in a known state.
    ; Here we fill it with $00, which matches what (say) a C compiler
    ; expects for BSS.  Conveniently, X is still 0.
    TXA
.clrmem:
    STA $000,x
    STA $100,x
    STA $300,x
    STA $400,x
    STA $500,x
    STA $600,x
    STA $700,x  ; Remove this if you're storing reset-persistent data

    ; We skipped $200,x on purpose.  Usually, RAM page 2 is used for the
    ; display list to be copied to OAM.  OAM needs to be initialized to
    ; $EF-$FF, not 0, or you'll get a bunch of garbage sprites at (0, 0).

    INX
    BNE .clrmem

	
	;Reset the sprite tables
	LDA #$FF
.clrspr
	STA $0200, X
	INX
	BNE .clrspr
	
    ; Other things you can do between vblank waits are set up audio
    ; or set up other mapper registers.
   
.vblankwait2:
    BIT $2002
    BPL .vblankwait2
	
	
	;Set up the default PPU information
	LDA #%10000000
	STA PPU_Setting1
	LDA #%00011110
	STA PPU_Setting2
	
	JSR DisableScreen
	JSR ResetBackground
	JSR ResetAttrib
	JSR ResetSprites

	;Use DMA to copy sprites
    LDA #$00
    STA $2003  ; set the low byte (00) of the RAM address
    LDA #$02
    STA $4014  ; set the high byte (02) of the RAM address, start the transfer	