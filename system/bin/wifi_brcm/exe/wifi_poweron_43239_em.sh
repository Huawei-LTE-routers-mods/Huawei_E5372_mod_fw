#!/system/bin/busybox sh

/system/bin/sleep 1s

num=1

while [ "$num" -le 7 ]; do
lsusb | grep bd1b
if [ $? -ne 0 ]
then
    echo "wait for $num seconds"
    /system/bin/sleep 1s
    num=$(($num+1))
else
    break
fi
done

#just to check whether lsusb really got wifi chip
lsusb | grep bd1b
if [ $? -ne 0 ]
then
    /system/bin/ecall BCM43239_WIFI_PWRCTRL_SAVE
    echo "wait for 2 seconds for fail safe"
    /system/bin/sleep 2s
    /system/bin/rmmod dhd
    /system/bin/ecall BCM43239_WIFI_PWRCTRL_RESTORE
    /system/bin/sleep 4s
fi
#/system/bin/sleep 6s

echo "the wifi dev found"
/system/bin/wifi_brcm/exe/bcmdl -n /system/bin/wifi_brcm/nv/nvram_43239_B50_murata_em /system/bin/wifi_brcm/firmware/43239combo_em.trx
/system/bin/insmod /system/bin/wifi_brcm/driver/dhd.ko
ifconfig WiFi0 up

exit 0