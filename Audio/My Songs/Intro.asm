intro_header:
    .byte $01           ;1 stream
    
    .byte SFX_1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte SQUARE_1      ;which channel
    .byte $30           ;initial duty (01)
    .byte $00 ;volume envelope
    .word intro_triangle ;pointer to stream
    .byte $FF           ;tempo..very fast tempo


intro_triangle:
    .byte half, C3, E3, F3      ;play two D notes at different octaves
    .byte endsound