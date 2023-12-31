DEFINE POPUP dokl FROM 10,40 RELATIVE SHADOW TITLE " Doklady " COLOR SCHEME 4
DEFINE BAR 10 OF dokl PROMPT " Po�et z�znam� po m�s�\<c�ch " ;
	MESS "Po�et za��tovan�ch polo�ek v jednotliv�ch m�s�c�ch."
DEFINE BAR 20 OF dokl PROMPT " Tisk \<v�dajov�ch doklad� " ;
	MESS "V�dajov� pokladn� doklady."
DEFINE BAR 22 OF dokl PROMPT " Tisk \<p��jmov�ch doklad� " ;
	MESS "P��jmov� pokladn� doklady."
DEFINE BAR 24 OF dokl PROMPT " Tisk v\<nit�n�ch ��etn�ch doklad� " ;
	MESS "Vnit�n� ��etn� doklady."
DEFINE BAR 26 OF dokl PROMPT " Tisk ko�ilek z knihy \<faktur " ;
	MESS "Ko�ilky k faktur�m ze seznamu faktur."
*DEFINE BAR 28 OF dokl PROMPT " Tisk ko�ilek z \<den�ku " ;
*	MESS "Ko�ilky k faktur�m ze zadan�ho typu dokladu."
DEFINE BAR 29 OF dokl PROMPT " Tisk ko�ilek z \<den�ku " ;
	MESS "Ko�ilky k faktur�m z den�ku - v�b�r jednotliv�ch faktur."
ON SELE POPU dokl DO dokl

DIME snz(3)
snz(1)="   Vnit�n� ��etn�"
snz(2)="V�dajov� pokladn�"
snz(3)="P��jmov� pokladn�"

m.df=" "

=open_dbf(m.gl_data, "USERS", "op_user", "user", .F., .F.)
jmuc=lookup(users.full_name,m.gl_usernam,users.user_name,'user')
USE

SELE denik
_bar=1

ACTIVATE POPUP dokl BAR _bar

RELE POPUP dokl
RETURN

**  M E N U
PROCEDURE dokl
	DO CASE
		CASE bar()=10
			DO dokl_poe
		CASE bar()=20
			cnz=2
			DO dokl_dok		&&	V�dajov�
		CASE bar()=22
			cnz=3
			DO dokl_dok		&&	P��jmov�
		CASE bar()=24
			cnz=1
			DO dokl_dok		&&	Vnit�n�
		CASE bar()=26
			DO dokl_kof		&&	Ko�ilky k faktur�m
*		CASE bar()=28
*			DO dokl_kod		&&	Ko�ilky k faktur�m
		CASE bar()=29
			DO dokl_k1d		&&	Ko�ilky k faktur�m - zatr�en�m
		ENDCASE
RETURN

**	V�pis po�tu polo�ek i s kalkulac� ceny
PROCEDURE dokl_poe

