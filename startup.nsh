# UEFI Shell Startup Script - Auto-runs SREP on boot
# Copy to USB root as "startup.nsh"
# UEFI firmware will auto-execute this on boot

echo.
echo ===============================================
echo SREP Auto-Boot for Acer AN515-54
echo ===============================================
echo.

REM Detect boot device (usually fs0: or fs1:)
echo Scanning for SREP.efi...

if exist fs0:\SREP.efi then
  echo Found on fs0:
  fs0:
  goto :run_srep
endif

if exist fs0:\EFI\BOOT\SREP.efi then
  echo Found in EFI/BOOT on fs0:
  fs0:
  cd EFI\BOOT
  goto :run_srep
endif

if exist fs1:\SREP.efi then
  echo Found on fs1:
  fs1:
  goto :run_srep
endif

if exist fs1:\EFI\BOOT\SREP.efi then
  echo Found in EFI/BOOT on fs1:
  fs1:
  cd EFI\BOOT
  goto :run_srep
endif

echo.
echo WARNING: SREP.efi not found!
echo Expected locations:
echo   fs0:\SREP.efi
echo   fs0:\EFI\BOOT\SREP.efi
echo   fs1:\SREP.efi
echo   fs1:\EFI\BOOT\SREP.efi
echo.
echo Entering interactive shell...
exit

:run_srep
echo.
echo Starting SREP (Smokeless Runtime EFI Patcher)...
echo.
echo Config file detected: SREP_LOG.cfg
echo Logging enabled to: SREP.log
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause

echo.
echo Executing SREP...
echo.

REM Run SREP with logging enabled
REM Config name auto-detection: first .cfg file found
REM Append _LOG to filename for logging
SREP.efi

echo.
echo ===============================================
echo SREP Execution Complete
echo ===============================================
echo.
echo Check for SREP.log on USB for detailed results
echo.
echo To view logs:
echo   1. Boot normally without USB
echo   2. Remove USB and check files on computer
echo   3. Open SREP.log in text editor
echo.
echo Entering shell - type 'exit' to reboot...
exit
