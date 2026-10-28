@echo off
setlocal EnableExtensions
title GENERATIVE AI Boot and Recovery Toolkit
color 0B

:: Check administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo Please right-click this file and select Run as administrator.
    pause
    exit /b
)

:: Create a log folder
set "LOGDIR=%USERPROFILE%\Desktop\ANIK_Recovery_Logs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"
set "LOG=%LOGDIR%\Recovery_Log.txt"

echo ====================================================================== >> "%LOG%"
echo ANIK BOOT AND RECOVERY TOOLKIT >> "%LOG%"
echo Started: %DATE% %TIME% >> "%LOG%"
echo ====================================================================== >> "%LOG%"

:MENU
cls
echo ======================================================================
echo             ANIK BOOT AND RECOVERY TOOLKIT
echo             Windows 10 and Windows 11
echo ======================================================================
echo.
echo  [1] Generate Boot Configuration Report
echo  [2] Check Windows Recovery Environment
echo  [3] Enable Windows Recovery Environment
echo  [4] Run SFC System File Checker
echo  [5] Repair Windows Image with DISM
echo  [6] Scan System Drive for Errors
echo  [7] Check Physical Disk Health
echo  [8] Back Up Boot Configuration
echo  [9] Open Windows Recovery Settings
echo  [10] Open Advanced Startup Configuration
echo  [11] Create System Restore Point
echo  [12] Open System Configuration (Safe Mode)
echo  [13] Generate System Information Report
echo  [14] View Repair Log
echo  [15] Restart Computer
echo  [16] Exit
echo.
echo ======================================================================
set /p "choice=Select an option (1-16): "

if "%choice%"=="1" goto BOOTREPORT
if "%choice%"=="2" goto WINRE
if "%choice%"=="3" goto ENABLEWINRE
if "%choice%"=="4" goto SFC
if "%choice%"=="5" goto DISM
if "%choice%"=="6" goto CHKDSK
if "%choice%"=="7" goto DISKHEALTH
if "%choice%"=="8" goto BCDBACKUP
if "%choice%"=="9" goto RECOVERY
if "%choice%"=="10" goto ADVANCED
if "%choice%"=="11" goto RESTORE
if "%choice%"=="12" goto SAFEMODE
if "%choice%"=="13" goto SYSINFO
if "%choice%"=="14" goto VIEWLOG
if "%choice%"=="15" goto RESTART
if "%choice%"=="16" exit /b

echo Invalid selection.
timeout /t 2 >nul
goto MENU

:BOOTREPORT
cls
echo Generating Boot Configuration Report...
echo [%DATE% %TIME%] Generated Boot Configuration Report >> "%LOG%"
bcdedit /enum all >> "%LOGDIR%\Boot_Config_Report.txt"
echo.
echo Report generated successfully at:
echo %LOGDIR%\Boot_Config_Report.txt
pause
goto MENU

:WINRE
cls
echo Checking Windows Recovery Environment status...
reagentc /info
pause
goto MENU

:ENABLEWINRE
cls
echo Enabling Windows Recovery Environment...
reagentc /enable
pause
goto MENU

:SFC
cls
echo Running SFC System File Checker...
echo [%DATE% %TIME%] Ran SFC System File Checker >> "%LOG%"
sfc /scannow
pause
goto MENU

:DISM
cls
echo Repairing Windows Image with DISM...
echo [%DATE% %TIME%] Ran DISM Image Repair >> "%LOG%"
DISM /Online /Cleanup-Image /RestoreHealth
pause
goto MENU

:CHKDSK
cls
echo Scanning System Drive for Errors...
echo [%DATE% %TIME%] Ran CHKDSK Scan >> "%LOG%"
chkdsk C: /scan
pause
goto MENU

:DISKHEALTH
cls
echo Checking Physical Disk Health...
powershell -Command "Get-PhysicalDisk | Format-Table DeviceId, FriendlyName, OperationalStatus, HealthStatus, Size"
pause
goto MENU

:BCDBACKUP
cls
echo Backing up Boot Configuration...
if not exist "%LOGDIR%\Backup" mkdir "%LOGDIR%\Backup"
bcdedit /export "%LOGDIR%\Backup\BCD_Backup"
echo.
echo BCD backup saved to %LOGDIR%\Backup\
pause
goto MENU

:RECOVERY
cls
echo Opening Windows Recovery Settings...
start ms-settings:recovery
goto MENU

:ADVANCED
cls
echo Opening Advanced Startup Configuration...
shutdown /r /o /f /t 00
goto MENU

:RESTORE
cls
echo Creating System Restore Point...
powershell -Command "Enable-ComputerRestore -Drive 'C:'; Checkpoint-Computer -Description 'ANIK_Toolkit_RestorePoint' -RestorePointType 'MODIFY_SETTINGS'"
pause
goto MENU

:SAFEMODE
cls
echo Opening System Configuration (Safe Mode)...
msconfig
goto MENU

:SYSINFO
cls
echo Generating System Information Report...
systeminfo > "%LOGDIR%\System_Information.txt"
echo System Info saved to %LOGDIR%\System_Information.txt
pause
goto MENU

:VIEWLOG
cls
if exist "%LOG%" (
    notepad "%LOG%"
) else (
    echo No log file found yet.
    pause
)
goto MENU

:RESTART
cls
echo Restarting Computer in 5 seconds...
shutdown /r /t 5
exit /b