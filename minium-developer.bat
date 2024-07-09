@echo off

set ERROR_CODE=0

:init
if NOT "%OS%"=="Windows_NT" goto Win9xArg

if "%OS%"=="Windows_NT" @setlocal

if "%eval[2+2]" == "4" goto 4NTArgs

set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
cd %0\..\..
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup
set REPO=

if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\lib

set CLASSPATH="%BASEDIR%\config";"%REPO%\*"

set ENDORSED_DIR=
if NOT "%ENDORSED_DIR%" == "" set CLASSPATH="%BASEDIR%\%ENDORSED_DIR%\*;%CLASSPATH%"

if NOT "%CLASSPATH_PREFIX%" == "" set CLASSPATH=%CLASSPATH_PREFIX%;%CLASSPATH%

:endInit

cd /d C:\MiniumDeveloper\minium-developer-win64

%JAVACMD% %JAVA_OPTS% --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.text=ALL-UNNAMED --add-opens java.desktop/java.awt.font=ALL-UNNAMED -Xms128m -Xmx256m -cp "C:\MiniumDeveloper\minium-developer-win64\lib\*;C:\MiniumDeveloper\minium-developer-win64\lib\minium-developer-web-2.6.0.jar" -Dapp.name="minium-developer" -Dapp.repo="%REPO%" -Dapp.home="%BASEDIR%" -Dbasedir="%BASEDIR%" minium.developer.Application %CMD_LINE_ARGS%
if %ERRORLEVEL% NEQ 0 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=%ERRORLEVEL%

:end
if "%OS%"=="Windows_NT" goto endNT

set CMD_LINE_ARGS=
goto postExec

:endNT
if %ERROR_CODE% EQU 0 @endlocal

:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
