@echo off
REM Acer AN515-54 SREP Bootable USB Preparation Script (Windows)
REM Run as Administrator
REM Usage: prepare_usb.bat

setlocal enabledelayedexpansion

echo ================================================
echo SREP Bootable USB Preparation Tool
echo Acer AN515-54 GTX1650 i7 (Windows)
echo ================================================
echo.
echo WARNING: This will ERASE your USB drive.
echo Make sure you have the correct USB device selected!
echo.
echo Available USB drives:
wmic logicaldisk where drivetype=2 get name
echo.
set /p USB_DRIVE="Enter USB drive letter (e.g., D:): "
if "!USB_DRIVE!"==":" (
    echo Invalid input. Exiting.
    exit /b 1
)

echo.
set /p CONFIRM="Format !USB_DRIVE! and create SREP boot? (type 'yes'): "
if /i "!CONFIRM!" neq "yes" (
    echo Aborted.
    exit /b 0
)

echo.
echo [1/5] Formatting USB to FAT32...
format !USB_DRIVE! /FS:FAT32 /Q /Y
if errorlevel 1 (
    echo Error formatting USB. Check Administrator rights.
    pause
    exit /b 1
)

echo [2/5] Creating EFI boot directory structure...
mkdir !USB_DRIVE!\EFI\BOOT
if errorlevel 1 (
    echo Error creating directories.
    pause
    exit /b 1
)

echo [3/5] Copying SREP files...
if exist "SREP.efi" (
    copy "SREP.efi" "!USB_DRIVE!\EFI\BOOT\SREP.efi"
    echo   ^✓ SREP.efi copied
) else (
    echo   ^⚠ SREP.efi not found. Download from:
    echo     https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/releases
)

if exist "BOOTX64.efi" (
    copy "BOOTX64.efi" "!USB_DRIVE!\EFI\BOOT\BOOTX64.efi"
    echo   ^✓ BOOTX64.efi copied
) else (
    echo   ℹ BOOTX64.efi not found (optional)
)

echo [4/5] Copying config and startup script...
if exist "startup.nsh" (
    copy "startup.nsh" "!USB_DRIVE!\startup.nsh"
) else (
    echo   ⚠ startup.nsh not found
)

if exist "SREP_LOG.cfg" (
    copy "SREP_LOG.cfg" "!USB_DRIVE!\SREP_LOG.cfg"
) else (
    echo   ⚠ SREP_LOG.cfg not found
)

if exist "README.txt" (
    copy "README.txt" "!USB_DRIVE!\README.txt"
) else (
    echo   ℹ README.txt not found (optional)
)

echo.
echo [5/5] Verifying files on USB...
dir !USB_DRIVE!\EFI\BOOT
dir !USB_DRIVE!\

echo.
echo ================================================
echo ^✓ SREP Bootable USB Ready!
echo ================================================
echo.
echo Next steps:
    echo 1. Safely eject USB from your Windows PC
    echo 2. Insert into Acer AN515-54
    echo 3. Boot and press F2/Del to enter BIOS
    echo 4. Set Boot Mode to UEFI ^(not Legacy^)
    echo 5. Disable Secure Boot ^(Security ^> Off^)
    echo 6. Save ^& Exit, then boot from USB
    echo 7. SREP will auto-run with your config
    echo 8. Check SREP.log for results
echo.
echo For help, see README.md
echo.
pause
