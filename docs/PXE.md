# PXE Notes


## Setup `oc` on bootstrap
```
export KUBECONFIG=/etc/kubernetes/bootstrap-secrets/kubeconfig
watch 'oc get co; oc get node'
```

## Create SNO bootstrap
[SNO install config](install-config.yaml)
```
cd dump
mkdir sno

# download installer
../hacks/download_installer.sh

# create ignition
cp install-config.yaml sno/
./openshift-install create single-node-ignition-config --dir=sno
cat sno/bootstrap-in-place-for-live-iso.ign | jq . > sno-bootstrap.ign
```

## Dump ignition files
```
# dump master ign
oc extract secrets/master-user-data -n openshift-machine-api --keys=userData --to=- | jq . > master.ign

# dump worker ign
oc extract secrets/master-user-data -n openshift-machine-api --keys=userData --to=- | jq . > worker.ign
```

## Download RHCOS files
```
cd dump
../ipxe/update_files.sh
```

## iPXE example config

- [example.ipxe](../ipxe/example.ipxe)

# Links
- https://docs.openshift.com/container-platform/4.10/installing/installing_bare_metal/installing-restricted-networks-bare-metal.html#installation-user-infra-machines-pxe_installing-restricted-networks-bare-metal
