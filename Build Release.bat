@echo off
title Build OE3 Offline Release Zip
cd /d "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_release.ps1"

echo.
echo Press any key to exit.
pause > nul
