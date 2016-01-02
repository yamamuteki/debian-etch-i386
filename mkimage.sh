#!/bin/sh

# This script make a Docker image of the Debian 4.0 etch (i386).
# Please run as root via sudo on your Debian machine (Not docker container as AWS EC2).
# Reference: http://hatyuki.hatenablog.jp/entry/2014/11/20/135728
cd /tmp
apt-get update
apt-get install -y git debootstrap

# Fix version for following patch.
git clone --depth 1 -b v1.9.1 https://github.com/docker/docker.git
cd docker/contrib

# Change comment from # to // in apt conf files for syntax error.
sed -i -e "232a [ -d \"\$rootfsDir/etc/apt/apt.conf.d\" ] && sed -i -e 's/#/\\\/\\\//' \$rootfsDir/etc/apt/apt.conf.d/*" mkimage/debootstrap

# Update /etc/apt/sources.list.
sed -i -e "232a echo \"deb http://archive.debian.org/debian/ etch main\"> \$rootfsDir/etc/apt/sources.list" mkimage/debootstrap

# CAUTION: No check PGP because expired CA certificate.
./mkimage.sh -d "../../" debootstrap --no-check-gpg --verbose --variant=minbase --include=iproute --arch=i386 etch http://archive.debian.org/debian/

