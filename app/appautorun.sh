#!/system/bin/sh

mkdir /var

mkdir /var/run

mkdir /var/log

export LD_LIBRARY_PATH="/app/lib:/system/lib:/system/lib/glibc"

export PATH="/sbin:/app/bin:/system/sbin:/system/bin:/system/xbin:/app/bin"

mlogserver &

ln -s /data /app/webroot/data
busybox echo 1 > /proc/sys/net/ipv4/ip_forward

busybox echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

if busybox [ -e /data/coredebug ]
then
	ulimit -c unlimited
	echo "1" > /proc/sys/kernel/core_uses_pid
	echo "/online/log/core-%e-%p-%t" > /proc/sys/kernel/core_pattern
fi

#/*BEGIN DTS2013041503469 huangwei 00206899 2013-03-26 added*/
#mkdir /dev/socket/qmux_radio
#/*END DTS2013041503469 huangwei 00206899 2013-03-26 added*/

#/*BEGIN DTS2013041503469 huangwei 00206899 2013-03-26 added*/
#qmuxd &
#/*END DTS2013041503469 huangwei 00206899 2013-03-26 added*/


#BIGIN DTS2013072000109 huyufeng 20130722 added
/system/bin/insmod /system/bin/ctf.ko
#END DTS2013072000109 huyufeng 20130722 added

netmgrd &

ln -s /dev/smd7 /dev/appvcom
npdaemon &


syswatch &
