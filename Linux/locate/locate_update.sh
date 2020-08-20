#! /bin/bash
# This program emulate program Linux updatedb
# It create a databse file for locate.sh, which emulates program Linux locate.


# check root id

# Don't use $USER here
[[ $(whoami) != root ]] && echo "Only root can run this program, quit.." && exit 1

find / -print > locate.db

 
 
