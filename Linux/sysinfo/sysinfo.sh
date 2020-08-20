#! /bin/bash

## Program to output system information to a HTML page

## options: -f|--file -i|--interactive

# Variables #

title="System Information Report"
time_stamp=$(date +"%X%x%Z")
program=$0


# Functions #

sys_basic(){
  echo "Hostname: $HOSTNAME"
  echo "System Uptime: $(uptime)"
}

sys_disk(){
  echo "Systime Disk Space Utilization"
  df -h
}
#u_name=$(id -un)
u_id=$(id -u)
u_name=$(id -un)
sys_home(){
 echo '$u_name:' $u_name
 if [[ $u_id == 0 ]]; then
    echo "System Home Space Utilization(All Users)"
    du -sh /$u_name
    users=$(grep /bin/bash /etc/passwd | grep -v :0:0: | cut -d ":" -f 1)
    for u in $users; do
       du -sh /home/$u
    done
 else
    echo "System Home Space Utilization($u_name)"
    du -sh /home/$u_name
 fi
}

write_html () {
   cat <<- _eof_
	<HTML>
		<TITLE><HEAD>$title</HEAD></TITLE>
		<BODY><PRE>
		   <H1>$title( $time_stamp By $u_name )</H1>
       		   <P>$(sys_basic)</P>
       		   <P>$(sys_disk)</P>
                   <p>$(sys_home)</p>
       		  </PRE>  
       		</BODY>
       </HTML>
	_eof_
  return
}

usage(){
   echo "Usage: sysinfo.sh [-f/--file ] file [ -i/--interactive] [-h/--help]"
   exit 1
}


help(){
cat <<- eof
       File Mode: $program  -f/--file filename
Interactive Mode: $program -i/--interactive 
eof
exit
}

opt="$1"

options(){
  case "$opt" in
  -f | --file)           opt=f
                        ;;
  -i | --interactive)    opt=i
                        ;;
  -h | --help)           opt=h;;
            *)           usage;;
esac
}

file_exist(){
  if [[ -e $filename ]]; then
    while true; do  
      read -p "\"$filename\" exists, overwrite? [y|n] -> "
      case $REPLY in 
         y|Y)           break;;
         n|N)           exit;;
         *)             echo "Invalid Input";;
      esac
    done
  fi
}


## Output the Report to a HTML Page ##  

clear

options

filename=""

if [[ "$opt" == i ]] && [[ $# -eq 1 ]]; then
   while [[ -z $filename ]];do
   read -p "Please Give the Name of Output File -->  " filename
      echo "Please Input a File Name"
   done 
   file_exist
   write_html > $filename
elif [[ "$opt" == f ]] && [[ $# -eq 2 ]]; then
   filename=$2
   file_exist
   write_html > $filename
elif [[ "$opt" == h ]] && [[ $# -eq 1 ]]; then
   help
elif [[ -z $2 ]]; then
     echo "Please Input a File Name"
     usage
else
   usage
fi
    

