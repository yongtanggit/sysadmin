#! /bin/bash

#This program improves ls command by:
# Showing numbers of entries in a directory
# Showing file size in KB/MB/GB
# Showing output in column(s)
#List content in current directory for 0 argument 
# List corresponding contents in the order of multiple arguments 
#If the content is directory, shows the numbers of entry, otherwise list the size of file 


entry_size(){
  for file in *; do
    if [[ -d $file ]]; then
       [[ ! -r "$file" ]] && echo "$file can't be opened" && continue
       entry=$(ls "$file" | wc -l) 
       if [[ $entry -gt 1 ]]; then
          echo "${file}($entry entries)|"
       else
          echo "${file}($entry entry)|"
       fi  
    else
       file_size=$(ls -l -d -h  "$file" | awk '{print $5}')
       if [[ $file_size =~ ^[0-9]+$ ]]; then   
         echo "${file}( ${file_size}B )|"
       else
         echo "${file}( $file_size )|"
       fi
    fi
  done
 
}

# main code

if [[ $# -eq 0 ]]; then
  echo
  entry_size 
  echo 
else
  echo
  for arg in $@;do
    [[ ! -e "$arg" ]] && echo "$arg not exits" && continue
    [[ ! -r "$arg" ]] && echo "$arg can't be opened" && continue
    cd $arg
    entry_size  
  done
  echo
fi | 
    sed 's/ /^^^/g' | 
    xargs  -n 2   | 
    sed 's/\^\^\^/ /g' | 
    awk -F\| '{ printf "%-39s %-39s\n", $1,$2 }'


 





 