* Nastaviteln� v Ekont.eni
*	DSazbaZD
*	DSazbaZB
*	DSazbaVPU
*	DSazbaP
*	DSazbaPP

	SET ESCA ON
	ON ESCA DO stoptisk
	PRIV uc, vpu, suc, svpu, kc, kcb, skc, skcb, mes, rok, cel, scel, uctar
	STORE 0 TO uc, vpu, suc, svpu, kc, kcb, skc, skcb, scel
	uctar=""
	DO uctar.spr
	SELE denik
	IF empty(m.uctar)
		SET FILTER TO !del
	  ELSE
		SET FILTER TO !del AND alltrim(m.uctar) = alltrim(auser)
	ENDIF
	SET ORDER TO dat
	DO opfile
	SET CONS OFF
	?space(m.margin)+"Firma: "+alltrim(m.ggjme)+str(m.ggrok,5)
	IF !empty(m.uctar)
		?
		?space(m.margin)+"�ta�: "+m.uctar
	ENDIF
	?
	?space(m.margin)+"��������������������������������������������������Ŀ"
	?space(m.margin)+"�    �   �etnictv�   �      V P �     �           �"
	?space(m.margin)+"� M�s�  Pol. |   Cena �  Pol. |   Cena � Celkem K� �"
	?space(m.margin)+"��������������������������������������������������Ĵ"
	SCAN ALL
		mes=month(dat)
		STORE 0 TO uc, vpu
		DO WHILE m.mes=month(dat)
			IF md<800
				uc=m.uc+1
			  ELSE
				vpu=m.vpu+1
				ENDIF
			SKIP 1
			ENDDO
		kc=int((m.uc-51)/m.DSazbaPP+1)
		kc=iif(m.kc<0,0,m.kc*m.DSazbaP)
		kcb=int((m.vpu-51)/m.DSazbaPP+1)
		kcb=iif(m.kcb<0,0,m.kcb*m.DSazbaP)
		skc=m.skc+m.kc
		skcb=m.skcb+m.kcb
		suc=m.suc+m.uc
		svpu=m.svpu+m.vpu
		cel=iif(m.ggpldph='A',m.DSazbaZD+m.kc,m.DSazbaZB+m.kc)+iif(m.vpu=0,0,m.DSazbaVPU+m.kcb)
		scel=m.scel+m.cel
		?space(m.margin)+"� "+str(mes,2)+" � "+str(m.uc,5)+" | "+str(m.kc,6)+" � "+str(m.vpu,5)+" | "+str(m.kcb,6)+" � "+str(cel,9)+" �"
		IF !eof()
			SKIP -1
			ENDIF
		ENDSCAN
	?space(m.margin)+"��������������������������������������������������Ĵ"
	?space(m.margin)+"�Suma� "+str(m.suc,5)+" | "+str(m.skc,6)+" � "+str(m.svpu,5)+" | "+str(m.skcb,6)+" � "+str(scel,9)+" �"
	?space(m.margin)+"����������������������������������������������������"+chr(12)
	SET ALTE TO
	SET CONS ON
	SET ESCA OFF
	ON ESCA
	WAIT CLEAR
	DO tisk WITH m.margin
RETURN

**	�etn� doklady
PROCEDURE dokl_dok
	SELE denik
	SET ORDER TO typ
	ff="Ano"
	ok=1
	mena="K� "

	i=strn(m.cnz)
	kli=ggkli&i

	DO doklad.spr

	ggkli&i=m.kli

	IF m.ok=0
		RETURN
		ENDIF
	SET ESCA ON
	ON ESCA DO stoptisk
	DO opfile
	SET CONS OFF
	i=1
	cc=0
	ll=m.len_pg
	SET FILTER TO !del AND typ=ttyp AND dat>=tdto AND dat<=tdtd AND ;
		betw(denik.cis, m.cis_od, m.cis_do)
	SET ORDER TO typ
	GO TOP
	WAIT "Zpracov�n� dne: "+dtoc(dat) NOWAIT WINDOWS
