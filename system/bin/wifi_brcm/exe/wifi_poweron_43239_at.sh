#!/system/bin/busybox sh

num=1

while [ "$num" -le 5 ]; do
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

#/system/bin/sleep 6s

echo "the wifi dev found"
/system/bin/wifi_brcm/exe/bcmdl -n /system/bin/wifi_brcm/nv/nvram_43239_at /system/bin/wifi_brcm/firmware/43239at.trx
/system/bin/insmod /system/bin/wifi_brcm/driver/dhd_test_mode.ko
ifconfig WiFi0 up

exit 0