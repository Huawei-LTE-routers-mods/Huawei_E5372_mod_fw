#!/system/bin/busybox sh

mkdir bin
ln -s /system/bin/sh /bin/sh

/system/sbin/NwInquire &

busybox echo 0 > /proc/sys/net/netfilter/nf_conntrack_checksum

#���ݲ���NV�����ǲ��߰汾����ֻ��wifi��������ȫӦ�ã�forgive me pls, no better method thought
ecall bsp_get_factory_mode
dmesg | grep "+=+=+==factory_mode+=+=+=="
if [ $? -eq 0 ]
then 
	ecall wifi_power_on_full 1
else
	/app/appautorun.sh
fi