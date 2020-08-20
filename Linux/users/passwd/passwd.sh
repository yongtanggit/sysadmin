#!/bin/bash

# Options -f -i(default)

# is_root

uid=$(id -u) 
if [[ $uid -ne 0 ]]; then
  echo "Only Root User Can Run This Program, Quiting.."
  exit 1
fi


#Input validation

err(){
  echo "Usage: password.sh [-i/--interactive], [-f/--file] filename"
  exit 2
}   

# Two Options: Taking File, Interactive

opt=$1
file=$2
user=''
pass=''

option(){
  case "$opt" in 
   -f | --file)              opt=f;;
   -i | --interactive | "")  opt=i;;
   *)                        err;;
  esac
}


if [[ $# -gt 2 ]]; then 
  err
else
  option
fi


# Check If the User Exists

chk_usr(){
  id -u $user > /dev/null 2>&1
  v=$?
  [[ $v -eq 0 ]] && [[ $opt == i ]] && echo "User($user) exist!" && exit 3
  [[ $v -eq 0 ]] && echo "User($user) exist!" 
}


# Add User and Password and Change passwd after first login
user_pass(){
  useradd $user 
  case $opt in
       i)       echo $pass | passwd --stdin $user > /dev/null 2>&1;;
       f)       echo $user | passwd --stdin $user > /dev/null 2>&1;;
  esac
  chage -d 0 $user
}

## Main Program

# Option -i

if [[ "$opt" == i ]]; then 
   read -p 'Please Input a User Name: ' user
   chk_usr
   read -p 'Please Input a Password: ' pass
   user_pass
   exit
fi

# Option -f

if [[ ! -e $file ]];then 
     echo "$file doesn't exist" 
     exit 4
else
     for user in $(cat $file); do
         chk_usr && continue 
         user_pass
     done
fi
        
       

       

  
  





