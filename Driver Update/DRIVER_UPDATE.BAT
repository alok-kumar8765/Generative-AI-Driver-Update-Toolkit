@echo off
setlocal EnableExtensions
title Generative AI Driver Update Toolkit
color 0A

:: Check for Administrator Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Please right-click this file and select Run as administrator.
    echo.
    pause
    exit /b
)

:MENU
cls
echo ======================================================
echo           GENERATIVE AI DRIVER UPDATE TOOLKIT
echo ======================================================
echo.
echo  [1] Trigger Windows Update Driver Search and Install
echo  [2] Open Windows Update Settings (Manage Optional Updates)
echo  [3] Open Device Manager (Check Driver Status)
echo  [4] Exit
echo.
echo ======================================================
set /p "CHOICE=Select an option (1-4): "

if "%CHOICE%"=="1" goto RUNUPDATE
if "%CHOICE%"=="2" goto SETTINGS
if "%CHOICE%"=="3" goto DEVMGMT
if "%CHOICE%"=="4" exit /b

echo Invalid selection.
timeout /t 2 >nul
goto MENU

:RUNUPDATE
cls
echo ======================================================
echo           GENERATIVE AI DRIVER UPDATE TOOLKIT
echo ======================================================
echo.
echo [1/3] Checking Windows Update service...
sc config wuauserv start= auto >nul 2>&1
net start wuauserv >nul 2>&1

echo.
echo [2/3] Checking Windows Update...
UsoClient StartScan

echo.
echo [3/3] Starting Windows Update download...
UsoClient StartDownload
UsoClient StartInstall

echo.
echo ======================================================
echo Driver update process has been triggered.
echo ======================================================
echo.
echo IMPORTANT:
echo - Windows Update may continue working in the background.
echo - Restart the PC if Windows requests it.
echo - Optional driver updates can be checked manually:
echo   Settings ^> Windows Update ^> Advanced options
echo   ^> Optional updates ^> Driver updates
echo.
pause
goto MENU

:SETTINGS
cls
echo Opening Windows Update settings...
start ms-settings:windowsupdate
goto MENU

:DEVMGMT
cls
echo Opening Device Manager...
devmgmt.msc
goto MENU