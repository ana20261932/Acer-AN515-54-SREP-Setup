@echo off
REM Download latest SREP 0.2.4 RUS from GitHub (Windows)
REM Requires curl (Windows 10+) or PowerShell

echo.
echo Downloading SREP 0.2.4 RUS from GitHub...
echo.

setlocal enabledelayedexpansion

set REPO=Maxinator500/SmokelessRuntimeEFIPatcher-RUS
set RELEASE_URL=https://api.github.com/repos/!REPO!/releases/latest
set TEMP_JSON=%TEMP%\srep_release.json

echo Fetching latest release info...
curl -s -o "!TEMP_JSON!" "!RELEASE_URL!"

if not exist "!TEMP_JSON!" (
    echo Error: Could not fetch release info. Check internet connection.
    echo Manual download: https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/releases
    pause
    exit /b 1
)

echo.
echo Downloaded release metadata. Extracting SREP.efi URL...

REM PowerShell to extract download URL from JSON
for /f "delims=" %%i in ('powershell -NoProfile -Command "$json = Get-Content '%TEMP_JSON%' | ConvertFrom-Json; $json.assets | Where-Object {$_.name -match 'SREP.efi'} | Select-Object -First 1 -ExpandProperty browser_download_url"') do (
    set DOWNLOAD_URL=%%i
)

if "!DOWNLOAD_URL!"==" " (
    echo Could not find SREP.efi in releases.
    echo Visit: https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/releases
    echo Download manually and place SREP.efi in this directory.
    pause
    exit /b 1
)

echo Download URL: !DOWNLOAD_URL!
echo.
echo Downloading SREP.efi...
curl -L -o SREP.efi "!DOWNLOAD_URL!"

if exist SREP.efi (
    echo.
    echo ^✓ SREP.efi downloaded successfully!
    echo File: SREP.efi
    echo.
    echo Next step: Run 'prepare_usb.bat' to create bootable USB
    echo.
    pause
) else (
    echo.
    echo Download failed. Please try manual download:
    echo https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/releases
    echo.
    pause
    exit /b 1
)

del "!TEMP_JSON!"
