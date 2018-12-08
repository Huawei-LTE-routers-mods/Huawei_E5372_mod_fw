#!/bin/ash
# Switch to Entware shell if Entware is installed
# This is important and prevents various strange issues
# since stock (non-Entware) busybox is compiled with
# build-in applet loading technique and does not require
# symlinks installed.
if [ -f /opt/bin/busybox ];
then
    echo "Switching to Entware shell"
    exec /opt/bin/sh -l
else
    exec /bin/ash -l
fi
