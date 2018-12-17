#!/system/bin/busybox sh

# Radio mode OLED handler.
# By ValdikSS, iam@valdikss.org.ru

NETWORK_AUTO='AT^SYSCFGEX="00",3FFFFFFF,2,2,7fffffffffffffff,,'
NETWORK_GSM_ONLY='AT^SYSCFGEX="01",3FFFFFFF,2,2,7fffffffffffffff,,'
NETWORK_UMTS_ONLY='AT^SYSCFGEX="02",3FFFFFFF,2,2,7fffffffffffffff,,'
NETWORK_LTE_ONLY='AT^SYSCFGEX="03",3FFFFFFF,2,2,7fffffffffffffff,,'
NETWORK_LTE_UMTS='AT^SYSCFGEX="0302",3FFFFFFF,2,2,7fffffffffffffff,,'
NETWORK_LTE_GSM='AT^SYSCFGEX="0301",3FFFFFFF,2,2,7fffffffffffffff,,'
NETWORK_UMTS_GSM='AT^SYSCFGEX="0201",3FFFFFFF,2,2,7fffffffffffffff,,'

CONF_FILE="/var/radio_mode"

# Mode caching to prevent menu slowdowns
if [[ ! -f "$CONF_FILE" ]]
then
    CURRENT_MODE="$(atc 'AT^SYSCFGEX?' | grep 'SYSCFGEX' | sed 's/^[^"]*"\([^"]*\)".*/\1/')"
    echo $CURRENT_MODE > $CONF_FILE
else
    CURRENT_MODE="$(cat $CONF_FILE)"
fi

echo $CURRENT_MODE

if [[ "$1" == "get" ]]
then
    [[ "$CURRENT_MODE" == "00" ]]   && exit 0
    [[ "$CURRENT_MODE" == "01" ]]   && exit 1
    [[ "$CURRENT_MODE" == "02" ]]   && exit 2
    [[ "$CURRENT_MODE" == "03" ]]   && exit 3
    [[ "$CURRENT_MODE" == "0302" ]] && exit 4
    [[ "$CURRENT_MODE" == "0301" ]] && exit 5
    [[ "$CURRENT_MODE" == "0201" ]] && exit 6

    # error
    exit 255
fi

if [[ "$1" == "set_next" ]]
then
    [[ "$CURRENT_MODE" == "00" ]]   && atc "$NETWORK_GSM_ONLY" && echo 01 > $CONF_FILE
    [[ "$CURRENT_MODE" == "01" ]]   && atc "$NETWORK_UMTS_ONLY" && echo 02 > $CONF_FILE
    [[ "$CURRENT_MODE" == "02" ]]   && atc "$NETWORK_LTE_ONLY" && echo 03 > $CONF_FILE
    [[ "$CURRENT_MODE" == "03" ]]   && atc "$NETWORK_LTE_UMTS" && echo 0302 > $CONF_FILE
    [[ "$CURRENT_MODE" == "0302" ]] && atc "$NETWORK_LTE_GSM" && echo 0301 > $CONF_FILE
    [[ "$CURRENT_MODE" == "0301" ]] && atc "$NETWORK_UMTS_GSM" && echo 0201 > $CONF_FILE
    [[ "$CURRENT_MODE" == "0201" ]] && atc "$NETWORK_AUTO" && echo 00 > $CONF_FILE
    sleep 3
fi
