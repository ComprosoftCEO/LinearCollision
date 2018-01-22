invincible_header:
    .byte $01           ;1 stream
    
    .byte SFX_1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte TRIANGLE     ;which channel
    .byte $30           ;initial duty (01)
    .byte $01			 ;volume envelope
    .word invincible_tri ;pointer to stream
    .byte $FF           ;tempo..very fast tempo


invincible_tri:
    .byte thirtysecond, $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A, $3B, $3C, $3D, $3E, $3F
	.byte endsound