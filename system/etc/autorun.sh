#!/system/bin/busybox sh

mkdir bin
ln -s /system/bin/sh /bin/sh
ln -s /system/bin/busybox /bin/ash
ln -s /app/bin/oled_hijack/atc.sh /sbin/atc
mkdir /var /opt /tmp /online/opt
# For Entware
mount --bind /online/opt /opt
# For TUN/TAP
mkdir /dev/net
mknod /dev/net/tun c 10 200

/system/sbin/NwInquire &

busybox echo 0 > /proc/sys/net/netfilter/nf_conntrack_checksum

#根据产线NV项，如果是产线版本，则只起wifi，否则起全应用，forgive me pls, no better method thought
ecall bsp_get_factory_mode
dmesg | grep "+=+=+==factory_mode+=+=+=="
if [ $? -eq 0 ]
then 
	ecall wifi_power_on_full 1
else
	/system/bin/insmod /system/bin/kmod/patchblocked.ko
	/system/bin/insmod /system/bin/kmod/tun.ko
	/system/bin/insmod_ctf_ko.sh
	/system/bin/insmod /system/bin/kmod/crc16.ko
	/system/bin/insmod /system/bin/kmod/mbcache.ko
	/system/bin/insmod /system/bin/kmod/jbd2.ko
	/system/bin/insmod /system/bin/kmod/ext4.ko

	/system/etc/fix_ttl.sh 0
	/system/bin/busybox sysctl -p /system/etc/sysctl.conf

	/app/appautorun.sh

	[ ! -f /data/userdata/passwd ] && cp /etc/passwd_def /data/userdata/passwd
	[ ! -f /data/userdata/telnet_disable ] && telnetd -l login -b 0.0.0.0
	[ ! -f /data/userdata/adb_disable ] && adb

	/app/bin/oled_hijack/autorun.sh
	[ -f /data/userdata/entware_autorun ] && /opt/etc/init.d/rc.unslung start
	# fix_ttl.sh 2, anticensorship.sh and adblock.sh are called from iptables wrapper.
fi
