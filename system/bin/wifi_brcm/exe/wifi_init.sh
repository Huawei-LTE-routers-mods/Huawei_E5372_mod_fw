#!/system/bin/busybox sh

echo ------------ wifi init ---------------

export PATH=$PATH:/system/bin/wifi_brcm/exe/

/system/bin/wifi_brcm/exe/getWifiStartUpFlag

if [  "$?" = "1" ]
then
    /system/bin/wifi_brcm/exe/wifi_tcmd_init.sh
else
    insmod /system/bin/wifi_brcm/driver/bcm43362.ko firmware_path=/system/bin/wifi_brcm/firmware/firmware.bin nvram_path=/system/bin/wifi_brcm/nv/nv.txt

if [ "$?" = "0" ]
then
    echo "Download wifi firmware successfully!"
	exit 0
	cd /system/bin/wifi_brcm/exe
    ./wl down
    ./wl mpc 0
    ./wl maxassoc 5
    ./wl apsta 1
    ./wl bi 100 
    ./wl radio_pwrsave_quiet_time 0
    ./wl radio_pwrsave_pps 20 
    ./wl radio_pwrsave_on_time 10 
    ./wl radio_pwrsave_enable 1 
    ./wl up

    ./wl bss -C 1 down
    ./wl ssid -C 1 "BalongV3R2_WiFi"
    ./wl -i wl0.1 country ALL
    ./wl -i wl0.1 channel 1
    ./wl -i wl0.1 auth 0
    ./wl -i wl0.1 wsec 0
    ./wl -i wl0.1 wpa_auth 0
    ./wl bss -C 1 up
    cd /
else
    echo "Download wifi firmware failed!!!!!!!"
    exit 1
fi

fi


exit 0
