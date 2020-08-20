#! /bin/bash
## This program removes VMs and their image files on RHEL(CentOS 7) host.

usage(){
cat <<eof
Usage: vmkill.sh <enter> to select VM to kill
       vmkill.sh -a <enter> to kill them all!
eof
}

img_path='/var/lib/libvirt/images/'

vsh=$(which virsh)

uid=$(id -u)
[[ $uid != 0  ]] && echo "Only root can run this program, quit.." \
&& exit 1


## Only Accept One Option "-a"
[[ $# -gt 1 ]] && usage &&  exit 2

if [[ $1 != '-a' ]] &&  [[ $# -eq 1 ]]; then 
  usage 
  exit 6
fi 
## Without Option, Ask User to Provide VM's Name 
if [[ $# -eq 0 ]]; then 
      $vsh list --all
      read -p "Please enter the VM name to kill or <enter> to quit: " vm
      [[ "$vm" == '' ]] && exit 0
      # pipe produced a new shell, the following commands should be grouped
      $vsh list --all | { while read i; do
           i=$(echo $i | awk '{print $2}')
           if [[ "$i" == "$vm" ]]; then
              echo ${img_path}$vm
              $vsh destroy $vm
              $vsh undefine $vm
              rm -rf ${img_path}$vm.*
              found=y
              break
           fi
           done 
           # check the result  
           if [[ "$found" != y ]]; then
             echo "Error: $vm not found"
             exit 3
           else
             $vsh list --all | while read dead; do
                 dead=$(echo $dead | awk '{print $2}')
                 if [[ "$dead" == "$vm" ]]; then
                   echo "$vm is killed but in transient state!! Reboot the host to recycle it completely."
                   exit 4
                 fi
             done
          fi }
fi

## Option "-a"

if [[ $1 == '-a' ]]; then
   echo "WARNING: This program will remove all installed VMs!"
   read -p "Type YES to proceed, any other key to quit: " 
   [[ $REPLY != YES ]] && echo "Not proceeding, quit" && exit 
   virsh list --all | while read i; do
     i=$(echo $i | awk '{print $2}')
     virsh destroy $i 
     virsh undefine $i
   done  
   rm -rf /var/lib/libvirt/images/*
   # check the result
   all=$(virsh list --all | wc -l)
   if [[ $all -ne 3 ]]; then 
      echo "Not  all VM are recycled. If any VM is in transient state, reboot the host to recycle it completely." 
      exit 5
   fi
fi




