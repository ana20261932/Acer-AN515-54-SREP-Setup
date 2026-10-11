#!/bin/bash
# Download latest SREP 0.2.4 RUS from GitHub
# Usage: bash download_srep.sh

echo "Downloading SREP 0.2.4 RUS from GitHub..."
echo ""

REPO="Maxinator500/SmokelessRuntimeEFIPatcher-RUS"
RELEASE_URL="https://api.github.com/repos/${REPO}/releases/latest"

echo "Fetching latest release info..."
RESPONSE=$(curl -s "$RELEASE_URL")

if echo "$RESPONSE" | grep -q '"message"'; then
    echo "Error: Could not fetch release info. Check your internet connection."
    echo "Manual download: https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/releases"
    exit 1
fi

echo "Extracting download URL..."
DOWNLOAD_URL=$(echo "$RESPONSE" | grep -o '"browser_download_url": "[^"]*SREP\.efi' | head -1 | cut -d'"' -f4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Could not find SREP.efi download link."
    echo "Visit: https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/releases"
    echo "And download the latest SREP.efi manually."
    exit 1
fi

echo "Download URL: $DOWNLOAD_URL"
echo ""
echo "Downloading..."
curl -L -o SREP.efi "$DOWNLOAD_URL"

if [ -f SREP.efi ]; then
    echo ""
    echo "✓ SREP.efi downloaded successfully!"
    echo "File size: $(du -h SREP.efi | cut -f1)"
    echo ""
    echo "Next step: Run 'bash prepare_usb.sh /dev/sdX' to create bootable USB"
else
    echo "Download failed. Please try again or download manually from:"
    echo "https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/releases"
    exit 1
fi
