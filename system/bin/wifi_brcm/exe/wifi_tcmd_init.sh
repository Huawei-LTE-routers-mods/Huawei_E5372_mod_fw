#!/system/bin/busybox sh
echo ...... wifi startUp with tcmd mode......



export PATH=$PATH:/system/bin/wifi_brcm/exe/
insmod /system/bin/wifi_brcm/driver/bcm43362.ko firmware_path=/system/bin/wifi_brcm/firmware/firmware_mfgtest.bin nvram_path=/system/bin/wifi_brcm/nv/nv.txt


if [ "$?" = "0" ]
then
    echo "Download wifi tcmd firmware successfully!"
    wl down
    wl mpc 0
    wl country ALL
    wl frameburst 1
    wl scansuppress 1
    wl up
    wl isup
    
else
    echo "Download wifi tcmd firmware failed!!!!!!!"
    exit 1
fi

exit 0
