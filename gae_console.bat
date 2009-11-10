@echo off

if "%COMPUTERNAME%" == "MACBETH" goto MACBETH
if "%COMPUTERNAME%" == "CAESAR2" goto CAESAR2
goto ELSE

:MACBETH
set PATH=%PATH%;C:\Python25
set GAE_SDK_HOME=C:\Program Files (x86)\Google\google_appengine
goto END

:CAESAR2
set PATH=%PATH%;C:\Python25
set GAE_SDK_HOME=C:\Program Files (x86)\Google\google_appengine
goto END

:ELSE
echo Unknown Host
goto END

:END

cmd
