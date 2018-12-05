#!/system/bin/sh

board=`getprop ro.product.board`
cfg_boot_opti_buildin=`getprop ro.balong.kobuildin`

case "$board" in
    "p500bbit") insmod /system/bin/GUPS.ko
    ;;
    "v3r2es")
    charge=$(cat /proc/power_on)
    echo "StartupMode = "
    echo $charge
    case "$charge" in
        "#StartupMode:0!") echo "StartupMode : Invalid!"
        ;;
        "#StartupMode:2!") echo "StartupMode : Charge!"
        ;;
        "#StartupMode:1!") echo "Normal mode. Insert /system/bin/GUPS.ko"
        insmod /system/bin/GUPS.ko 
        ;;
        *) echo "Default mode: Insert /system/bin/GUPS.ko"
        insmod /system/bin/GUPS.ko 
        ;; 
    esac
    ;;
    "v3r2es_stick") insmod /system/bin/GUPS.ko 
    ;;
    "v3r2sft") insmod /system/bin/GUPS.ko 
    ;;
    "v7r1asic") insmod /system/bin/v7r1_app.ko 
    ;;
    "hi6920csp500") insmod /system/bin/v7r1_app.ko 
    ;;
    "p500fpga") insmod /system/bin/v7r1_app.ko 
    ;;
    "hi6920cs_sft") insmod /system/bin/v7r1_app.ko 
    ;;
    "hi6920cs_asic") 
	echo $cfg_boot_opti_buildin
	case "$cfg_boot_opti_buildin" in
		"YES") 
		;;
		*)  echo "cfg_boot_opti_buildin=$cfg_boot_opti_buildin"
		insmod /system/bin/v7r1_app.ko
		;;
	esac
    ;;
esac

#move mount data partition to this shell script
#mount -t yaffs2 /dev/block/mtdblock10 /data
