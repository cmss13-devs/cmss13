@echo off

:: Call pwsh if available
set "powershellCmd=powershell"
where pwsh >nul 2>nul
if %errorlevel%==0 (
    set "powershellCmd=pwsh"
)

call %powershellCmd% -NoLogo -ExecutionPolicy Bypass -File "%~dp0\javascript_.ps1" Download-Bun

REM Get the bun path using a temporary file to avoid console wrapping issues
set "TEMP_FILE=%TEMP%\bunpath_%RANDOM%.txt"
call %powershellCmd% -NoLogo -ExecutionPolicy Bypass -Command "& '%~dp0\javascript_.ps1' Get-Path | Out-File -FilePath '%TEMP_FILE%' -Encoding ASCII -NoNewline"
set /p BUN_PATH=<"%TEMP_FILE%"
del "%TEMP_FILE%" 2>nul

set "PATH=%BUN_PATH%;%PATH%"
if exist "%BUN_PATH%\bun.exe" (
    echo | set /p printed_str="Using vendored Bun "
    call "%BUN_PATH%\bun.exe" --version
    call "%BUN_PATH%\bun.exe" %*
    goto exit_with_last_error_level
)
echo "javascript.bat: Failed to bootstrap Bun!"
%COMSPEC% /c exit 1

:exit_with_last_error_level
if not %errorlevel% == 0 %COMSPEC% /c exit %errorlevel% >nul
