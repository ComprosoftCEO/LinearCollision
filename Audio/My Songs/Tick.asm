tick_header:
    .byte $01           ;1 stream
    
    .byte SFX_2         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte NOISE    		 ;which channel
    .byte $30           ;initial duty (01)
    .byte $01			 ;volume envelope
    .word tick_square ;pointer to stream
    .byte $FF           ;tempo..very fast tempo


tick_square:
	.byte set_loop1_counter, $01
.loop
    .byte quarter, $16
	.byte loop1
	.word .loop
	.byte endsound