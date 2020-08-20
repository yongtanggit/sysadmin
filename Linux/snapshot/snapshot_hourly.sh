#!/bin/bash

## This program takes a snapshot of a directory by hour.    

## File Locations: 1)Mount device 2)Mount Point ##

src='/home/student/scripting/test/src/'
snpsht='/home/student/scripting/test/tgt/snapshots'

device='/home/student/scripting/test/snapshot.iso'

## make sure running as root ##
is_root(){
   uid=$(id -u)
   if [[ "$uid" -ne 0 ]]; then
     echo "Need to Be a Root User to Run This Program, Existing.." 
     exit 1
   fi
} 

# attempt to remount the RW mount point as RW; else abort
mount_rw(){
   if [[ $(df -P | grep "$snpsht") ]]; then 
      mount  -o loop,remount,rw $device $snpsht
   else
      mount -o loop,rw $device $snpsht
   fi
   #echo "\$?: $?"
   if [[ $? -ne 0 ]]; then 
     echo "Not mounted"
     exit 1
   fi
} 

#rotate snapshots of /home 
rotate(){
   # 1) delete the oldest snapshot, if it exits
   [[ -d "$snpsht"/hourly.3 ]] && rm -rf $snpsht/hourly.3
   # 2) shift the middle snapshots back by one, if it exits
   [[ -d "$snpsht"/hourly.2 ]] && mv $snpsht/hourly.2 $snpsht/hourly.3
   [[ -d "$snpsht"/hourly.1 ]] && mv $snpsht/hourly.1 $snpsht/hourly.2
   # 3) make a hard-link-only copy of the latst snapshot
   [[ -d "$snpsht"/hourly.0 ]] && cp -al $snpsht/hourly.0 $snpsht/hourly.1
}

# 4) rsync from the system into the latest snapshot
ryn(){
   rsync -av --delete $src $snpsht/hourly.0 
   # 5) update the mtime of hourly.0 to reflect the snapshot time
   touch $snpsht/hourly.0
}

# remount the mount point as a readonly 

mount_ro(){
   mount -o loop,remount,ro $device $snpsht
}

# Main Program
is_root
mount_rw
rotate
ryn
mount_ro











