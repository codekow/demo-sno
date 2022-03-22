#!/bin/bash
#set -x

DISK=${1:-$DISK}
CMD="sgdisk"

[ -e "${DISK}" ] || exit 1
#DISK_SIZE=$(( $(grep ${DISK#/dev/} /proc/partitions | awk '{print $3}') / 1024 / 1024 ))
echo "using disk: $DISK"
echo "WARNING: waiting 10s to WIPE DISK!"
sleep 10

print_disk(){
  kpartx "${DISK}"
  ${CMD} -p "${DISK}"
}

clear_disk(){
  wipefs -a "${DISK}"
  ${CMD} -o "${DISK}"
  kpartx "${DISK}"
}

create_part(){
 SIZE=$1
 ${CMD} -n "0:0:${SIZE}" -c 0:"PV Local Disk" "${DISK}"
}


setup_pv(){
  NUM=${1}
  SIZE=+${2}
  #PERCENT=$(( $NUM * $SIZE * 100 / $DISK_SIZE ))
  
  echo "partition(s): ${NUM}"
  echo "size: ${SIZE}"

  for i in $(seq "${NUM}");
  do
    create_part "${SIZE}" || break
  done
}

setup_disk(){
  setup_pv 1 100G
  setup_pv 2 40G
  setup_pv 3 20G
  setup_pv 8 10G
  setup_pv 10 2G
  setup_pv 50 1G
}

print_disk

clear_disk
setup_disk

print_disk

