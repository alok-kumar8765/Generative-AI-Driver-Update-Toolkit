@echo off
setlocal EnableExtensions
title Advanced Windows Graphics Diagnostics and Repair
color 0B

set "OUTDIR=%USERPROFILE%\Desktop\GraphicsDiagnostics"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

:MENU
cls
echo ================================================================
echo         ADVANCED WINDOWS GRAPHICS DIAGNOSTICS AND REPAIR
echo ================================================================
echo.
echo Reports folder:
echo %OUTDIR%
echo.
echo ======================== DIAGNOSTIC TOOLS ========================
echo.
echo   1. Create DirectX diagnostic report
echo   2. Collect GPU and display driver information
echo   3. Open Device Manager
echo   4. Open Windows Display Settings
echo   5. Open Windows Update
echo.
echo ========================== REPAIR TOOLS ==========================
echo.
echo   6. Graphics driver reset instructions
echo   7. Scan and repair Windows system files (SFC)
echo   8. Repair Windows component store (DISM)
echo   9. Open Device Manager for driver troubleshooting
echo.
echo ================================================================
echo   10. Open diagnostic reports folder
echo   11. Exit
echo.

set /p "CHOICE=Select an option (1-11): "

if "%CHOICE%"=="1" goto DXREPORT
if "%CHOICE%"=="2" goto GPUINFO
if "%CHOICE%"=="3" goto DEVMGMT
if "%CHOICE%"=="4" goto DISPLAYSET
if "%CHOICE%"=="5" goto UPDATE
if "%CHOICE%"=="6" goto DRIVERRESET
if "%CHOICE%"=="7" goto SFC
if "%CHOICE%"=="8" goto DISM
if "%CHOICE%"=="9" goto DEVMGMT
if "%CHOICE%"=="10" goto OPENFOLDER
if "%CHOICE%"=="11" goto END

echo Invalid selection.
timeout /t 2 >nul
goto MENU

:DXREPORT
cls
echo Creating DirectX diagnostic report...
echo Please wait.
echo.
dxdiag.exe /whql:off /t "%OUTDIR%\DxDiag.txt"
timeout /t 3 >nul
if exist "%OUTDIR%\DxDiag.txt" (
    echo.
    echo SUCCESS: DirectX report created.
    echo Location: "%OUTDIR%\DxDiag.txt"
    choice /c YN /m "Open the report now"
    if errorlevel 2 goto MENU
    notepad "%OUTDIR%\DxDiag.txt"
) else (
    echo Report was not created.
)
pause
goto MENU

:GPUINFO
cls
echo Collecting GPU and display driver information...
echo Please wait.
echo.
(
    echo ==========================================
    echo GPU & DISPLAY HARDWARE INFORMATION
    echo ==========================================
    echo.
    wmic path win32_videocontroller get caption, adapterram, driverversion, status
    echo.
    echo ==========================================
    echo DETAILED DISPLAY CONFIGURATION
    echo ==========================================
    echo.
    powershell -Command "Get-CimInstance Win32_VideoController | Format-List *"
) > "%OUTDIR%\GPU_Info.txt"

echo SUCCESS: GPU info saved to "%OUTDIR%\GPU_Info.txt"
choice /c YN /m "Open the GPU report now"
if errorlevel 2 goto MENU
notepad "%OUTDIR%\GPU_Info.txt"
pause
goto MENU

:DEVMGMT
cls
echo Opening Device Manager...
devmgmt.msc
goto MENU

:DISPLAYSET
cls
echo Opening Windows Display Settings...
start ms-settings:display
goto MENU

:UPDATE
cls
echo Opening Windows Update...
start ms-settings:windowsupdate
goto MENU

:DRIVERRESET
cls
echo ================================================================
echo                 GRAPHICS DRIVER RESET INSTRUCTIONS
echo ================================================================
echo.
echo If your display freezes or your graphics driver crashes, you can 
echo restart your graphics subsystem instantly using Windows built-in shortcut:
echo.
echo   Press: Windows Key + Ctrl + Shift + B
...
echo.
echo Note: Your screen will flicker black for a second and you will hear 
echo a beep sound as Windows restarts the graphics driver safely.
echo.
pause
goto MENU

:SFC
cls
echo Running System File Checker (SFC)...
echo This will scan and repair corrupted Windows system files.
echo.
sfc /scannow
echo.
echo SFC scan complete.
pause
goto MENU

:DISM
cls
echo Repairing Windows Component Store (DISM)...
echo This may take several minutes. Please do not close this window.
echo.
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo DISM repair process complete.
pause
goto MENU

:OPENFOLDER
cls
echo Opening reports directory...
explorer "%OUTDIR%"
goto MENU

:END
cls
echo Thank you for using Advanced Windows Graphics Diagnostics and Repair.
timeout /t 2 >nul
exit