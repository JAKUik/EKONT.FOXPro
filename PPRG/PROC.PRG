*******************************************
**  Vyjad�uje procentu�ln� stav procesu  **
*******************************************
*procedure proc
para p100,pp
	priv m.ll,m.scons
	m.scons=sys(100)
	m.ll=30
	wait nowa wind left(repl('�',(pp/(p100/100))/(100/m.ll))+space(m.ll),m.ll)
	set cons &scons
return .T.

