#!/bin/sh

# name of the Buildroot package
BR_PKG="buildroot-2021.02"

# nothing needs changing below

PRJ_ROOT=$PWD
WORK_DIR=tmp_work
BRDIR=$BR_PKG

echo "Running..."
$PRJ_ROOT/$WORK_DIR/$BRDIR/output/images/start-qemu.sh
