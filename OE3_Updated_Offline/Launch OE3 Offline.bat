@echo off
title OE3 Offline Server
cd /d "%~dp0"
echo Starting OE3 Offline Server...
echo Keep this window open while playing.
echo.
powershell -Command "Unblock-File '%~dp0server.ps1'" 2>nul
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0server.ps1"
echo.
echo Server has stopped.
pause
