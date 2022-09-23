CLS=new ActiveXObject("Shell.Application").ShellExecute("\""+WScript.ScriptFullName+"\"","","","runas",1);/*&title Folder EXE Firewall Blocker Script&echo.&echo   Requesting Admin Privileges....&echo   Press "Yes" to Run as Admin&NET FILE>NUL 2>&1||(CSCRIPT //B //E:JSCRIPT %0&EXIT /B)

@ echo off
@ setlocal enableextensions

REM   						::::::::::::::::::::::::::::::::::::::::::
REM    						      Created by Tech Morgan (YouTube)
REM   						::::::::::::::::::::::::::::::::::::::::::

mode con: cols=95 lines=40

for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A

:Dirc0
echo.
echo                           ----- Folder EXE Firewall Blocker Script -----
echo.
:Start
echo.
echo  [1] Run in this directory
echo.
echo  [2] Enter directory path
echo.
echo  [3] Exit
echo.
set /p opt=%BS% Choose option: 
if %opt%==1 cd /d "%~dp0" & goto Dirc3
if %opt%==2 goto Dirc
if %opt%==3 exit /b
cls
goto Dirc0

:Dirc
echo.
set /p dirc=%BS% Enter directory path: 
goto Dirc2
:Dirc1
set /p dirc=%BS% Enter existing directory path: 
:Dirc2
if not exist "%dirc%" goto Dirc1
cd /d "%dirc%"

:Dirc3
echo.
set /p sub=%BS% Include Sub-Folders (y/n)? : 
if not defined sub goto Sub1
goto Subop

:Sub1
set /p sub=%BS% Please enter (y/n): 
if not defined sub goto Sub1

:Subop
if /i %sub%==y set show=/s & call :check & set word= /R & goto Name
if /i %sub%==n set cr=%cd%\& call :check & goto Name
goto Sub1

:Name
echo.
for %%i in (.) do set name1=%%~nxi
set /p name2=%BS% Enter rulename or press enter to name it as "%name1% _exe_file_path_": 
if not defined name2 set name2=%name1% %%~nxa

echo.
set /p way=%BS% Confirm ( i - Inbound / o - Outbound / b - Both ): 
if not defined way goto Way1
goto Wayop
:Way1
set /p way=%BS% Please enter i/o/b: 
if not defined way goto Way1

:Wayop
if /i %way%==i set way=in & goto InOut
if /i %way%==o set way=out & goto InOut
if /i %way%==b goto Both
goto Way1

:InOut
echo.
if %way%==in set way1=In
if %way%==out set way1=Out
echo  Adding %way1%bound rules for....
echo.
for%word% %%f in ("*.exe") do echo  %%~nxf
call :Rule
goto Done

:Both
echo.
echo  Adding Inbound and Outbound Rules for....
echo.
for%word% %%f in ("*.exe") do echo  %%~nxf
set way=in
call :Rule
set way=out
call :Rule

:Done
echo.
echo  COMPLETED....!!
echo.
set /p choice="Do you want to restart? (y/n): "
if /i not '%choice%'=='' set choice=%choice:~0,1%
if /i '%choice%'=='y' set name2=& set cr=& set word=& echo. & echo. & goto Start
echo  Press any key to exit
pause >nul
exit /b

:Rule
for %word% %%a in ("*.exe") do (
netsh advfirewall firewall add rule name="%name2%" dir=%way% program="%cr%%%a" action=block >nul
)
goto :eof

:check
dir %show% /a-d "*.exe" >nul 2>&1
if errorlevel 1 (
echo.
timeout 1 >nul
echo  No EXE file exists.
timeout 2 >nul
cls
goto Dirc0
)

:*/