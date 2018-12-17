These scripts setup TUN/TAP Masquerading (NAT) and handle OpenVPN pushed DNS servers.
Use them from OpenVPN client configuration file with --up and --down directives.

Proper setup is as follows:

script-security 2
up /system/bin/openvpn_scripts/client.up
down /system/bin/openvpn_scripts/client.down
up-restart

Do not use persist-tun!

See also: /app/bin/oled_hijack/net.{down,up}