*	DO CASE
*		CASE inlist(month(dat),1,3,5,7,8,10,12)
*			den=31
*		CASE inlist(month(dat),4,6,9,11)
*			den=30
*		OTHER
*			den=28
*		ENDCASE
*	m.dtuc=ctod(str(den,2)+'.'+str(month(dat),2)+'.'+str(year(dat),4))

	m.dtuc=gomonth(ctod('01.'+str(month(dat),2)+'.'+str(year(dat),4)),1)-1
	_ci=cis
	IF cnz=1
		DO vni_hlav
	  ELSE
	  	DO vp_hlav
	  	ENDIF
	PRIV ovud
	ovud=adat
	DO WHILE !eof()
		IF _ci<>cis
			IF cnz=1
				DO vni_kon
			  ELSE
				DO vp_kon
				ENDIF	
			_ci=cis
			ovud=adat
			_rc=recno()
			COUNT FOR _ci=cis TO llk
			=gorec(m._rc)
			IF ll-llk-iif(cnz=1,10,15)<1
				?chr(12)
				ll=m.len_pg
				ENDIF
			IF cnz=1
				DO vni_hlav
			  ELSE
			  	DO vp_hlav
			  	ENDIF
			ENDIF
		IF ll<=1
			?chr(12)+space(m.margin*.7)+space(66)+"Pokra�ov�n� ..."
			?space(m.margin*.7)+"+----------+----------+------------------------------------------+--------------+"
			?space(m.margin*.7)+"| M� d�ti  | Dal      | Text                                     | ��stka       |"
			?space(m.margin*.7)+"+----------+----------+------------------------------------------+--------------+"
			ll=m.len_pg-4
			ENDIF
		?space(m.margin*.7-1),"|",md,mda,"|",dal,daa,"|",txt,"|",str(cas,12,2),"|"
		IF m.cnz!=1 AND m.mena!="K� " 
			IF md>700 AND dal>700
				cc=m.cc+cas
				ENDIF
		  ELSE
			cc=m.cc+cas
			ENDIF

		IF dtos(m.ovud)<dtos(adat)
			ovud=adat
			ENDIF

		ll=m.ll-1
		WAIT "Zpracov�n� dne: "+dtoc(dat) NOWAIT WINDOWS

*		DO CASE
*			CASE inlist(month(dat),1,3,5,7,8,10,12)
*				den=31
*			CASE inlist(month(dat),4,6,9,11)
*				den=30
*			OTHER
*				den=28
*			ENDCASE
*		m.dtuc=ctod(str(den,2)+'.'+str(month(dat),2)+'.'+str(year(dat),4))

		m.dtuc=gomonth(ctod('01.'+str(month(dat),2)+'.'+str(year(dat),4)),1)-1
		SKIP 1
		ENDDO

	IF cnz=1
		DO vni_kon
	  ELSE
	  	DO vp_kon
	  	ENDIF
	IF m.ff='Ne '
		?chr(12)
		ENDIF
	SET CONS ON
	SET ALTE TO
	SET FILTER TO !del
	SET ESCA OFF
	ON ESCA
	WAIT CLEAR
	DO tisk WITH m.margin*.7
RETURN

PROCEDURE vni_hlav
	?space(m.margin/1.6)+left(ltrim(snz(m.cnz))+" DOKLAD �."+str(cis,5)+space(14),40)+"Organizace: "+m.cnon+ggjme+m.cnoff
	?space(m.margin/1.6)+"Typ:"+str(typ,3)+"    ze dne "+dtoc(dat)+space(26)+m.cnon+gguli+m.cnoff
	?space(m.margin/1.6)+"N�zev: "+lookup(typ.txt,denik.typ,typ.cis,'CIS')+space(15)+m.cnon+ggpsc+space(2)+ggmes+m.cnoff
	?space(m.margin/1.6)+space(52)+m.cnon+"I�O: "+ggico+m.cnoff
	?space(m.margin/1.6)+space(52)+m.cnon+"DI�: "+ggdic+m.cnoff
	?m.elit+space(m.margin*.7)+"+----------+----------+------------------------------------------+--------------+"
	?space(m.margin*.7)+"| M� d�ti  | Dal      | Text                                     | ��stka       |"
	?space(m.margin*.7)+"+----------+----------+------------------------------------------+--------------+"
	ll=ll-8
RETURN

PROCEDURE vni_kon

