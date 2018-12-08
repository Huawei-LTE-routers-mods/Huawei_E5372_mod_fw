#!/system/bin/busybox sh

# This wrapper calls "fix_ttl.sh 2" to permit FORWARDed traffic
# when "ip[6]tables -t mangle -F" is called by /app/bin/npdaemon.
# Calling "fix_ttl.sh 2" in autorun causes race condition.

/system/bin/${0##*/}.orig "$@"
RETCODE="$?"

if [[ "$1" == "-t" ]] && [[ "$3" == "-F" ]];
then
    if [[ "$2" == "mangle" ]];
    then
        /etc/fix_ttl.sh 2
    elif [[ "$2" == "nat" ]];
    then
        /etc/anticensorship.sh
        /etc/adblock.sh
    fi
fi

exit "$RETCODE"
