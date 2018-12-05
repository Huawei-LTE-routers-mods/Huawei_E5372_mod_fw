#!/system/bin/busybox sh
mount  -o remount /dev/mtd/mtd0 /system
/system/bin/mv /system/bin/wifi_brcm/exe/powersave_open.sh /system/bin/wifi_brcm/exe/powersave_open.bak
/system/bin/mv /system/bin/wifi_brcm/exe/powersave_close.sh /system/bin/wifi_brcm/exe/powersave_close.bak