*wait wind dtoc(m.dtuc)
	IF year(m.dtuc)<2002
		?space(m.margin*.7)+"+----------+----------+------------------------+-----------------+--------------+"
		?space(m.margin*.7)+"| Vystavil:           | Schv�lil:              | Za��toval: "+jmuc+"|"
		?space(m.margin*.7)+"|                     |                        | Dne:  "+dtoc(iif(empty(m.imzau),m.dtuc,m.imzau))+"                 |"
		?space(m.margin*.7)+"+---------------------+------------------------+--------------------------------+"
		?m.pica
		IF ff="Ano"
			ll=m.len_pg
			?chr(12)
		  ELSE
		  	ll=ll-5
			IF ll-3>1
			  	?repl('.',79)
			  	?
			  	ll=ll-2
				ENDIF
		  	ENDIF
	  ELSE
		?space(m.margin*.7)+"+----------+----------+---------+--------------------------------+--------------+"
		?space(m.margin*.7)+"| Osoba odpov�dn� za ��.p��pad  | Osoba odpov�dn� za za��tov�n�  | Okam�ik      |"
		?space(m.margin*.7)+"|                               | "+m.jmuc+"           | vyhotoven�   |"
		?space(m.margin*.7)+"|                               |                                | ��. dokladu  |"
		?space(m.margin*.7)+"|                               |                                | "+dtoc(m.ovud)+"     |"
		?space(m.margin*.7)+"+-------------------------------+--------------------------------+--------------+"
		?m.pica
		IF ff="Ano"
			ll=m.len_pg
			?chr(12)
		  ELSE
		  	ll=ll-7
			IF ll-3>1
			  	?repl('.',79)
			  	?
			  	ll=ll-2
				ENDIF
		  	ENDIF
		ENDIF	
RETURN

PROCEDURE vp_hlav
	?space(m.margin/1.6)+left(ltrim(snz(m.cnz))+" DOKLAD �."+str(cis,5)+space(14),40)+"Organizace: "+m.cnon+ggjme+m.cnoff
	?space(m.margin/1.6)+"Typ:"+str(typ,3)+"    ze dne "+dtoc(dat)+space(26)+m.cnon+gguli+m.cnoff
	?space(m.margin/1.6)+space(52)+m.cnon+ggpsc+space(2)+ggmes+m.cnoff
	?space(m.margin/1.6)+iif(m.cnz=2,"Vyd�no komu:","P�ijato od: ")+kli+space(15)+m.cnon+"I�O: "+ggico+cnoff
	?space(m.margin/1.6)+space(52)+cnon+"DI�: "+ggdic+m.cnoff
	?m.elit+space(m.margin*.7)+"+----------+----------+------------------------------------------+--------------+"
	?space(m.margin*.7)+"| M� d�ti  | Dal      | Text                                     | ��stka       |"
	?space(m.margin*.7)+"+----------+----------+------------------------------------------+--------------+"
	cc=0
	ll=ll-8
RETURN

