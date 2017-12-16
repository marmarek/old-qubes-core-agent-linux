#!/bin/sh

# Possibly resize root device (partition, filesystem), if underlying device was
# enlarged.

set -e

# if underlying root device is read-only, don't do anything
if [ "$(blockdev --getro /dev/xvda)" -eq "1" ]; then
    echo "xvda is read-only, not resizing" >&2
    exit 0
fi

sysfs_root_dev="/sys/dev/block/$(mountpoint -d /)"
sysfs_xvda="/sys/class/block/xvda"

# if root filesystem use already (almost) the whole dis
non_rootfs_data=$(( 250 * 1024 * 2 ))
if [ "$(cat "$sysfs_xvda/size")" -lt \
       $(( non_rootfs_data + $(cat "$sysfs_root_dev/size") )) ]; then
   echo "root filesystem already at the right size" >&2
   exit 0
fi

# resize needed, do it
/usr/lib/qubes/resize-rootfs
