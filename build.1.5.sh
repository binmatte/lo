#!/bin/bash

################################################################################################
################################################################################################

# shellcheck disable=SC2155
# shellcheck disable=SC2086
# shellcheck disable=SC2164
# shellcheck disable=SC2046
# shellcheck disable=SC2006

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

cd $LO_HOME/source/m4-1.4.19
./configure \
	--prefix=/usr \
	--host=$LO_TARGET \
	--silent \
	--quiet \
	--build=$(build-aux/config.guess)
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null

cd $LO_HOME/source/ncurses-6.5
sed -i s/mawk// configure
mkdir -p build
pushd build
	../configure \
		--silent \
		--quiet
	make -C include > /dev/null
	make -C progs tic > /dev/null
popd
./configure \
	--prefix=/usr \
	--host=$LO_TARGET \
	--build=$(./config.guess) \
	--mandir=/usr/share/man \
	--with-manpage-format=normal \
	--with-shared \
	--without-normal \
	--with-cxx-shared \
	--without-debug \
	--without-ada \
	--disable-stripping \
	--enable-widec \
	--silent \
	--quiet
make > /dev/null && make DESTDIR=$LO_HOME TIC_PATH=$(pwd)/build/progs/tic install > /dev/null
ln -sv libncursesw.so $LO_HOME/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' -i $LO_HOME/usr/include/curses.h

cd $LO_HOME/source/bash-5.2.21
./configure \
	--prefix=/usr \
	--build=$(sh support/config.guess) \
	--host=$LO_TARGET \
	--without-bash-malloc \
	--silent \
	--quiet \
	bash_cv_strtold_broken=no
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null
ln -s bash $LO_HOME/bin/sh

cd $LO_HOME/source/coreutils-9.5
./configure \
	--prefix=/usr \
	--host=$LO_TARGET \
	--build=$(build-aux/config.guess) \
	--enable-install-program=hostname \
	--enable-no-install-program=kill,uptime \
	--silent \
	--quiet
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null
mv $LO_HOME/usr/bin/chroot $LO_HOME/usr/sbin
mkdir -p $LO_HOME/usr/share/man/man8
mv $LO_HOME/usr/share/man/man1/chroot.1 $LO_HOME/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' $LO_HOME/usr/share/man/man8/chroot.8

cd $LO_HOME/source/diffutils-3.10
./configure \
	--prefix=/usr \
	--host=$LO_TARGET \
	--quiet \
	--silent \
	--build=$(./build-aux/config.guess)
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null

cd $LO_HOME/source/file-5.45
mkdir -p build
pushd build
	../configure \
		--silent \
		--quiet \
		--disable-bzlib \
		--disable-libseccomp \
		--disable-xzlib \
		--disable-zlib
	  make > /dev/null
popd
./configure \
	--prefix=/usr \
	--host=$LO_TARGET \
	--quiet \
	--silent \
	--build=$(./config.guess)
make FILE_COMPILE=$(pwd)/build/src/file > /dev/null && make DESTDIR=$LO_HOME install > /dev/null
rm $LO_HOME/usr/lib/libmagic.la

cd $LO_HOME/source/findutils-4.10.0
./configure \
	--prefix=/usr \
	--quiet \
	--silent \
	--localstatedir=/var/lib/locate \
	--host=$LO_TARGET \
	--build=$(build-aux/config.guess)
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null

cd $LO_HOME/source/gawk-5.3.0
sed -i 's/extras//' Makefile.in
./configure \
	--prefix=/usr \
	--host=$LO_TARGET \
	--quiet \
	--silent \
	--build=$(build-aux/config.guess)
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null

cd $LO_HOME/source/grep-3.11
./configure \
	--prefix=/usr \
	--host=$LO_TARGET \
	--quiet \
	--silent \
	--build=$(./build-aux/config.guess)
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null

cd $LO_HOME/source/gzip-1.13
./configure \
	--prefix=/usr \
	--quiet \
	--silent \
	--host=$LO_TARGET
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null

cd $LO_HOME/source/make-4.4.1
./configure \
	--prefix=/usr \
	--without-guile \
	--host=$LO_TARGET \
	--quiet \
	--silent \
	--build=$(build-aux/config.guess)
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null

cd $LO_HOME/source/patch-2.7.6
./configure \
	--prefix=/usr \
	--quiet \
	--silent \
	--host=$LO_TARGET \
	--build=$(build-aux/config.guess)
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null

cd $LO_HOME/source/sed-4.9
./configure \
	--prefix=/usr \
	--host=$LO_TARGET \
	--quiet \
	--silent \
	--build=$(./build-aux/config.guess)
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null

cd $LO_HOME/source/tar-1.35
./configure \
	--prefix=/usr \
	--host=$LO_TARGET \
	--quiet \
	--silent \
	--build=$(build-aux/config.guess)
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null

cd $LO_HOME/source/xz-5.6.2
./configure \
	--prefix=/usr \
	--quiet \
	--silent \
	--host=$LO_TARGET \
	--build=$(build-aux/config.guess) \
	--disable-static \
	--docdir=/usr/share/doc/xz-5.6.2
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null
rm $LO_HOME/usr/lib/liblzma.la


cd $LO_HOME/source/binutils-2.42
sed '6009s/$add_dir//' -i ltmain.sh
mkdir -p build2 && cd build2
../configure \
		--prefix=/usr \
		--build=$(../config.guess) \
		--host=$LO_TARGET \
		--disable-nls \
		--enable-shared \
		--quiet \
		--silent \
		--disable-werror \
		--enable-64-bit-bfd \
		--enable-default-hash-style=gnu
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null
rm $LO_HOME/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

cd $LO_HOME/source/gcc-14.1.0
sed '/thread_header =/s/@.*@/gthr-posix.h/' -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in
mkdir -p build3 && cd build3
../configure \
	--build=$(../config.guess) \
	--host=$LO_TARGET \
	--target=$LO_TARGET \
	LDFLAGS_FOR_TARGET=-L$PWD/$LO_TARGET/libgcc \
	--prefix=/usr \
	--with-build-sysroot=$LO_HOME \
	--enable-default-pie \
	--enable-default-ssp \
	--disable-nls \
	--disable-multilib \
	--disable-libatomic \
	--quiet \
	--silent \
	--disable-libgomp \
	--disable-libquadmath \
	--disable-libsanitizer \
	--disable-libssp \
	--disable-libvtv \
	--enable-languages=c,c++
make > /dev/null && make DESTDIR=$LO_HOME install > /dev/null
ln -s gcc $LO_HOME/usr/bin/cc