PROCEDURE vp_kon
	IF year(m.tdtd)<2002
		?space(m.margin*.7)+"+----------+----------+------------------------------------------+--------------+"
		?space(m.margin*.7)+"| Celkem:"+str(cc,11,2)+' '+m.mena+space(56)+"|"
		?space(m.margin*.7)+"| slovy : "+kcslov(cc,70,"/"+right(str(cc,11,2),2)+' '+m.mena)+"|"
		?space(m.margin*.7)+"+-----------------------+----------------------+--------------------------------+"
		?space(m.margin*.7)+"| "+iif(m.cnz=2,"P�ijal:    ","P�ijato od:")+"           | Schv�lil:            | Za��toval: "+jmuc+"|"
		?space(m.margin*.7)+"|                       |                      | Dne:  "+dtoc(iif(empty(m.imzau),m.dtuc,m.imzau))+"                 |"
		?space(m.margin*.7)+"+-----------------------+----------------------+--------------------------------+"
		?m.pica
		IF ff="Ano"
			ll=m.len_pg
			?chr(12)
		  ELSE
		  	ll=ll-8
			IF ll-3>1
			  	?repl('.',79)
			  	?
			  	ll=ll-2
				ENDIF
		  	ENDIF
	  ELSE
		?space(m.margin*.7)+"+----------+----------+------------------------------------------+--------------+"
		?space(m.margin*.7)+"| Celkem:"+str(cc,11,2)+' '+m.mena+space(56)+"|"
		?space(m.margin*.7)+"| slovy : "+kcslov(cc,70,"/"+right(str(cc,11,2),2)+' '+m.mena)+"|"
		?space(m.margin*.7)+"+--------------------+---------------------+---------------------+--------------+"
		?space(m.margin*.7)+"| "+iif(m.cnz=2,"P�ijal:    ","P�ijato od:")+"        | Osoba odpov�dn�     | Osoba odpov�dn�     | Okam�ik      |"
		?space(m.margin*.7)+"|                    | za ��.p��pad        | za za��tov�n�       | vyhotoven�   |"
		?space(m.margin*.7)+"|                    |                     | "+m.jmuc+"| ��. dokladu  |"
		?space(m.margin*.7)+"|                    |                     |                     | "+dtoc(m.ovud)+"     |"
		?space(m.margin*.7)+"|                    |                     |                     |              |"
		?space(m.margin*.7)+"+--------------------+---------------------+---------------------+--------------+"
		?m.pica
		IF ff="Ano"
			ll=m.len_pg
			?chr(12)
		  ELSE
		  	ll=ll-11
			IF ll-3>1
			  	?repl('.',79)
			  	?
			  	ll=ll-2
				ENDIF
		  	ENDIF
		ENDIF
RETURN

**	Ko�ilky k faktur�m z faktur
PROCEDURE dokl_kof
	fakt=.T.	&&	Tisk z faktur nebo den�ku
	SELE denik
	SET ORDER TO typ
	ff="Ne "
	ok=1
	DO dokl_kos.spr
	IF m.ok=0
		RETURN
		ENDIF
	SET ESCA ON
	ON ESCA DO stoptisk
	SELE ufaktury
	SET ORDER TO typcis
	SELE denik
	SET RELA TO str(typ,3)+str(cis,5) INTO ufaktury
	i=1
	ll=m.len_pg
*	SET FILTER TO !del AND typ=ttyp AND cis>=cod AND cis<=cdo AND ;
*		ufaktury.kos='�'
	SET ORDER TO typ
	DO opfile
	SET CONS OFF
	WAIT "Zpracov�n� dne: "+dtoc(dat) NOWAIT WINDOWS
	DO CASE
		CASE inlist(month(dat),1,3,5,7,8,10,12)
			den=31
		CASE inlist(month(dat),4,6,9,11)
			den=30
		OTHER
			den=28
		ENDCASE
	dtuc=ctod(str(den,2)+'.'+str(month(dat),2)+'.'+str(year(dat),4))
	SEEK str(ttyp,3)+str(cod,5)
	_tis=.F.
	IF found() AND ufaktury.kos='�'
		DO kos_hlav
		_tis=.T.
		ENDIF
	_ci=cis
	PRIV ovud
	ovud=adat
	DO WHILE !eof() AND typ=ttyp AND cis<=cdo AND !del
		IF ufaktury.kos<>'�'
			SKIP 1
			LOOP
			ENDIF
		IF _ci<>cis
			IF _tis
				DO kos_kon
				ENDIF
			_ci=cis
			_rc=recno()
			_llk=0
			DO WHILE _ci=cis
				_llk=_llk+1
				SKIP 1
				ENDDO
			=gorec(_rc)
			IF _tis
				IF ll-_llk-12<1
					?chr(12)
					ll=m.len_pg
				  ELSE
				  	?repl('.',4)+space(70)+repl('.',4)
				  	?
				  	ll=ll-2
					ENDIF
				ENDIF
			_tis=.T.
			DO kos_hlav
			ENDIF
		?space(m.margin)+"|",dtoc(dat),"|",md,mda,"|",dal,daa,"|",txt,"|",str(cas,12,2),"|"
		ll=ll-1
		WAIT "Zpracov�n� dne: "+dtoc(dat) NOWAIT WINDOWS
		DO CASE
			CASE inlist(month(dat),1,3,5,7,8,10,12)
				den=31
			CASE inlist(month(dat),4,6,9,11)
				den=30
			OTHER
				den=28
			ENDCASE
		m.dtuc=ctod(str(den,2)+'.'+str(month(dat),2)+'.'+str(year(dat),4))
		SKIP 1
		ENDDO
	IF _tis
		DO kos_kon
		ENDIF
	IF ff='Ne '
		?chr(12)
		ENDIF
	SET CONS ON
	SET ALTE TO
	SET FILTER TO !del
	SET RELA TO
	SET ESCA OFF
	ON ESCA
	WAIT CLEAR
	DO tisk WITH m.margin
