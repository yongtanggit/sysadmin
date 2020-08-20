#! /bin/bash
## Yong Tang
## This program backups a directory to a remote server.
## This  program  doesn't take any argument.
## This program  has no option.   

# Input validation
[[ $# -ne  0 ]] && echo "Useage: bkupme.sh" && exit 1

# Asks Source and Destination Paths

while :; do
  read -p "The absolut path of source directory: " src_path
     if [[ -d $src_path ]];  then
       break
     else 
       echo "Wrong path or directory not exist! Continue or Ctrl + C to exit"
     fi
done

read -p "The username used for remote server login: " user

read -p "The absolute path of destination directory: " dst_path

read -p "The IP address of destination of server: " ip
 
dst_path="$user@$ip:$dst_path"

# Proform a dry run to show file(s) that need update or backup.
 
rsync -auniv "$src_path" "$dst_path" --delete-before

[[ $? -ne  0 ]] && exit 1 # Fail to sync  

# Proceed or stop if there is any file needs to update or backup
if [[ $? -eq 0 ]]; then 
  read -p "Press yes to proceed, any other key to quit: " 
    if [[ $REPLY == 'yes' ]] || [[ $REPLY == 'YES'; then 
      rsync -au "$src_path" "$dst_path" --delete-before 
    else
      echo 'quit..'
    fi
else
  echo "ERROR, QUIT.." 
  exit 2
fi

