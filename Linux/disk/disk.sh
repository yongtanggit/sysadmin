#! /bin/bash

# This Program shows disk partition usage and gives warning when any partition is low 

alert=90 # set threshold

disk() {
  df -hP | grep -v 'Filesystem\|tmpfs' | awk '{print $6 " " $5}' # Use -P for portability,POSIX output format 
}


disk | while read; do
  fs=$(echo $REPLY | awk '{print $1}')
  use=$(echo $REPLY | awk '{print $2}' | awk -F "%" '{print $1}')
  [[ $use -ge $alert ]] && echo  " Warning, the $fs is ${use}%, which is nearly full."
  echo "Partition: $fs has used $use% space"
done
