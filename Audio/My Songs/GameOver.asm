gameover_header:
    .byte $01           ;1 stream
    
    .byte MUSIC_SQ1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte SQUARE_2     ;which channel
    .byte $30           ;initial duty (01)
    .byte $00 ;volume envelope
    .word gameover_square ;pointer to stream
    .byte $5F           ;tempo..moderate tempo


gameover_square:
    ;.byte set_loop1_counter, $08    ;repeat 8 times
.loop:
    .byte quarter, Ds3, F3, Ds3, Cs3, Ds3, Cs3, whole, B2      ;play two D notes at different octaves
    .byte endsound