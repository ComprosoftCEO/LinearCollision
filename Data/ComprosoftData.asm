;-------------------Information for Comprosoft Intro---------------------
ComprosoftFirstText1:		;This is the initial C:\>
	.db $D0,$D6,$E7,$E8,$ED,$EE,$F3,$F4
ComprosoftFirstText2:
	.db $D4,$00,$E9,$EA,$EF,$F0,$F5,$F6
ComprosoftFirstText3:
	.db $D2,$D6,$EB,$EC,$F1,$F2,$F7,$F8
	
ComprosoftLogo1:		;The entire word Comprosoft
  .db $D0,$D6,$D0,$D1,$DB,$DC,$D0,$D1,$D0,$D1,$D0,$D1,$D0,$D6,$D0,$D1,$D0,$D6,$E1,$E2
ComprosoftLogo2:
  .db $D4,$00,$D4,$D4,$DD,$DE,$D9,$D3,$D9,$DA,$D4,$D4,$D2,$D1,$D4,$D4,$D9,$D7,$E3,$E4
ComprosoftLogo3:
  .db $D2,$D6,$D2,$D3,$DF,$E0,$D8,$00,$D8,$D8,$D2,$D3,$D5,$D3,$D2,$D3,$D8,$00,$E5,$E6
  
ComprosoftColon1:		;The :\> that is added on
  .db $E7,$E8,$ED,$EE,$F3,$F4
ComprosoftColon2:
  .db $E9,$EA,$EF,$F0,$F5,$F6
ComprosoftColon3:
  .db $EB,$EC,$F1,$F2,$F7,$F8
  
ComprosoftPresents:		;The presents text
  .db $30,$32,$25,$33,$25,$2E,$34,$33