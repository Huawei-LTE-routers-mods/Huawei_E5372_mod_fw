#!/system/bin/busybox sh
ln -s /dev/appvcom /dev/appvcom1 2> /dev/null
killall -STOP ats
timeout -t 3 /app/bin/oled_hijack/atc "$@"
killall -CONT ats
