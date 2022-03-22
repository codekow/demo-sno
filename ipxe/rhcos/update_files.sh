#!/bin/sh
#
# update files from the internet

#download_url="https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.9/latest"
download_url="https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/latest"
download_list="sha256sum.txt rhcos-installer-kernel-x86_64 rhcos-installer-initramfs.x86_64.img rhcos-installer-rootfs.x86_64.img"

for file in $download_list
do
    wget -N "${download_url}/${file}"
done

sha256sum --ignore-missing -c sha256sum.txt
