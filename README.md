# Acer AN515-54 GTX1650 i7 - SREP Bootable USB Setup

Automated setup to create a bootable USB drive with **Smokeless Runtime EFI Patcher (SREP)** that auto-runs on boot. This enables BIOS/UEFI modifications for hidden settings, CPU/GPU tweaks, and firmware patches.

## What This Does

- Downloads/prepares SREP 0.2.4 RUS for your Acer laptop
- Creates a bootable UEFI USB drive
- Auto-runs SREP config on USB boot via UEFI Shell script
- Includes pre-configured SREP config for common Acer AN515-54 BIOS mods
- Logs all operations to `SREP.log` for debugging

## Requirements

- USB drive (8GB+ recommended)
- Linux/macOS/Windows with `dd` or Etcher
- SREP 0.2.4 RUS binary (pre-included or download from [Maxinator500/SmokelessRuntimeEFIPatcher-RUS](https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/releases))
- Your Acer AN515-54 set to boot UEFI (not Legacy BIOS)

## Quick Start

### 1. Prepare USB Drive (Linux/macOS)

```bash
# List USB drives
lsblk  # or diskutil list (macOS)

# Example: /dev/sdb is your USB drive (CHANGE THIS!)
SUSB=/dev/sdb

# Unmount if mounted
sudo umount ${USB}*

# Run the setup script
bash prepare_usb.sh ${USB}
```

### 2. Prepare USB Drive (Windows)

```powershell
# Open PowerShell as Administrator
# Run the Windows batch script
.\prepare_usb.bat
```

### 3. Boot Your Acer AN515-54

1. Insert USB drive
2. Power on, press **F2** or **Del** during boot to enter BIOS
3. Go to **Boot** → **Boot Mode** → set to **UEFI**
4. Go to **Security** → **Secure Boot** → disable (SREP won't run with it on)
5. **Save & Exit**, then boot from USB (usually **F12** or **Esc** on boot screen)
6. UEFI Shell will load automatically
7. SREP runs with your config and logs to `SREP.log`

## File Structure

```
USB Root/
├── EFI/
│   └── BOOT/
│       ├── BOOTX64.efi          (UEFI bootloader)
│       └── SREP.efi             (Smokeless Runtime EFI Patcher)
├── startup.nsh                   (Auto-run SREP on boot)
├── SREP_LOG.cfg                  (Config with logging enabled)
├── SREP.log                      (Generated after first run)
└── README.txt                    (Quick guide on USB)
```

## Config Files Included

### `SREP_LOG.cfg` - Default Configuration

This config includes:
- **Logging enabled** (writes to `SREP.log`)
- **Russian language mode** (remove `_ENG` to switch)
- **CPU Microcode/BIOS patches** for Acer AN515-54
- **GPU VBIOS tweaks** (GTX 1650)
- **Fan control unlock** (optional)

**NOTE:** Modify `SREP_LOG.cfg` to match your specific BIOS version before using.

### Creating Custom Configs

SREP configs use this syntax:

```ini
# Comments start with #
Op Loaded
SetupUtility

Op Patch
Pattern
FFFFAABBCCDD
FFFFAABBDDEE

Op End
```

See [SREP Documentation](https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS#%D0%A1%D0%B8%D0%BD%D1%82%D0%B0%D0%BA%D1%81%D0%B8%D1%81-%D0%B4%D0%BB%D1%8F-%D0%BA%D0%B0%D0%B6%D0%B4%D0%BE%D0%B9-%D0%B8%D0%B7-%D0%BD%D0%BE%D0%B2%D1%8B%D1%85-%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4) for full syntax.

## Troubleshooting

### USB Won't Boot

- **Secure Boot enabled?** Disable it in BIOS (Security → Secure Boot → Off)
- **Wrong boot mode?** Set BIOS to **UEFI**, not Legacy/CSM
- **USB not first in boot order?** Reorder in BIOS Boot Priority
- **Wrong USB device?** Double-check with `lsblk` before running `prepare_usb.sh`

### SREP Runs but Config Doesn't Apply

- Check `SREP.log` for error messages
- Verify `SREP_LOG.cfg` syntax (no trailing spaces, proper GUID format)
- Ensure config matches your BIOS version
- Try `SREP_ENG_LOG.cfg` for English output

### BIOS Won't Change After SREP

- **Clearing CMOS:** Hold power button 30s while unplugged to reset BIOS
- **BIOS Lock:** Some Acer models have additional locks; check BIOS settings
- **Firmware Version:** Check `SREP.log` to confirm correct module was loaded

## Advanced: Custom Patches

### For Your Specific BIOS

1. Extract BIOS file from your Acer laptop (using UEFITool or manufacturer firmware update)
2. Use UEFITool to locate the module/driver you want to patch
3. Identify GUID and hex patterns
4. Create patch instructions in your config
5. Test in a safe environment first!

### Tools Needed

- [UEFITool](https://github.com/LongSoft/UEFITool) - UEFI image inspector
- [Hex Fiend](https://hexfiend.com/) - Hex editor
- [010 Editor](https://www.sweetscape.com/010editor/) - Advanced binary analysis

## Safety Warning ⚠️

**SREP modifies runtime firmware. Incorrect patches can brick your system.**

- **Always backup** your original BIOS first
- **Test patches** on a non-production machine if possible
- **Keep bootable CMOS reset method** handy (hold power 30s unplugged)
- **Double-check GUIDs and hex patterns** before applying
- **Start simple:** Test with logging before complex patches

## What Can You Do With SREP on Acer AN515-54?

✅ Unlock hidden BIOS menus (FSB, multiplier, voltage settings)
✅ Remove CPU power limits (TDP unlock)
✅ Override fan curves
✅ Modify GPU clocks (if VBIOS is patchable)
✅ Change boot logos
✅ Disable Intel ME/Secure Boot restrictions
✅ Add/remove UEFI drivers

❌ Does NOT: Reflash firmware, change chipset, modify UEFI variables permanently

## Credits & Sources

- **SREP:** [Maxinator500/SmokelessRuntimeEFIPatcher-RUS](https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS)
- **UEFI Boot:** EDK2 UEFI Shell
- **Auto-boot:** UEFI `startup.nsh` script

## License

This setup kit is public domain. SREP itself is governed by its original license.

---

**For detailed SREP command reference, see:** [SREP README](https://github.com/Maxinator500/SmokelessRuntimeEFIPatcher-RUS/blob/master/README.md)
