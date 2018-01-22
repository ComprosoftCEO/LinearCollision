MovementData: 		;4 Different pre-programmed paths for each layout
  .dw L1P1
  .dw L1P2
  .dw L1P3			;Default
  .dw L1P4
  
  .dw L2P1
  .dw L2P2
  .dw L2P3			;Grid1
  .dw L2P4

  .dw L3P1
  .dw L3P2
  .dw L3P3			;Clumps 1
  .dw L3P4

  .dw L4P1
  .dw L4P2
  .dw L4P3			;Triangles 2
  .dw L4P4
  
	.include "Data/Autoplay/Layout1.asm"
	.include "Data/Autoplay/Layout2.asm"
	.include "Data/Autoplay/Layout3.asm"
	.include "Data/Autoplay/Layout4.asm"
	
AutoPlayLayouts:
 .db 0,1,8,7