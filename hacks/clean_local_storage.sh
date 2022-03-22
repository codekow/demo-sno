#!/bin/sh

clean_local_storage(){
  oc delete project openshift-local-storage
  oc api-resources --api-group=local.storage.openshift.io -o name | xargs -n1 oc delete crd
  #oc debug node/sno -- chroot /host  wipefs -af /dev/sdb
  oc debug node/sno -- chroot /host  rm -rf /mnt/local-storage
  oc delete sc local-block
  oc delete sc local-fs
  oc delete pv --all
}

clean_local_storage
