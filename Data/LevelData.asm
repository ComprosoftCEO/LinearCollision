;All data for the level curve

LVLPrb:			;The probability that an enemy is released
	.db 7,7,7,7,7, 3,3,3,3,3, 1,1,1,1,1, 1
	
LVLDig:
	.db $FF,$FF,$FF,$7F,$7F, $7F,$3F,$3F,$3F,$3F, $1F,$1F,$1F,$1F,$1F,$0F

LVLTS:			;Seconds time
	.db 0,0,0,30,30, 30,0,0,0,30, 30,30,0,0,0, 0
	
LVLTM:			;Minutes Time
	.db 5,4,3,2,2, 2,2,2,2,1, 1,1,1,1,1, 1
	
LVLInv:			;Invincible time in seconds
	.db 4,4,4,3,3, 3,3,3,3,2, 2,2,2,1,1, 1