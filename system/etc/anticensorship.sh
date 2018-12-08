#!/system/bin/busybox sh

# Currently supports only IPv4 as there's no IPv6 NAT support in Huawei kernel.

CFILE="/data/userdata/anticensorship"
CPORT="12831"
DNSDNAT="77.88.8.8:1253"

if [[ -f "$CFILE" ]];
then
    AC_ENABLED="$(cat $CFILE)"
else
    AC_ENABLED="0"
fi

function ac_disable {
    killall tpws
    xtables-multi iptables -t nat -D PREROUTING -i br0 -p tcp --dport 80 -j ANTICENSORSHIP
    xtables-multi iptables -t nat -D PREROUTING -i br0 -p tcp --dport 443 -j ANTICENSORSHIP
    xtables-multi iptables -t nat -D OUTPUT -o wan0 -j ANTICEN_DNS
    xtables-multi ip6tables -D OUTPUT -o wan0 -j ANTICEN_DNS
}

function ac_enable {
    iptables -t nat -C PREROUTING -i br0 -p tcp --dport 80 -j REDIRECT --to "$CPORT" &> /dev/null
    if [[ "$?" == "0" ]];
    then
        echo "Anticensorship already running!"
        exit 1
    fi
    
    iptables -t nat -nL ANTICENSORSHIP &> /dev/null
    if [[ "$?" != "0" ]]
    then
        xtables-multi iptables -t nat -N ANTICENSORSHIP
        xtables-multi iptables -t nat -A ANTICENSORSHIP -d 0.0.0.0/8 -j RETURN
        xtables-multi iptables -t nat -A ANTICENSORSHIP -d 10.0.0.0/8 -j RETURN
        xtables-multi iptables -t nat -A ANTICENSORSHIP -d 127.0.0.0/8 -j RETURN
        xtables-multi iptables -t nat -A ANTICENSORSHIP -d 169.254.0.0/16 -j RETURN
        xtables-multi iptables -t nat -A ANTICENSORSHIP -d 172.16.0.0/12 -j RETURN
        xtables-multi iptables -t nat -A ANTICENSORSHIP -d 192.168.0.0/16 -j RETURN
        xtables-multi iptables -t nat -A ANTICENSORSHIP -d 224.0.0.0/4 -j RETURN
        xtables-multi iptables -t nat -A ANTICENSORSHIP -d 240.0.0.0/4 -j RETURN
        xtables-multi iptables -t nat -A ANTICENSORSHIP -p tcp -j REDIRECT --to-ports "$CPORT"

        xtables-multi iptables -t nat -N ANTICEN_DNS
        xtables-multi iptables -t nat -I ANTICEN_DNS -p udp --dport 53 -m u32 --u32 '0x1C&0xFA00=0 && 0x22=0' -j DNAT --to "$DNSDNAT"
        xtables-multi iptables -t nat -I ANTICEN_DNS -p tcp --dport 53 -m u32 --u32 '0x1C&0xFA00=0 && 0x22=0' -j DNAT --to "$DNSDNAT"

        xtables-multi ip6tables -N ANTICEN_DNS
        xtables-multi ip6tables -I ANTICEN_DNS -p udp --dport 53 -m u32 --u32 '0x30&0xFA00=0 && 0x36=0' -j DROP
        xtables-multi ip6tables -I ANTICEN_DNS -p tcp --dport 53 -m u32 --u32 '0x30&0xFA00=0 && 0x36=0' -j REJECT
    fi

    ulimit -n 4096
    tpws --daemon --port "$CPORT" --split-pos 2 --hostcase --hostspell hoSt --hostnospace
    # Redirect HTTP and HTTPS traffic to transparent anticensorship proxy.
    xtables-multi iptables -t nat -I PREROUTING -i br0 -p tcp --dport 80 -j ANTICENSORSHIP
    xtables-multi iptables -t nat -I PREROUTING -i br0 -p tcp --dport 443 -j ANTICENSORSHIP
    # Redirect DNS requests to Yandex DNS on port 1253.
    xtables-multi iptables -t nat -I OUTPUT -o wan0 -j ANTICEN_DNS
    xtables-multi ip6tables -I OUTPUT -o wan0 -j ANTICEN_DNS
}

if [[ "$1" == "0" ]];
# Force-off
then
    ac_disable

elif [[ "$1" == "1" ]] || [[ "$AC_ENABLED" == "1" ]];
then
    ac_disable
    ac_enable
fi
