#!/bin/sh
set -x # stop on any error
set -e # print what's going on


echo "Building..."
# name of the Buildroot package
BR_PKG="buildroot-2021.02"

# nothing needs changing below
PRJ_ROOT=$PWD
WORK_DIR=tmp_work

BUILDROOT_ARCHIVE="https://buildroot.org/downloads/${BR_PKG}.tar.bz2"

mkdir $PRJ_ROOT/$WORK_DIR
cd $PRJ_ROOT/$WORK_DIR

## Get buildroot
wget $BUILDROOT_ARCHIVE
tar jxvf ${BR_PKG}.tar.bz2
BRDIR=$BR_PKG

mkdir -p $BRDIR/system/skeleton/etc/network/if-up.d
mkdir -p $BRDIR/system/skeleton/etc/init.d

cp $PRJ_ROOT/.config $BRDIR/
cp $PRJ_ROOT/S92lucas $BRDIR/system/skeleton/etc/init.d/
cp $PRJ_ROOT/downloader.pl $BRDIR/system/skeleton/root/
cp $PRJ_ROOT/timesync $BRDIR/system/skeleton/etc/network/if-up.d/
cp $PRJ_ROOT/user_accounts.txt $BRDIR/board/aarch64-efi/

echo "Making..."
cd $PRJ_ROOT/$WORK_DIR/$BRDIR
time make -j$(nproc)
