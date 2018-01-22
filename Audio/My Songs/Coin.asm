coin_header:
    .byte $01           ;1 stream
    
    .byte SFX_1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte SQUARE_1      ;which channel
    .byte $30           ;initial duty (01)
    .byte $00 ;volume envelope
    .word coin_square ;pointer to stream
    .byte $FF           ;tempo..very fast tempo


coin_square:
    .byte eighth, C5,E5 
	.byte endsound