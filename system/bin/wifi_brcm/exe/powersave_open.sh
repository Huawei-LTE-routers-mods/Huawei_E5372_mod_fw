#!/system/bin/busybox sh


/system/bin/wifi_brcm/exe/wl radio_pwrsave_quiet_time 0
/system/bin/wifi_brcm/exe/wl radio_pwrsave_pps 20
/system/bin/wifi_brcm/exe/wl radio_pwrsave_on_time 40
/system/bin/wifi_brcm/exe/wl radio_pwrsave_enable 2
