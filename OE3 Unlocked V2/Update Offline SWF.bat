@echo off
title Update Offline SWF
cd /d "%~dp0"

echo Checking for compiled SWF files...

set "SOURCE_DIR=%~dp0OE3-main\OE3-main"
set "TARGET_A=%~dp0OE3_Offline"
set "TARGET_B=%~dp0..\OE3_Updated_Offline"

if not exist "%SOURCE_DIR%" (
    set "SOURCE_DIR=%~dp0..\OE3-main\OE3-main"
)

if exist "%SOURCE_DIR%\OE3_UPDATED.swf" (
    echo Found compiled OE3_UPDATED.swf.
    if exist "%TARGET_A%" (
        echo Copying to "%TARGET_A%"...
        copy /y "%SOURCE_DIR%\OE3_UPDATED.swf" "%TARGET_A%\OE3_UPDATED.swf"
    )
    if exist "%TARGET_B%" (
        echo Copying to "%TARGET_B%"...
        copy /y "%SOURCE_DIR%\OE3_UPDATED.swf" "%TARGET_B%\OE3_UPDATED.swf"
    )
    goto success
)

if exist "%SOURCE_DIR%\OE3.swf" (
    echo Found compiled OE3.swf.
    if exist "%TARGET_A%" (
        echo Copying and renaming to "%TARGET_A%\OE3_UPDATED.swf"...
        copy /y "%SOURCE_DIR%\OE3.swf" "%TARGET_A%\OE3_UPDATED.swf"
    )
    if exist "%TARGET_B%" (
        echo Copying and renaming to "%TARGET_B%\OE3_UPDATED.swf"...
        copy /y "%SOURCE_DIR%\OE3.swf" "%TARGET_B%\OE3_UPDATED.swf"
    )
    goto success
)

echo.
echo ERROR: Could not find compiled SWF file in source directory!
echo Please open OE3.fla in Adobe Flash/Animate and compile/publish it first.
echo.
pause
exit /b 1

:success
echo.
echo SUCCESS: SWF files updated successfully.
echo You can now run "Launch OE3 Offline.bat" inside your player folder to play!
echo.
pause
