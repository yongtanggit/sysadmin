

#! /bin/bash

# This program helps me to login my servers on AWS.
# A MySQL database is set up for storing domains, hostnames and SSHkeys location(pointer).  


# SSHkey path 
key_path='/home/student/keys/'

# Get domain from a MySQL datatbase
mysql aws -e 'select * from domains'
while :; do 
  read -p "ID Num: " idnum
  mysql aws -e 'select * from domains' | grep -q ^$idnum 
  if [[ $? -eq 0 ]]; then
     break
  else
    echo "Invalid Input!"
    continue
  fi
done
domain=$(mysql aws -s --disable-column-name -e "select DOMAIN from domains WHERE ID='$idnum'")

# Get table
table=$(echo $domain | sed 's/\.//')

# Get host name
mysql aws -e "select HOSTNAME from $table" || exit


while :; do
   read -p "please type in the hostname: " hostname
   mysql aws -s --disable-column-names -e "SELECT HOSTNAME from $table where HOSTNAME='$hostname';" | grep -q ^$hostname$ 
   if [[ $? -eq 0 ]] ; then
      break
   else 
      echo "Invalid Input"
      continue
   fi
done

# Get key
key=$(mysql aws -s --disable-column-names -e "SELECT SSHKEY from $table WHERE  HOSTNAME='$hostname';")
[[ ! -e "${key_path}$key" ]] && echo "Error! the key file can not be found!" && exit 1

# Get IP
IP=$(mysql aws -s --disable-column-names -e "SELECT IP from $table WHERE HOSTNAME='$hostname';")

# Log in the AWS server
ssh -i ${key_path}$key ec2-user@$IP
