Huawei E5372 LTE router custom firmware
=======================================

Huawei E5372 firmware repository. Check available branches.

Current version: 21.290.23.00.00

**Check [releases page](https://github.com/Huawei-LTE-routers-mods/Huawei_E5372_mod_fw/releases) for the firmware file.**

---------------------------------------

The firmware is based on the original global firmware version 21.290.23.00.00. It could be installed on any previous firmware (unless you have locked bootloader, but there's workaround), or updated from a modified firmware.

Flash using balongflash ([Windows](https://github.com/forth32/balongflash/tree/master/winbuild/Release), [Linux](https://github.com/forth32/balongflash/)).

#### Warning!
This firmware can render your device unbootable! Use it only if you are aware of all the risks and consequences. In case of any problems, do not wait for help, you're on your own. Do not install firmware by non-tech-savvy people request, and do not sell routers with this firmware preinstalled.

### Changes:

* Disabled firmware digital signature verification in the firmware server
* Added support for IPv6 on mobile networks (disabled by default, could be activated with "ipv6" script)
* ADB installed and Telnet activated (disabled by default, controlled from OLED menu)
* Stock versions of busybox, iptables and ip6tables programs replaced with full-fledged ones
* Added "atc" utility to send AT commands from the console
* Added "ttl" script to modify (fix) TTL (for IPv4) and HL (for IPv6)
* Added "imei" script to change IMEI
* Added local transparent proxy server "tpws" and a script "anticensorship" are installed to circumvent censorship to sites from the registry of prohibited sites in Russian Federation (IPv4 only)
* Added Stubby DNS over TLS resolver (version 1.5.2, compiled with OpenSSL 1.0.2t) and DNS-level adblock (IPv4 only)
* Added [extended menu on OLED screen](https://github.com/ValdikSS/huawei_oled_hijack)
* AT^DATALOCK code is disabled
* Added kernel module TUN/TAP (for OpenVPN and other programs)
* Added OpenVPN (version 2.4.8, compiled with OpenSSL 1.0.2t) and scripts for DNS redirection
* Added curl (version 7.67.0, compiled with OpenSSL 1.0.2t)
* Added EXT4 kernel module and swap support
* Added script for installing Entware application repository
* Added script "adblock_update", for updating the list of advertising domains
