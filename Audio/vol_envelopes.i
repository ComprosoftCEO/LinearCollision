volume_envelopes:
	.word FullVolume
	.word DrumDecay
    
FullVolume:
    .byte $0F
    .byte $FF	
	
DrumDecay:
    .byte $0E, $09, $08, $06, $04, $03, $02, $01, $00  ;7 frames per drum.  Experiment to get the length and attack you want.
    .byte $FF