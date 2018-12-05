#!/system/bin/busybox sh

mkdir bin
ln -s /system/bin/sh /bin/sh

/system/sbin/NwInquire &

busybox echo 0 > /proc/sys/net/netfilter/nf_conntrack_checksum

#根据产线NV项，如果是产线版本，则只起wifi，否则起全应用，forgive me pls, no better method thought
ecall bsp_get_factory_mode
dmesg | grep "+=+=+==factory_mode+=+=+=="
if [ $? -eq 0 ]
then 
	ecall wifi_power_on_full 1
else
	/app/appautorun.sh
fi