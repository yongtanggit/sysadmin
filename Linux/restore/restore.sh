#!/bin/bash

# This program restores deleted file(s) by newrm.sh program.
# The program lists all content in ~/.archive directory when no argument is provided.
# The program restores file when argument is provided.


arch_dir="$HOME/.archive"
dst_dir=$(pwd)
restore_list='/tmp/restore.list'
count=$(ls $arch_dir | grep .$1$ | wc -l) # check the number(s) of matched files 
re_file=$1 

usage(){
 echo "Usage: $0, $0 filename"
 exit 1
}

# show content in ~/.archive
show_arch(){
  echo
  echo "Contents of Your Deleted Files Archive(sorted by date):"
  echo ----------------------------------------------------------------------
  ls  -F $arch_dir | cut -d '.' -f 2 | column | tr -s ' '
  echo ----------------------------------------------------------------------
  exit 0
}

# More than one file or directory match in the archive:
show_multi(){
  echo "$count files(directories) named $re_file, please chose the verson to restore" 
  oldIFS=$IFS
IFS="
"
  index=0
  [[ -e $restore_list ]] && rm $restore_list
  for string in $(ls -lh $arch_dir | grep .$re_file$ | tr -s ' '); do
    #echo "\$string: $string" 
    file_name=$(echo $string | cut -d ' ' -f 9)
    #echo "\$file_name: $file_name"
    date=$(echo $file_name | cut -d '.' -f 1)
    #echo "\$date: $date"
    day=$(echo $date | cut -d '@' -f 1)
    #echo "\$day: $day"
    time=$(echo $date | cut -d '@' -f 2)
    #echo "\$time $time"
    size=$(echo $string | cut -d ' ' -f 5)
    index=$((index + 1))
    echo "$index&$file_name" >> $restore_list
    echo "$index) $re_file (size = $size, deleted = $day at $time)"
  done
  IFS=$oldIFS
}

# test writable of current directory
write_dir(){
  [[ ! -w $dst_dir ]] && echo " The directory is not writable." &&  exit 3
}

# restore file(s) 
restore(){
  if [[ $kp_arch == y ]]; then    # keep archived or not
     cp -al "$arch_dir/$file" "$dst_dir/$re_file"
  else 
     mv "$arch_dir/$file" "$dst_dir/$re_file"
  fi
}

##  main program ##


# don't accept multiple arguments
[[ $# -gt 1 ]] && usage

# No filename provided. 
[[ $# -eq 0 ]] && show_arch

while :; do
  read -p "Keep the archive? y/n: " kp_arch
  case $kp_arch in 
  y|n) break;;
  q)   exit;;
  *)   echo "please type y or n. type q to quit the program" 
       continue 
  esac
done

# can't find the archived file.
[[ $count -eq 0 ]] && echo "Sorry, deleted file: \"$1\" not found" && exit 2

# single archived file 
if [[ $count -eq 1 ]]; then
  write_dir
  file=$(basename $(ls ${arch_dir}/*.$1))
  restore
fi

# Multi verstion archived files
if [[ $count -gt 1 ]]; then
  write_dir
  show_multi 
  while :; do
     read -p "type a number to restore, q to quit: " answer
     [[ $answer == q ]] && echo 'quit..' && exit
     num='^[0-9]+$'
     if ! [[ $answer =~ $num ]]; then
        echo "error: not a number"
        continue
     else
       break
     fi
  done
  file=$(grep "^${answer}&" $restore_list)
  file=$(echo $file | cut -d '&' -f 2) 
  echo $file
  restore  
fi
 
  




   









  





  
 

 
