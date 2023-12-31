PROCEDURE parstan
	SELE 0
	USE setekont
	GO TOP
	SCATTER MEMVAR
	DO list_c WITH -1,-1,15,0,;
		[nstation+' � '+floppy+' � '+color_type+' � '+str(set132_on,3)+ ;
			' �  '+str(set132_off,3)+' �'+imp_output+'� '+ ;
			left(lpt1,6)+' � '+left(lpt2,6)+' � '+left(lpt3,6)],;
		" Parametry programu ",;
		"// N�zev stanice  �Flp�Typ�132on�132off� LPT � LPT1   � LPT2   � LPT3",;
		"\ F1-Help   ENTER-Oprava   INS-P�id�n� stanice   F7-T��dit podle ...",;
			'CR#:		DO sete_opr WITH .F.	## ENTER-Oprava stanice ',;
			'INS:		DO sete_opr WITH .T.	## INS-P�id�n� stanice',;
			'ALT+D#:	DO sete_del				## ALT+D-Smaz�n� stanice'
	USE
RETURN

PROCEDURE parprint
	SELE 0
	USE setprint
	DO list_c WITH -1,-1,10,0,;
		[naz+' � '+str(len_pg,3)+' � '+str(margin,5)],;
		" Parametry tisk�ren ",;
		"// N�zev tisk�rny ���dk�� L.okraj",;
		"\ F1-Help   ENTER-Oprava   INS-P�id�n� tisk�rny   F7-T��dit podle ...",;
			'CR#:		DO setp_opr WITH .F.	## ENTER-Oprava tisk�rny ',;
			'INS:		DO setp_opr WITH .T.	## INS-P�id�n� tisk�rny ',;
			'ALT+D#:	DO setp_del				## ALT+D-Smaz�n� tisk�rny '
	USE
RETURN

PROCEDURE setp_opr
PARA app
	IF m.app
		INSERT INTO setprint VALUES ('EPSON',62,15,'0','15','18','15,27,77',;
			'18,27,80','27,80','27,77','27,120,49','27,120,48','14','20')
		ENDIF
	DO setprint.spr
	IF m.esc AND m.app
		DELE
		RETURN
		ENDIF
RETURN

PROCEDURE setp_del
	IF ask(-1,-1,'N',"Opravdu smazat definici tisk�rny "+naz)
		DELE
		ENDIF
RETURN

PROCEDURE sete_opr
PARA app
	IF m.app
		INSERT INTO setekont (nstation) VALUES (getenv('nstation'))
		ENDIF
	DO setekont.spr
	IF m.esc AND m.app
		DELE
		RETURN
		ENDIF
RETURN

PROCEDURE sete_del
	IF ask(-1,-1,'N',"Opravdu smazat definici stanice "+nstation)
		DELE
		ENDIF
RETURN

