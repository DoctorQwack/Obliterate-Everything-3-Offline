@echo off
echo ===================================================
echo   Building Obliterate Everything 3 - Desktop App
echo ===================================================
echo.

echo [1/2] Installing packaging dependencies (Electron and Builder)...
call npm install
if %ERRORLEVEL% neq 0 (
    echo.
    echo Error: npm install failed. Make sure Node.js is installed and accessible.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [2/2] Packaging game into a portable executable...
call npm run dist
if %ERRORLEVEL% neq 0 (
    echo.
    echo Error: packaging failed.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ===================================================
echo   Build Successful!
echo   Portable EXE is located in: \dist\
echo ===================================================
echo.
pause
