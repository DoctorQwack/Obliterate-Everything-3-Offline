@echo off
title OE3 Offline Server
cd /d "%~dp0"
echo Starting OE3 Offline Server...
echo Keep this window open while playing.
echo.
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0server.ps1"
echo.
echo Server has stopped.
pause
