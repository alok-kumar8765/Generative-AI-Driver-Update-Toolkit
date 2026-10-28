@echo off
title GENERATIVE AI HDD Repair Tool
color 0B

echo ===========================================
echo         GENERATIVE AI HDD REPAIR TOOL
echo    Digital and Information Technology
echo ===========================================
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as Administrator.
    pause
    exit /b
)

echo WARNING: Back up important files first.
echo This script checks drive C:.
echo.
pause

echo.
echo [1/3] Checking Windows image...
DISM /Online /Cleanup-Image /RestoreHealth

echo.
echo [2/3] Repairing Windows system files...
sfc /scannow

echo.
echo [3/3] Checking drive C: for file-system errors...
chkdsk C: /scan

echo.
echo ===========================================
echo           HDD CHECKS COMPLETED
echo ===========================================
echo Review the results displayed above.
echo.
pause