RETURN

**	Ko�ilky k faktur�m z den�ku
PROCEDURE dokl_kod
	fakt=.F.	&&	Tisk z faktur nebo den�ku
	SELE denik
	SET ORDER TO typ
	ff="Ne "
	ok=1
	DO dokl_kos.spr
	IF m.ok=0
		RETURN
		ENDIF
	SET ESCA ON
	ON ESCA DO stoptisk
	SELE denik
	i=1
	ll=m.len_pg
	SET ORDER TO typ
	DO opfile
	SET CONS OFF
	WAIT "Zpracov�n� dne: "+dtoc(dat) NOWAIT WINDOWS
	DO CASE
		CASE inlist(month(dat),1,3,5,7,8,10,12)
			den=31
		CASE inlist(month(dat),4,6,9,11)
			den=30
		OTHER
			den=28
		ENDCASE
	dtuc=ctod(str(den,2)+'.'+str(month(dat),2)+'.'+str(year(dat),4))
	SEEK str(ttyp,3)+str(cod,5)
	_tis=.F.
	IF found()
		DO kos_hlav
		_tis=.T.
		ENDIF
	_ci=cis
	PRIV ovud
	ovud=adat
	DO WHILE !eof() AND typ=ttyp AND cis<=cdo AND !del
		IF _ci<>cis
			IF _tis
				DO kos_kon
				ENDIF
			_ci=cis
			_rc=recno()
			_llk=0
			DO WHILE _ci=cis
				_llk=_llk+1
				SKIP 1
				ENDDO
			=gorec(_rc)
			IF _tis
				IF ll-_llk-12<1
					?chr(12)
					ll=m.len_pg
				  ELSE
				  	?repl('.',4)+space(70)+repl('.',4)
				  	?
				  	ll=ll-2
					ENDIF
				ENDIF
			_tis=.T.
			DO kos_hlav
			ENDIF
		?space(m.margin)+"|",dtoc(dat),"|",md,mda,"|",dal,daa,"|",txt,"|",str(cas,12,2),"|"
		ll=ll-1
		WAIT "Zpracov�n� dne: "+dtoc(dat) NOWAIT WINDOWS
		DO CASE
			CASE inlist(month(dat),1,3,5,7,8,10,12)
				den=31
			CASE inlist(month(dat),4,6,9,11)
				den=30
			OTHER
				den=28
			ENDCASE

		IF dtos(m.ovud)<dtos(adat)
			ovud=adat
			ENDIF

		m.dtuc=ctod(str(den,2)+'.'+str(month(dat),2)+'.'+str(year(dat),4))
		SKIP 1
		ENDDO
	IF _tis
		DO kos_kon
		ENDIF
	IF ff='Ne '
		?chr(12)
		ENDIF
	SET CONS ON
	SET ALTE TO
	SET FILTER TO !del
	SET ESCA OFF
	ON ESCA
	WAIT CLEAR
	DO tisk WITH m.margin
RETURN

