@echo off
rem Launcher for export_mis.ps1 (must be in the same folder).
rem Interactive run:              export_mis.bat
rem Task Scheduler (no prompts):  export_mis.bat /nopause
if /i "%~1"=="/nopause" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0export_mis.ps1" -NonInteractive
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0export_mis.ps1"
)
set RC=%ERRORLEVEL%
if /i not "%~1"=="/nopause" pause
exit /b %RC%
