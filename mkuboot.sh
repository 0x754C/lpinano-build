#!/usr/bin/env bash

mkdir -p build

if [ -z "$URL" ]
then
	export URL="https://github.com/u-boot/u-boot"
fi

if [ -z "$BRANCH" ]
then
	export BRANCH="master"
fi

if [ -z "$CROSS_COMPILE" ]
then
	export CROSS_COMPILE="arm-linux-gnueabi-"
fi

set -eux

if [ ! -e build/uboot ] 
then
	git clone $URL build/uboot --branch=${BRANCH}
	cd build/uboot
	find ../../uboot/ -name *.patch | sort | while read line
	do
		patch -p1 < $line
	done
	cd ../../
fi

cd build/uboot
export ARCH=arm
make clean
make licheepi_nano_defconfig
make -j$(nproc)
cp u-boot-sunxi-with-spl.bin ../
