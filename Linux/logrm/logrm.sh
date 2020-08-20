#! /bin/bash
# This program logs every deleted file in the system by rm command.
# -s option indicate a silent removing action


rm_path=$(which rm)
rm_log="${HOME}/.logrm"

err_usage(){
  echo "usage: rm file..." 
  echo "usage: rm -s file ..."
  exit 1
}

err_write(){
  echo "/var/log not writable"
  exit 2
}


[[ $# -eq 0 ]] && echo "No Operand!" && err_usage


if [[ $1 == '-s' ]]; then # check the option
  shift
  $rm_path $@
else
    for i in $@; do
      $rm_path $i
      [[ $? == 0 ]] && echo "$(date): ${USER}: $i" >> $rm_log # log the deleted files 
  done
fi

 