**	Ko�ilky k faktur�m z den�ku - zatr�en�m
PROCEDURE dokl_k1d
	fakt=.F.	&&	Tisk z faktur nebo den�ku
	SELE denik
	SET ORDER TO typ
	ff="Ne "
	ok=1

	DO dokl_kos.spr
	IF m.ok=0
		RETURN
		ENDIF
	SET ESCA ON
	ON ESCA DO stoptisk

	SELECT typ, cis, dat, del AS flg, str(typ,3)+str(cis,5) AS gr ;
		FROM denik INTO DBF &ggf.ss GROUP BY gr ORDER BY gr ;
		HAVING m.ttyp=typ AND cis>=m.cod AND cis<=cdo ;
		PLAIN NOWA

** AND !del 

	SELE ss
	INDEX ON gr TAG gr
	SET ORDER TO gr

	REPL ALL flg WITH .T.
	GO TOP

	DO list_c WITH -1,-1,10,0,;
		[iif(ss.flg,'#',' ')+str(ss.typ,4)+' � '+str(ss.cis,5)+' � '+dtoc(ss.dat)],;
		" V�b�r ko�ilek pro tisk ",;
		"// Typ  � ��slo � Datum",;
		"\ F1-Help  Ctrl+ENTER-Ukon�en� v�b�ru  Mezera-Ozna�en�/odzna�en� ",;
		'CTRL+ENTER: toexit=.T.	## Ctrl+ENTER-Ukon�en� v�b�ru',;
		'SPACE:	=dokl_kxd(1)	## Mezera-Ozna�en� / Odzna�en� ',;
		'ALT+A:	=dokl_kxd(2)	## ALT+A-Ozna�en� v�ech z�znam�',;
		'ALT+U:	=dokl_kxd(3)	## ALT+U-Odzna�en� v�ech z�znam�'

	SELE denik
	i=1
	ll=m.len_pg
	SET ORDER TO typ
	DO opfile
	SET CONS OFF
	WAIT "Zpracov�n� dne: "+dtoc(dat) NOWAIT WINDOWS
	DO CASE
		CASE inlist(month(dat),1,3,5,7,8,10,12)
			den=31
		CASE inlist(month(dat),4,6,9,11)
			den=30
		OTHER
			den=28
		ENDCASE
	dtuc=ctod(str(den,2)+'.'+str(month(dat),2)+'.'+str(year(dat),4))

	SEEK str(ttyp,3)+str(cod,5)

	_tis=.F.
	_beg=.T.

	PRIV ovud
	ovud=adat
	SCAN ALL FOR seek(str(denik.typ,3)+str(denik.cis,5),"ss") ;
			AND ss.flg AND !del

		IF m._beg
			DO kos_hlav
			_tis=.T.
			_beg=.F.
			_ci=cis
			ENDIF

		IF _ci<>cis
			IF _tis
				DO kos_kon
				ENDIF
			_ci=cis
			_rc=recno()
			_llk=0
			DO WHILE _ci=cis
				_llk=_llk+1
				SKIP 1
				ENDDO
			=gorec(_rc)
			IF _tis
				IF ll-_llk-12<1
					?chr(12)
					ll=m.len_pg
				  ELSE
				  	?repl('.',4)+space(70)+repl('.',4)
				  	?
				  	ll=ll-2
					ENDIF
				ENDIF
			_tis=.T.
			DO kos_hlav
			ENDIF
		?space(m.margin)+"|",dtoc(dat),"|",md,mda,"|",dal,daa,"|",txt,"|",str(cas,12,2),"|"
		ll=ll-1
		WAIT "Zpracov�n� dne: "+dtoc(dat) NOWAIT WINDOWS
		DO CASE
			CASE inlist(month(dat),1,3,5,7,8,10,12)
				den=31
			CASE inlist(month(dat),4,6,9,11)
				den=30
			OTHER
				den=28
			ENDCASE

		IF dtos(m.ovud)<dtos(adat)
			ovud=adat
			ENDIF

		m.dtuc=ctod(str(den,2)+'.'+str(month(dat),2)+'.'+str(year(dat),4))
		ENDSCAN

	IF _tis
		DO kos_kon
		ENDIF
	IF ff='Ne '
		?chr(12)
		ENDIF
	SET CONS ON
	SET ALTE TO
	SET FILTER TO !del
	SET ESCA OFF
	ON ESCA

	SELE ss
	USE
	DELE FILE &ggf.ss.dbf


	WAIT CLEAR
	DO tisk WITH m.margin
