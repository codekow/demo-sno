#!/bin/sh
#
# update files from the internet

#download_url="https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.9/latest"
download_url="https://mirror.openshift.com/pub/openshift-v4/amd64/clients/ocp/stable-4.9"
download_list="sha256sum.txt openshift-install-linux.tar.gz"

for file in $download_list
do
    wget -N "${download_url}/${file}"
done

sha256sum --ignore-missing -c sha256sum.txt
tar vzxf openshift-install-linux.tar.gz

rm ${download_list}
