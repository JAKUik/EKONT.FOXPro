*******************
****  Bud��ek  ****
*******************
*PROCEDURE budik
PUSH KEY CLEAR

**	Nastaven� bud��ku
PROCEDURE budik
PARA bflg	&&	.T.  Nastaven�		.F. Vyhodnoceni
	DIME b_typ(5)
	b_typ(1)="Jednou  "
	b_typ(2)="Prc.den "
	b_typ(3)="Denn�   "
	b_typ(4)="T�dn�   "
	b_typ(5)="M�s��n� "

	PRIV _sele, user
	_sele=select()
	user=getenv('USERNAME')
	USE budik ORDER cas
	SET FILT TO budik.user=m.user OR budik.user='ALL'

	DO list_c WITH 6,-1,12,0,;
		[str(rok,2)+' � '+left(mline(budik.txt,1),20)],;
		" Seznam bud��ku pro "+m.user+" ",;
		"//�et � Text",;
		iif(m.flg,"\ F1-Help    ENTER-V�b�r ��tu   F7-T��dit podle ...",;
				  "\ F1-Help    ENTER-V�b�r analytiky   F7-T��dit podle ..."),;
		iif(m.flg,'','INS:	DO osn_pri WITH .T.		## INS-P�id�n� ��tu'),;
		'F4#:	DO osn_pri WITH .F.		## F4-Oprava ��tu',;
		'CR#:	m.toexit=.T.			## ENTER-V�b�r '+iif(m.flg,'��tu','analytiky')




RETURN

