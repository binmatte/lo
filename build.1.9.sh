#!/bin/bash

################################################################################################
################################################################################################

# shellcheck disable=SC2155
# shellcheck disable=SC2086

################################################################################################
################################################################################################

set +h
umask 022

export LO_HOME=$HOME/lo
export LO_TARGET=x86_64-lo-linux-gnu
export LC_ALL=POSIX

export MAKEFLAGS=-j$(nproc)

PATH=/usr/bin
if [ ! -L /bin ]; then
	PATH=/bin:$PATH;
fi

export PATH=$LO_HOME/tools/bin:$PATH
export CONFIG_SITE=$LO_HOME/usr/share/config.site

################################################################################################
################################################################################################

sudo chown -R root:root $LO_HOME/{usr,lib,lib64,var,etc,bin,sbin,tools}

################################################################################################
################################################################################################

sudo mount --bind /dev $LO_HOME/dev
sudo mount -t devpts devpts -o gid=5,mode=0620 $LO_HOME/dev/pts
sudo mount -t proc proc $LO_HOME/proc
sudo mount -t sysfs sysfs $LO_HOME/sys
sudo mount -t tmpfs tmpfs $LO_HOME/run

if [ -h $LO_HOME/dev/shm ]; then
	sudo install -d -m 1777 $LO_HOME/dev/shm
else
	sudo mount -t tmpfs -o nosuid,nodev tmpfs $LO_HOME/dev/shm
fi

################################################################################################
################################################################################################

sudo chroot "$LO_HOME" /usr/bin/env -i \
	HOME=/root \
	TERM="$TERM" \
	PS1='\u:\w\$ ' \
	PATH=/usr/bin:/usr/sbin \
	MAKEFLAGS="-j$(nproc)" \
	TESTSUITEFLAGS="-j$(nproc)" \
	/bin/bash --login