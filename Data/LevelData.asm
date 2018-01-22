;All data for the level curve

LVLPrb:			;The probability that an enemy is released
	.db 7,7,7,7,7, 3,3,3,3,3, 3,3,3,3,3, 1,1,1,1,1, 1,1,1,1
	
LVLDig:
	.db $FF,$FF,$FF,$7F,$7F, $7F,$7F,$7F,$7F,$7F, $3F,$3F,$3F,$3F,$3F, $1F,$1F,$1F,$1F,$1F, $0F,$0F,$0F,$0F

LVLTS:			;Seconds time
	.db 0,0,30,30,0, 0,30,30,0,0, 30,30,0,0,0, 0,30,30,30,15, 15,15,0,0
	
LVLTM:			;Minutes Time
	.db 5,5,4,4,4, 4,3,3,3,3, 2,2,2,2,2, 2,1,1,1,1, 1,1,1,1
	
LVLInv:			;Invincible time in seconds
	.db 4,4,4,4,4, 3,3,3,3,3, 3,3,3,3,2, 2,2,2,2,2, 1,1,1,1
	
LVLLayout:
	.dw Default
	.dw Grid1
	.dw Grid2
	.dw Abstract1
	.dw Abstract2
	.dw Abstract3
	.dw Triangles1
	.dw Triangles2
	.dw Clumps1
	.dw Clumps2
	.dw Clumps3
	.dw Stripes
	.dw Spiral
	.dw Oval
	.dw Circle
	.dw Diamond
	.dw XShape
	.dw Arena
	.dw SkyScrapers
	.dw Mines
	.dw Highway
	.dw Circuits
	.dw Clock
	.dw Love
	.dw Rain