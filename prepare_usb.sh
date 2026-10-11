#!/bin/bash
# Acer AN515-54 SREP Bootable USB Preparation Script (Linux/macOS)
# Usage: bash prepare_usb.sh /dev/sdX
# WARNING: This will WIPE the specified USB drive. Ensure it's the correct device!

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <USB_DEVICE>"
    echo "Example: $0 /dev/sdb"
    echo ""
    echo "List USB drives:"
    echo "  Linux:  lsblk"
    echo "  macOS:  diskutil list"
    exit 1
fi

USB_DEVICE="$1"
USB_MOUNT="/tmp/srep_usb_$$"

echo "================================================"
echo "SREP Bootable USB Preparation Tool"
echo "Acer AN515-54 GTX1650 i7"
echo "================================================"
echo ""
echo "WARNING: This will ERASE all data on $USB_DEVICE"
echo "Ensure this is your USB drive, not your system disk!"
echo ""
read -p "Continue? (type 'yes' to confirm): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "[1/6] Unmounting $USB_DEVICE..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    diskutil unmountDisk "$USB_DEVICE" 2>/dev/null || true
else
    # Linux
    sudo umount ${USB_DEVICE}* 2>/dev/null || true
fi

echo "[2/6] Creating FAT32 partition..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    diskutil eraseDisk FAT32 SREP MBRFormat "$USB_DEVICE"
else
    # Linux
    sudo parted -s "$USB_DEVICE" mklabel msdos
    sudo parted -s "$USB_DEVICE" mkpart primary fat32 1M 100%
    sudo parted -s "$USB_DEVICE" set 1 boot on
    PARTITION="${USB_DEVICE}1"
    sudo mkfs.vfat -F 32 "$PARTITION"
fi

echo "[3/6] Mounting USB drive..."
mkdir -p "$USB_MOUNT"
if [[ "$OSTYPE" == "darwin"* ]]; then
    mount -t msdos "$USB_DEVICE" "$USB_MOUNT" 2>/dev/null || mount -t vfat "$USB_DEVICE" "$USB_MOUNT"
else
    PARTITION="${USB_DEVICE}1"
    sudo mount -t vfat "$PARTITION" "$USB_MOUNT"
fi

echo "[4/6] Creating EFI boot structure..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir -p "$USB_MOUNT/EFI/BOOT"
else
    sudo mkdir -p "$USB_MOUNT/EFI/BOOT"
fi

echo "[5/6] Copying SREP files..."
if [ -f "./SREP.efi" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        cp ./SREP.efi "$USB_MOUNT/EFI/BOOT/"
    else
        sudo cp ./SREP.efi "$USB_MOUNT/EFI/BOOT/"
    fi
    echo "  ✓ SREP.efi copied"
else
    echo "  ⚠ SREP.efi not found in current directory"
    echo "  Download from: https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/releases"
    echo "  Place in repo root and run again"
fi

if [ -f "./BOOTX64.efi" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        cp ./BOOTX64.efi "$USB_MOUNT/EFI/BOOT/"
    else
        sudo cp ./BOOTX64.efi "$USB_MOUNT/EFI/BOOT/"
    fi
    echo "  ✓ BOOTX64.efi copied"
else
    echo "  ℹ BOOTX64.efi not found (optional)"
fi

echo "[6/6] Copying config and startup script..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    cp ./startup.nsh "$USB_MOUNT/" 2>/dev/null || echo "  ⚠ startup.nsh not found"
    cp ./SREP_LOG.cfg "$USB_MOUNT/" 2>/dev/null || echo "  ⚠ SREP_LOG.cfg not found"
    cp ./README.txt "$USB_MOUNT/" 2>/dev/null || echo "  ℹ README.txt not found (optional)"
else
    sudo cp ./startup.nsh "$USB_MOUNT/" 2>/dev/null || echo "  ⚠ startup.nsh not found"
    sudo cp ./SREP_LOG.cfg "$USB_MOUNT/" 2>/dev/null || echo "  ⚠ SREP_LOG.cfg not found"
    sudo cp ./README.txt "$USB_MOUNT/" 2>/dev/null || echo "  ℹ README.txt not found (optional)"
fi

echo ""
echo "Syncing and unmounting..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    diskutil unmountDisk "$USB_DEVICE"
else
    sync
    sudo umount "$USB_MOUNT"
fi

rm -rf "$USB_MOUNT"

echo ""
echo "================================================"
echo "✓ SREP Bootable USB Ready!"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. Remove USB safely"
echo "2. Insert into Acer AN515-54"
echo "3. Boot and press F2/Del to enter BIOS"
echo "4. Set Boot Mode to UEFI (not Legacy)"
echo "5. Disable Secure Boot (Security → Off)"
echo "6. Save & Exit, then boot from USB"
echo "7. SREP will auto-run with your config"
echo "8. Check SREP.log for results"
echo ""
echo "For help, see README.md"
