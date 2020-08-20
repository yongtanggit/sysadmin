#! /bin/bash
# This program emulates Linux locate program 

# check argument

if [[ $# -ne 1 ]]; then
  echo "usage: locate file" 
  exit 1
fi

if [[ -e locate.db ]];then 
  grep "$@" locate.db
else
  echo "locate.db not exist, please run locat_update.sh first as root."
  exit 2
fi

exit 0
   
