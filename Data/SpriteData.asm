;Locations along the horizontal axis (For top/bottom)
HorPos:
  .db 8,56,72,88,104,144,160,176,192,240
  
;Locations along the vertical axis (for left/right)
VertPos:
  .db 31,79,87,111,143,167,175,223
  
OtherSprites:
  .db 127,1,0,124, 127,2,1,124		;Player
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