#!/bin/bash

################################################################################################
################################################################################################

# shellcheck disable=SC2093

################################################################################################
################################################################################################

mkdir -p /{boot,home,mnt,opt,srv}
mkdir -p /etc/{opt,sysconfig}
mkdir -p /lib/firmware
mkdir -p /media/{floppy,cdrom}
mkdir -p /usr/{,local/}{include,src}
mkdir -p /usr/local/{bin,lib,sbin}
mkdir -p /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -p /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -p /usr/{,local/}share/man/man{1..8}
mkdir -p /var/{cache,local,log,mail,opt,spool}
mkdir -p /var/lib/{color,misc,locate}

ln -sf /run /var/run
ln -sf /run/lock /var/lock

################################################################################################
################################################################################################

ln -s /proc/self/mounts /etc/mtab

cat > /etc/hosts << "EOF"
127.0.0.1	localhost
127.0.1.1	lo
::1			localhost
::1			ip6-localhost ip6-loopback
fe00::0		ip6-localnet
ff00::0		ip6-mcastprefix
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters
EOF

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6::/dev/null:/usr/bin/false
uuidd:x:80:80::/dev/null:/usr/bin/false
nobody:x:65534:65534::/dev/null:/usr/bin/false
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
disk:x:8:
utmp:x:13:
adm:x:16:
input:x:24:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF

exec /usr/bin/bash --login

touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp utmp /var/log/lastlog
chmod 664  /var/log/lastlog
chmod 600  /var/log/btmp

################################################################################################
################################################################################################

