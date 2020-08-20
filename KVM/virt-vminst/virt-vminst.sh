#! /bin/bash
## This program is a wrapper of virsh-install command.
## It provides --prompt mode installlatin, which is not supported by RHEL7

## Check Root Privilege 
uid=$(id -u)
if [[ $uid != 0 ]]; then 
 echo "Only root can run this program" >&2
 exit 1
fi

## VM's Name
while :; do
 read -p "Input VM's name: " name
 [[ $name == '' ]] && continue
 break
done

## RAM Size 
re='^[0-9]+$'
while :; do
 read -p "Input VM's ram size(MB): " ram_size
 # Check input is number
 if [[ $ram_size =~ $re ]];then 
 break
 else
 echo "error: Not a number" && continue
 fi
done

## Disk 
# Size
# Input Must Be Digits
while :; do
 read -p "Input the disk size(GB): " disk_size
 if [[ "$disk_size" =~ ^[0-9]+$ ]]; then
 break
 else
 continue
 fi
done
# Path
# This is default path, this program does not allow 
# user to change it
disk_path=/var/lib/libvirt/images/${name}.img


## os-variant
# Only RHEL6 and RHEL7 Acceptable
while :; do 
 read -p "Please select os-variant: 6 for rhel6, 7 for rhel7: " os_variant
 case $os_variant in
 '6' ) os_variant='rhel6' && break;;
 '7' ) os_variant='rhel7' && break;; 
 * ) continue;;
 esac
done

## Network Option
# Bridged Network
while :; do 
 read -p "Is the network is bridged?[Y/N]: " is_br
 if [[ $is_br == 'Y' || $is_br == 'N' ]]; then
   break
 else
   continue
 fi
done

if [[ $is_br == 'Y' ]]; then
  while :; do
    echo "please select a PHYSICAL bridge interface: "
    brctl show # use brctl command to show all bridge interfaces in host
    read -p "-->: " net_bridge
    # Check the input if a pulbic bridge or not
    brctl show | grep ^$net_bridge | grep -e eth.*$ -e enp.*$ >/dev/null 2>& 1
    if [[ $? != 0 ]]; then
      echo "ERROR: \"$net_bridge\" not found or not a physical bridge" 
      continue
    else
      break
    fi
  done
  network="bridge:$net_bridge"
# virtual Network
else 
 while :; do
   echo "please select a virtual network below, select default network by pressing enter" 
   # use virsh net-list to show all virtual networks in host
   virsh net-list --all 
   read -p "-->: " net_virtual
   [[ "$net_virtual" == '' ]] && net_virtual='default' && break
   # check the input exists 
   [[ "$net_virtual" != '' ]] && virsh net-list --all | grep "^ $net_virtual " >/dev/null 2>&1
   if [[ $? != 0 ]]; then 
     echo "ERROR: $net_virtual does not exists" >&2
     continue
   else
     break
   fi
 done
 network="network:$net_virtual"
fi

## Installation Methods

while :; do
cat <<EOF
Please enter a number for installation method below:
1) PXE 2)location 3) cdrom
EOF
 read -p "-->: " inst_meth
 case $inst_meth in
 #--extra-args only work if specified with --location, --pxe does work with --location
 1) inst_meth='--pxe'
    is_pxe=y
    ks=''
    break;;
 2) read -p "Please input the source URL: " inst_url
    inst_meth="--location=$inst_url"
    break;;
 3) while :;do
    read -p "Please input path of installation file: " inst_iso
    if [[ -e "$inst_iso" ]] && [[ -f "$inst_iso" ]]; then
      inst_meth="--location=$inst_iso"
      break
    else
      echo "Error: \""$inst_iso"\" not exist or not a file!" && continue
    fi
    done
    break ;; 
 *) continue
 esac
done

## Kickstart Installation
# --extra-args only work if specified with --location, --pxe does work with --location
if [[ "$inst_meth" == '--pxe'  ]];then
  initrd=''
  tty=''
else
  # use "=" between "--extra-args" and "console", otherwise it does't work.
  tty='--extra-args=console=ttyS0,115200n8 serial'
  while :; do
    read -p "Any kickstart file?[Y|N]: " answer
    if  [[ $answer =~ ^('Y'|'y')$ ]]; then
      while :; do 
         read -p "the full path of kickstart file: " path
         if [[ -e "$path" ]] && [[ -f "$path" ]]; then
            initrd='--initrd-inject='"$path"
            ks_file='ks=file:/'$(basename "$path")
            ks="--extra-args $ks_file"
            break
         else 
            echo "Error: $path not exsits "
            continue
         fi
      done
     break
   else
     break    
   fi 
  done
fi 

## Main Program

virt_install=$(which virt-install)

if [[ $is_pxe != '' ]]; then
   $virt_install '--name' "$name" '--memory' "$ram_size" '--disk'='size'=${disk_size},'path'=$disk_path '--vcpus' 1 '--network' "$network" '--os-type'='linux' '--os-variant'="$os_variant" '--graphics'='none' $inst_meth 
else
  $virt_install '--name' "$name" '--memory' "$ram_size"  '--disk' 'size'=${disk_size},'path'=$disk_path '--vcpus' 1 '--network' "$network"  '--os-type'='linux' '--os-variant'="$os_variant" '--graphics'='none'  $inst_meth  $initrd  "$tty" $ks 
fi

