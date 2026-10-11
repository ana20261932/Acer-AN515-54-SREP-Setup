ACER AN515-54 SREP BOOTABLE USB - QUICK START
===============================================

FILES ON THIS USB:
  /startup.nsh          - UEFI Shell auto-run script (executes on boot)
  /SREP_LOG.cfg         - Main config file (Russian output + logging)
  /SREP_ENG_LOG.cfg     - Config file (English output + logging)
  /EFI/BOOT/SREP.efi    - Smokeless Runtime EFI Patcher executable
  /SREP.log             - Log file (created after first run)

HOW TO USE:

1. INSERT USB into your Acer AN515-54
2. POWER ON laptop and press F2 or Del during POST to enter BIOS
3. NAVIGATE to Boot menu
4. CHANGE Boot Mode from "Legacy" to "UEFI"
5. NAVIGATE to Security menu
6. DISABLE Secure Boot (set to "Off")
7. SAVE & EXIT (F10 or similar)
8. BOOT FROM USB (press F12 or Esc on boot screen, select USB drive)
9. UEFI Shell loads automatically
10. SREP.efi runs with your config (SREP_LOG.cfg)
11. SREP writes results to SREP.log
12. REBOOT when done
13. INSERT USB into Windows/Mac/Linux computer
14. OPEN SREP.log in text editor to review results

TROUBLESHOOTING:

❌ USB Won't Boot:
   - Ensure BIOS set to UEFI (not Legacy/CSM)
   - Ensure Secure Boot is DISABLED
   - Try moving USB to different port
   - Check USB device order in Boot Priority

❌ SREP Starts but Config Doesn't Apply:
   - Check SREP.log for error messages
   - Verify your BIOS version matches config patches
   - Ensure no typos in GUID or hex patterns
   - Try SREP_ENG_LOG.cfg instead for English output

❌ Laptop Won't Boot After SREP:
   - Power off laptop completely
   - Unplug power adapter
   - Hold power button for 30+ seconds (clears CMOS)
   - Plug in and reboot
   - If still broken, you may need BIOS recovery (consult Acer)

CUSTOMIZING CONFIG:

1. Download UEFITool: https://github.com/LongSoft/UEFITool
2. Extract your laptop's BIOS file (from firmware update or backup)
3. Open in UEFITool and find modules/drivers to patch
4. Note GUID and hex byte patterns
5. Edit SREP_LOG.cfg with new Op codes and hex values
6. Save and re-copy to USB root
7. Test again

DOCUMENTATION:

For full SREP syntax and examples:
https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/blob/master/README.md

For UEFI firmware concepts:
https://uefi.org/specifications

For Acer laptop BIOS extraction:
https://www.mydellmini.com/forum (general BIOS modding community)

⚠ WARNING ⚠

Firmware patching can permanently damage your laptop if done incorrectly.
- ALWAYS test on a safe machine first
- KEEP BACKUP of original BIOS
- Double-check hex patterns before patching
- Start with simple patches
- Have CMOS reset method ready (hold power 30s unplugged)

GOOD LUCK!