RETURN

PROCEDURE dokl_kxd
PARA p
	DO CASE
	  CASE p=1				&&	Jeden z�znam
		REPL flg WITH !flg
		SKIP 1
	  CASE p=2				&&	Ozna�en� v�ech z�znam�
		REPL ALL flg WITH .T.
		GO TOP
	  CASE p=3				&&	Odzna�en� v�ech z�znam�
		REPL ALL flg WITH .F.
		GO TOP
		ENDCASE
	refscr=.T.
RETURN

PROCEDURE kos_hlav
	?space(m.margin/1.6)+"�ETN� DOKLAD"+space(15)+"��slo:"+str(cis,6)+"  Organizace: "+m.cnon+ggjme+m.cnoff
	?space(m.margin/1.6)+"Typ:"+str(typ,4)+"   "+lookup(typ.txt,m.ttyp,typ.cis,'cis')+space(13)+m.cnon+gguli+m.cnoff
	?space(m.margin/1.6)+"Datum uskute�n�n� ��etn�ho p��padu: "+dtoc(dat)+space(10)+m.cnon+ggpsc+space(2)+ggmes+m.cnoff
	?space(m.margin/1.6)+space(54)+m.cnon+"I�O: "+ggico+m.cnoff
	?space(m.margin/1.6)+"�ETN� P�EDPIS:"+space(9)+iif(m.fakt,"Var. symbol: "+ufaktury.var,space(25))+space(5)+m.cnon+"DI�: "+ggdic+m.cnoff
	?m.cnon+space(m.margin)+"+----------+----------+----------+------------------------------------------+--------------+"
	?space(m.margin)+"|  Datum   | M� d�ti  | Dal      | Text                                     | ��stka       |"
	?space(m.margin)+"+----------+----------+----------+------------------------------------------+--------------+"
	ll=ll-8
RETURN

PROCEDURE kos_kon
	IF year(m.dtuc)<2002
		?space(m.margin)+"+----------+----------+------------------------+----------------------------+--------------+"
		?space(m.margin)+"| Schv�lil:                                    | Za��toval: "+jmuc+"           |"
		?space(m.margin)+"|                                              | Dne:  "+dtoc(iif(empty(m.imzau),m.dtuc,m.imzau))+"                            |"
		?space(m.margin)+"+----------------------------------------------+-------------------------------------------+"+m.cnoff
		IF m.ff="Ano"
			ll=m.len_pg
			?chr(12)
		  ELSE
		  	ll=ll-4
		  	ENDIF
	  ELSE
		?space(m.margin)+"+----------+----------+----------+--------------------------------+---------+--------------+"
		?space(m.margin)+"| Osoba odpov�dn� za ��.p��pad   | Osoba odpov�dn� za za��tov�n�  | Okam�ik vyhotoven�     |"
		?space(m.margin)+"|                                | "+m.jmuc+          "           | ��. dokladu: "+dtoc(m.ovud)+"  |"
*		?space(m.margin)+"|                                |                                | "+space(23)+"|"
		?space(m.margin)+"+--------------------------------+--------------------------------+------------------------+"+m.cnoff
		IF ff="Ano"
			ll=m.len_pg
			?chr(12)
		  ELSE
		  	ll=ll-4
		  	ENDIF
		ENDIF	


RETURN

