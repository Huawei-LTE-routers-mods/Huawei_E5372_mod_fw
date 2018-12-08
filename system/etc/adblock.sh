#!/system/bin/busybox sh

# Currently supports only IPv4 as there's no IPv6 NAT support in Huawei kernel.
# Outgoing IPv6 DNS queries are dropped if performed by the device itself (i.e. if the user uses on-device DNS).
# IPv6 DNS queries to other IPv6 addresses from users still work, as well as IPv6 queries to the device' IPv6 DNS.

CFILE="/data/userdata/adblock"
CPORT="5353"

if [[ -f "$CFILE" ]];
then
    AB_ENABLED="$(cat $CFILE)"
else
    AB_ENABLED="0"
fi

function ab_disable {
    pkill dnsmasq
    xtables-multi iptables -t nat -D PREROUTING -i br0 -p udp --dport 53 -m u32 --u32 '0x1C&0xFA00=0 && 0x22=0' -j REDIRECT --to "$CPORT"
    xtables-multi iptables -t nat -D PREROUTING -i br0 -p tcp --dport 53 -m u32 --u32 '0x1C&0xFA00=0 && 0x22=0' -j REDIRECT --to "$CPORT"
    xtables-multi ip6tables -D OUTPUT -o wan0 -j ADBLOCK_DNS
}

function ab_enable {
    xtables-multi iptables -t nat -C PREROUTING -i br0 -p udp --dport 53 -m u32 --u32 '0x1C&0xFA00=0 && 0x22=0' -j REDIRECT --to "$CPORT" &> /dev/null
    if [[ "$?" == "0" ]];
    then
        echo "Adblock already running!"
        exit 1
    fi

    dnsmasq
    xtables-multi iptables -t nat -I PREROUTING -i br0 -p udp --dport 53 -m u32 --u32 '0x1C&0xFA00=0 && 0x22=0' -j REDIRECT --to "$CPORT"
    xtables-multi iptables -t nat -I PREROUTING -i br0 -p tcp --dport 53 -m u32 --u32 '0x1C&0xFA00=0 && 0x22=0' -j REDIRECT --to "$CPORT"
    # Block IPv6 DNS queries to force IPv4-only DNS
    xtables-multi ip6tables -N ADBLOCK_DNS
    xtables-multi ip6tables -F ADBLOCK_DNS
    xtables-multi ip6tables -I ADBLOCK_DNS -p udp --dport 53 -m u32 --u32 '0x30&0xFA00=0 && 0x36=0' -j DROP
    xtables-multi ip6tables -I ADBLOCK_DNS -p tcp --dport 53 -m u32 --u32 '0x30&0xFA00=0 && 0x36=0' -j REJECT
    xtables-multi ip6tables -I OUTPUT -o wan0 -j ADBLOCK_DNS
}

if [[ "$1" == "0" ]];
# Force-off
then
    ab_disable

elif [[ "$1" == "1" ]] || [[ "$AB_ENABLED" == "1" ]];
then
    ab_disable
    ab_enable
fi
