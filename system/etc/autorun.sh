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
	# Set time closer to a real time for time-sensitive software.
	# Needed for everything TLS/HTTPS-related, like DNS over TLS stubby,
	# to work before the time is synced over the internet.
	date -u -s '2018-12-01 00:00:00'

	# Unlock blocked (sensitive) NVRAM items to be readable/writable
	# using AT^NVRD/AT^NVWR.
	/system/bin/insmod /system/bin/kmod/patchblocked.ko
	# TUN/TAP support
	/system/bin/insmod /system/bin/kmod/tun.ko
	# EXT2/3/4
	/system/bin/insmod /system/bin/kmod/crc16.ko
	/system/bin/insmod /system/bin/kmod/mbcache.ko
	/system/bin/insmod /system/bin/kmod/jbd2.ko
	/system/bin/insmod /system/bin/kmod/ext4.ko
	# Cut-Thru forwarding (software NAT offloading) with TTL awareness
	/system/bin/insmod_ctf_ko.sh

	# See /system/bin/iptables-fixttl-wrapper.sh
	/system/etc/fix_ttl.sh 0
	/system/bin/busybox sysctl -p /system/etc/sysctl.conf

	# Run oled hijack autorun: unlock DATALOCK and cache some data
	/app/bin/oled_hijack/autorun.sh
	/app/appautorun.sh

	[ ! -f /data/userdata/passwd ] && cp /etc/passwd_def /data/userdata/passwd
	[ ! -f /data/userdata/telnet_disable ] && telnetd -l login -b 0.0.0.0
	[ ! -f /data/userdata/adb_disable ] && adb

	# Entware autorun is performed only if was enabled manually
	[ -f /data/userdata/entware_autorun ] && /opt/etc/init.d/rc.unslung start
	# fix_ttl.sh 2, anticensorship.sh and dns_over_tls.sh are called from iptables wrapper.
fi
