@echo off
powershell.exe -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"
powershell.exe -File "%~dp0backup - 21.1.176.ps1"
pause
