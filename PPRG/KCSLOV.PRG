function kcslov
para m._kc,m._len,m._end
	m._kc=abs(m._kc)
	dime jed(19),des(9),sta(9),tis(9),mil(9)
	jed(1)="jedna"
	jed(2)="dv�"
	jed(3)="t�i"
	jed(4)="�ty�i"
	jed(5)="p�t"
	jed(6)="�est"
	jed(7)="sedm"
	jed(8)="osm"
	jed(9)="dev�t"
	jed(10)="deset"
	jed(11)="jeden�ct"
	jed(12)="dvan�ct"
	jed(13)="t�in�ct"
	jed(14)="�trn�ct"
	jed(15)="patn�ct"
	jed(16)="�estn�ct"
	jed(17)="sedmn�ct"
	jed(18)="osmn�ct"
	jed(19)="devaten�ct"
	des(2)="dvacet"
	des(3)="t�icet"
	des(4)="�ty�icet"
	des(5)="pades�t"
	des(6)="�edes�t"
	des(7)="sedmdes�t"
	des(8)="osmdes�t"
	des(9)="devades�t"
	sta(1)="sto"
	sta(2)="dv�st�"
	sta(3)="t�ista"
	sta(4)="�ty�ista"
	sta(5)="p�tset"
	sta(6)="�estset"
	sta(7)="sedmset"
	sta(8)="osmset"
	sta(9)="dev�tset"
	tis(1)="tis�c"
	tis(2)="dvatis�ce"
	tis(3)="t�itis�ce"
	tis(4)="�ty�itis�ce"
	tis(5)="p�ttis�c"
	tis(6)="�esttis�c"
	tis(7)="sedmtis�c"
	tis(8)="osmtis�c"
	tis(9)="dev�ttis�c"
	mil(1)="mili�n"
	mil(2)="dvamili�ny"
	mil(3)="t�imili�ny"
	mil(4)="�ty�imili�ny"
	mil(5)="p�tmili�n�"
	mil(6)="�estmili�n�"
	mil(7)="sedmmili�n�"
	mil(8)="osmmili�n�"
	mil(9)="dev�tmili�n�"

	private m._st,m._skc,m._aa,m._bb,m._st1
	m._st=""
	m._skc=ltrim(str(int(m._kc)))

*** 1-999 ***
	m._aa=val(right(m._skc,2))
	if m._aa<20.and.m._aa>0
		m._st=jed(m._aa)+m._st
	  else
	  	m._bb=10*(m._aa/10-int(m._aa/10))
		if m._bb>0
	  		m._st=jed(m._bb)+m._st
	  		endif
	  	m._bb=int(m._aa/10)
	  	if m._bb>0
			m._st=des(m._bb)+m._st
			endif
		endif
	m._aa=int(val(right(m._skc,3))/100)
	if m._aa>0
		m._st=sta(m._aa)+m._st
		endif

*** 1000-999999 ***
	m._aa=int(val(right(m._skc,5))/1000)
	m._st1=""
	if m._aa>0
		if m._aa<10
			m._st1=tis(m._aa)
		  else
		  	if m._aa<20
				m._st1=jed(m._aa)+"tis�c"
			  else
			  	m._bb=10*(m._aa/10-int(m._aa/10))
			  	if m._bb>0
				  	m._st1=jed(m._bb)
				  	endif
				m._st1=des(int(m._aa/10))+m._st1+"tis�c"
				endif
			endif
		endif
	m._aa=int(val(right(m._skc,6))/100000)
	if m._aa>0
		if len(m._st1)=0
			m._st1="tis�c"
			endif
		m._st1=sta(m._aa)+m._st1
		endif
	m._st=m._st1+m._st

*set step on
*set debug on
*** 1 000 000 - 999 999 999 ***
	m._skc=ltrim(str(int(m._kc/1000)))
	m._aa=int(val(right(m._skc,5))/1000)
	m._st1=""
	if m._aa>0
		if m._aa<10
			m._st1=mil(m._aa)
		  else
		  	if m._aa<20
				m._st1=jed(m._aa)+"mili�n�"
			  else
			  	m._bb=10*(m._aa/10-int(m._aa/10))
			  	if m._bb>0
				  	m._st1=jed(m._bb)
				  	endif
				m._st1=des(int(m._aa/10))+m._st1+"mili�n�"
				endif
			endif
		endif
	m._aa=int(val(right(m._skc,6))/100000)
	if m._aa>0
		if len(m._st1)=0
			m._st1="mili�n�"
			endif
		m._st1=sta(m._aa)+m._st1
		endif
	m._st=m._st1+m._st

	m._st=upper(left(m._st,1))+substr(m._st,2)+m._end+" ---"
return(left(m._st+space(m._len),m._len))
