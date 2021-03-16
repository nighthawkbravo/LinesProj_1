
# QEMU on fresh Ubuntu
# based on https://linuxize.com/post/how-to-install-kvm-on-ubuntu-20-04/

## Install deps
sudo apt install qemu qemu-utils qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager

## Add user to groups
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

## Enabling external access to QEMU guests

The key to making it work is to enable "host-to-guest networking" in QEMU.
Read this https://apiraino.github.io/qemu-bridge-networking/

# In /etc/sysctl.conf
net.ipv4.ip_forward = 1

# Give bridge-helper suid rights
chmod u+s /usr/lib/qemu/qemu-bridge-helper

# Embedded env

## Install deps
sudo apt install make g++ libncurses-dev unzip

## Get buildroot
wget https://buildroot.org/downloads/buildroot-2021.02.tar.bz2

## Starting and logging to QEMU instance
./output/images/start-qemu.sh

By default on buildroot there is no password for root user.

ctrl a c - switch to qemu monitor
info network to get name of network
ip link - to check carrier
poweroff - shell command to "power off" the virtual machine

## Filesystem layout
Layout (directory structure) of the target filesystem is defined in two places;
one surives the "make clean" (system/skeleton), one which does not (output/target).
Use the 'skeleton' for permament, tested deployments. Use 'target' for short-term
testing but remember not to run `make clean` or you'll loose anything placed there.

## Copy project files

export BRDIR=<dir with buildroot>
export LUC_DIR=<dir with my customizations>

mkdir -p $BRDIR/system/skeleton/etc/network/if-up.d/
cp $LUC_DIR/.config $BRDIR/
cp $LUC_DIR/S92lucas $BRDIR/system/skeleton/etc/init.d/
cp $LUC_DIR/downloader.pl $BRDIR/system/skeleton/root/
cp $LUC_DIR/timesync $BRDIR/system/skeleton/etc/network/if-up.d/
cp $LUC_DIR/user_accounts.txt $BRDIR/board/aarch64-efi/

## What are various files for...

downloader.pl - a silly Perl script that downloads a random package off the web and unpacks it
S92lucas - it runs our programs on startup such as downloader.pl
/etc/network/ - place for scripts responsible for configuring the network
timesync - lives under '/etc/network/if-up' to detect cable was plugged; it syncs the local time with NTP server
user_accounts.txt - stores user-accounts to create, otherwise only 'root'

# Other resources

Great article on how QEMU bridge networking works:
https://apiraino.github.io/qemu-bridge-networking/
