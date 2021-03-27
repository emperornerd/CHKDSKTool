@echo off
cd /D "%~dp0"
goto check_Permissions

:check_Permissions
 echo Administrative permissions required. Detecting permissions...

 net session >nul 2>&1
 if %errorLevel% == 0 (
 echo Success: Administrative permissions confirmed.
 ) else (
 echo Failure: Current permissions inadequate.
 echo Please restart with administrative permissions
 pause
 exit
 )

set DEFAULT=/F /R /X
set F=%DEFAULT%
set DEFEX= (F) Fixes errors, (R) locates and recovers bad sectors, and (X) force mounts (if required)
set LOG=C:\windows\temp\chklog.txt
echo By default, you only need to pick a drive and then schedule scan. 
echo Default flags are %DEFAULT%
echo This means %DEFEX%
pause

:MENU

cls
if not defined D echo No Drive Selected 
if defined D echo Drive %D% selected 
if not defined F echo Flags are not set. CHKDSK is READ ONLY
if defined F echo flags configured: %F%

ECHO.
ECHO ...............................................
ECHO . Welcome to CHKDSK Tool
ECHO ...............................................
ECHO.
ECHO 1 - Choose Drive to Scan
ECHO 2 - Run CHKDSK (reboot may be required for system drive)
ECHO 3 - Change Flags
ECHO 4 - Return Flags to Default (%DEFAULT%)
ECHO 5 - Clear Options (including remove default flags)
ECHO 6 - Check CHKDSK Schedule on Selected Drive
ECHO 7 - Cancel CHKDSK on Selected Drive
ECHO 8 - View CHKDSK Results/Create Text File on Desktop
ECHO 9 - EXIT
ECHO.
SET /P M=Type 1, 2, 3, or 4 then press ENTER:
IF %M%==1 GOTO DRIVE
IF %M%==2 GOTO RUN
IF %M%==3 GOTO FLAGS
IF %M%==4 GOTO DEFAULTR
IF %M%==5 GOTO CLEAR
IF %M%==6 GOTO SCHED
IF %M%==7 GOTO CAN
IF %M%==8 GOTO PS
IF %M%==9 (GOTO EOF) ELSE (GOTO WTF)


:DRIVE
cls
ECHO Please input drive letter (no punctuation)
ECHO Example: c
SET /P D=
if defined D echo Drive %D% configured. Returning to menu.
if not defined D echo Drive not configured. Returning to menu.  

pause

GOTO MENU
:RUN
cls
set OK=
if not defined D echo No Drive Selected. Return to main menu 
if not defined D pause
if not defined D goto:MENU
if defined D echo Preparing to run: CHKDSK %D%: %F%
if defined D echo Is this OK? 
SET /P OK=Y/N
if "%OK%"=="n" goto:Menu
if "%OK%"=="N" goto:Menu
if "%OK%"=="y" goto:run2
if "%OK%"=="Y" goto:run2
if not defined OK echo No response. Returning to menu.
if defined OK echo Invalid Response. Returning to menu.
pause


GOTO MENU
:FLAGS
cls
echo Default flags are %DEFAULT%. 
echo Defining flags will REPLACE the default flags.
echo Input flags WITH punctuation
echo EXAMPLE: /X /I
if not defined F echo No flags currently selected
if defined F echo Flags exist, changes will overwrite existing flags
SET /P F=Set Flags:
if defined F echo Configured Additional Flags: %F%. Returning to menu. 
if not defined F echo No Additional Flags Configured. Returning to menu. 
pause



GOTO MENU

:CLEAR
cls
Set D=
Set F=
echo Options Cleared. Returning to menu.
Pause

goto:menu

:CAN
cls
if defined D echo Canceling CHKDSK on %D%
if defined D chkntfs /x %D%:
if not defined D echo Pick a disk first. Returning to menu. 
pause
GOTO MENU

:DEFAULTR
CLS
set F=%DEFAULT%
echo Flags restored to %F%. Returning to menu.
pause
GOTO MENU

:SCHED
cls
if defined D echo If not scheduled, you will be informed of file system and if the file system is dirty. If scheduled, it will tell you.
echo RESULTS:
if defined D chkntfs %D%:
if not defined D echo Choose a drive to check first. Returning to menu. 
pause
GOTO MENU

:RUN2

echo Attempting to execute. 
CHKDSK %D%: %F%

goto menu

:PS
cls
PowerShell.exe -ExecutionPolicy Bypass -File .\powershellresults.ps1

pause
GOTO MENU

:WTF

cls
ECHO That's not a thing. WTF are you doing? 
pause
GOTO MENU

:EOF

