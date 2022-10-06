# Single Node OpenShift (SNO) - Storage

Using the local storage operator you can have persistent storage available for SNO

## Create storage for SNO VM
```
# os disk (sda)
qemu-img create -f qcow2 /srv/libvirt/images/sno1_disk1.qcow2 120G

# local pvs (sdb)
qemu-img create -f qcow2 /srv/libvirt/images/sno1_disk2.qcow2 350G
```

## Setup `oc` from dump dir
```
export KUBECONFIG=$(pwd)/dump/sno/auth/kubeconfig
```

## Setup storage for SNO
```
export NODE=sno1

# list disk / part
oc debug node/${NODE} -- chroot /host  lsblk -d
oc debug node/${NODE} -- chroot /host  lsblk

# pv parts
cat hacks/local_disk_setup.sh | oc debug node/${NODE} -- chroot /host  bash -c "DISK=/dev/sdb $(cat -)"

# install local storage operator
oc apply -k catalog/openshift-local-storage/operator/overlays/stable

# setup storage objects
oc apply -f config
```

## Other commands
```
# reset pv
oc delete pv --all

# other part example
#oc debug node/sno -- chroot /host  sgdisk -n "0:0:+100G" -c 0:"PV Local Disk" /dev/sdc
```

## Setup registry
```
# check storage class
oc get sc

# setup registry operator
oc patch configs.imageregistry.operator.openshift.io/cluster --type=merge -p '{"spec":{"rolloutStrategy":"Recreate","replicas":1}}'
oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"managementState":"Managed"}}'
oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"storage":{"pvc":{"claim": "image-registry-storage"}}}}'
```

# Links
- https://github.com/openshift/local-storage-operator/blob/master/docs/deploy-with-olm.md
