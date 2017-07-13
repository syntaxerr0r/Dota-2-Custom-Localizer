:echo off
:echo off
chcp 65001
cls
@setlocal enableextensions
@cd /d "%~dp0"
call path.bat
call link.bat
call notify.bat

Echo %launcher_updating%
call down.bat %link_installer_lastest_version% -saveTo "%temp%\lastest_ver.dat"
set /p current_ver=<"current_ver.dat"
set /p lastest_ver=<"%temp%\lastest_ver.dat"
if "%current_ver%"=="%lastest_ver%" goto check_localizer
echo %launcher_updating_yes%
START "" %link_forum_to_update%
pause>nul
exit

:check_localizer

call down.bat %link_localizer_lastest_version% -saveTo "%temp%\version.txt"
set /p old=<"%dota%\version.txt"
set /p new=<"%temp%\version.txt"
if "%old%"=="%new%" goto no_update
echo %launcher_localizer_need_update%
call down.bat %link_localizer% -saveTo "text.zip"
7z.exe x "text.zip" -y
XCOPY "dota 2 beta\*.txt" "%dota%" /e/y
:no_update
START "" "%steam%\steam.exe" -applaunch 570 -language %lang%
exit
