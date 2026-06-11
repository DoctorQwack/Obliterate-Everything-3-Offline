@echo off
title Obliterate Everything 3 - Legacy Save Converter
cls
echo Starting Legacy Save Converter...
python OE3_Updated_Offline\convert_save.py
if %errorlevel% neq 0 (
    echo.
    echo Python script failed or Python is not installed.
    echo Please make sure Python is installed and added to PATH.
    pause
)
