#!/system/bin/busybox sh
ln -s /dev/appvcom /dev/appvcom1 2> /dev/null
# suspend ats daemon to prevent intervention
killall -STOP ats
timeout -t 3 /app/bin/oled_hijack/atc "$@"
killall -CONT ats
