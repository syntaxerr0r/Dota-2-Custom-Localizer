echo off
echo on
@setlocal enableextensions
chcp 65001
cls
call notify.bat



:get_path_dota
	echo %Step1_name%
	:method1
		::using registry::
			reg query "HKLM\SOFTWARE\WOW6432Node\Valve\Steam" /v InstallPath | findstr InstallPath>"%temp%\steam.txt"
			if %errorlevel%==0 goto getpath
			reg query "HKLM\SOFTWARE\Valve\Steam" /v InstallPath | findstr InstallPath>"%temp%\steam.txt"
			if %errorlevel%==0 goto getpath
			goto method3
		:getpath
			set /p steam=<"%temp%\steam.txt"
			del "%temp%\steam.txt">nul
			set steam=%steam:    InstallPath    REG_SZ    =%
			if exist "%steam%\steamapps\common\dota 2 beta\game\bin\win32\dota2.exe" goto setdota
			goto method2
		:SETDOTA
			SET dota=%steam%\steamapps\common\dota 2 beta
			goto WRITEPATH
	:method2
		::Run Dota 2 and using tasklist to get path
			IF exist "%steam%\Steam.exe" goto RUN_DOTA2
			GOTO method3
		:RUN_DOTA2
			start steam://rungameid/570
		:LOOP
			tasklist /FI "IMAGENAME eq dota2.exe" | findstr "dota2.exe">NUL
			IF %ERRORLEVEL%==0 goto CONTINUE
			CLS
			echo %step1_loop_notice%
			CHOICE /C CP /T 1 /d C>nul
			IF %errorlevel%==2 GOTO method3
			goto LOOP
		:CONTINUE
			wmic process where "name='dota2.exe'" get ExecutablePath | findstr "dota2.exe">"%temp%\dota.txt"
			taskkill /f /IM dota2.exe
			set /p dota=<"%temp%\dota.txt"
			set dota=%dota:~0,-27%
			del %temp%\dota.txt>nul
			goto WRITEPATH
	:method3
			CLS
			echo %Step1_Manual%
			IF exist "%steam%\Steam.exe" goto Enter_DOTA2
		:Enter_STEAM
			SET /p steam=%step1_manual_steam%
			IF exist "%steam%\Steam.exe" goto Enter_DOTA2
			ECHO %step1_manual_error%
			GOTO Enter_STEAM
		:Enter_DOTA2
			set /p dota=%step1_manual_dota%
			IF EXIST "%dota%\game\bin\win32\dota2.exe" goto WRITEPATH
			ECHO %step1_manual_error%
			goto Enter_DOTA2
	
	:WRITEPATH
			echo set steam=%steam%>"path.bat"
			echo set dota=%dota%>>"path.bat"
			
			

:Launcher
	::Install launcher
	Echo %step2_installing%
	echo 00000000>"%dota%\version.txt"
    shortcut.exe /f:"%userprofile%\Desktop\Dota 2 %lang%.lnk" /a:c /t:"%cd%\Launcher.bat" /i:"%cd%\icon.ico"
Echo %Finish%
pause>nul
	