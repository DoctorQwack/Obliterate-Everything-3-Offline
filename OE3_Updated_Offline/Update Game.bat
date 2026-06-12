@echo off
title OE3 Game Updater
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File update.ps1
