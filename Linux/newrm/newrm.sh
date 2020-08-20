#!/bin/bash

# This program replaces rm command, which deletes file by actually removing filename(unlink). 
# This program saves a copy of deleted file by creating a new hard link with mv command.
# The "deleted file" is saved in a hidden and secured directory(~./archive). 

archive_dir="$HOME/.archive"    # archive directory path

newrm=$(which mv)

usage(){
  echo "Usage: $0 file/directory"
  exit 1
}
timestamp=$(date "+%F@%T")

[[ $# -eq 0 ]] && usage        # error: no argument

# Test archive directory and make one if it does not exist.
# Only the user can access the archive directory
[[ ! -e $archive_dir ]] && mkdir $archive_dir && chmod 700 $archive_dir 

 
# Main Program

for i in $@; do
  if [[ ! -e "$i" ]]; then     # error: file not exist
     echo " \"$i\" not exist!"
     exit 1
  fi
  mv $i $archive_dir/$timestamp.$i
done





 
