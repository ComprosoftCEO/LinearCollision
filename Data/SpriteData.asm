OtherSprites:
  .db 0,1,0,0, 0,2,1,0		;Player
  .db 7,38,03,64, 7,38,03,72		;Level Number
  .db 7,38,03,208, 7,38,03,224, 7,38,03,232		;Time counter
  .db 7,00,03,128		;Invincible sprite
  
GetReady:
CenterPos = 108
  .db 127,$32,02,CenterPos
  .db 127,$25,02,CenterPos+8
  .db 127,$21,02,CenterPos+16
  .db 127,$24,02,CenterPos+24
  .db 127,$39,02,CenterPos+32
  
EnergyTiles:
  .db 3,3,4,4
  
AttribData:
  .db 1,2,1,2