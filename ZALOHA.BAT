@ECHO OFF
IF "%2" == "" GOTO EXIT
CLS
REM
REM     Parametry:      %1 - Ozna�en� disketov� mechaniky
REM                     %2 - N�zev adres��e z�lohovan� firmy
REM                     %3 - Extenze adres��e z�lohovan� firmy s te�kou
REM
ECHO Vytv���m adres��        -  %1\%2%3
MKDIR %1\%2%3
ECHO.
ECHO Ukl�d�m starou kopii pod *.BAK
DEL %1\%2%3\%2.bak >NUL
REN %1\%2%3\%2.arj %2.bak >NUL
ECHO.
ECHO Z�lohuji soubory firmy  -  %2%3
ECHO.
CD Data
ARJ a %1\%2%3\%2 %2%3\*.DBF %2%3\*.FPT %2%3\*.MEM -i1 -m3 -y -va
   REM IF EXIST %2%3\poznamky.FPT ARJ a %1\%2%3\%2 %2%3\*.DBF %2%3\*.FPT %2%3\*.MEM -i1 -m3 -y -va
   REM IF NOT EXIST %2%3\poznamky.FPT ARJ a %1\%2%3\%2 %2%3\*.DBF -i1 -m3 -y -va
        REM IF EXIST %2%3\*.TEX ARJ a %1\%2%3\%2 %2%3\*.TEX -i1 -m3 -y -va
CD ..
ECHO.
ECHO V��e uveden� soubory byly z�lohov�ny.
ECHO.
PAUSE
:EXIT
