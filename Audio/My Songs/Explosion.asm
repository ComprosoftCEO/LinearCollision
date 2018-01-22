explosion_header:
    .byte $01           ;1 stream
    
    .byte SFX_1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte MUSIC_NOI      ;which channel
    .byte $70           ;initial duty (01)
    .byte $01 ;volume envelope
    .word explosion_drum ;pointer to stream
    .byte $FF           ;tempo..very fast tempo


explosion_drum:
    .byte set_loop1_counter, $08    ;repeat 8 times
.loop:
    .byte thirtysecond, $1D     ;play two D notes at different octaves
	.byte loop1
	.word .loop
	.byte set_loop1_counter, $04    ;repeat 8 times
.loop2:
    .byte thirtysecond, $1E     ;play two D notes at different octaves
	.byte loop1
	.word .loop2
	.byte set_loop1_counter, $0D    ;repeat 8 times
.loop3
    .byte thirtysecond, $1F     ;play two D notes at different octaves
	.byte loop1
	.word .loop3
    .byte endsound