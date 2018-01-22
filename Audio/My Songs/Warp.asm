warp_header:
    .byte $01           ;1 stream
    
    .byte SFX_1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte SQUARE_1      ;which channel
    .byte $30           ;initial duty (01)
    .byte $01 ;volume envelope
    .word warp_square ;pointer to stream
    .byte $FF           ;tempo..very fast tempo


warp_square:
    .byte thirtysecond, A7,G7,F7,E7,D7,C7,B6,A6,G6,F6,E6,D6,C6,B5,A5,G5,F5,E5,D5,C5,B4,A4,G4,F4,E4,D4,C4
	.byte endsound