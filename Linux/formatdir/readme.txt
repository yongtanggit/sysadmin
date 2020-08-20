INTRODUCTION
------------

This program improves ls command by:
<> Showing numbers of entries in a directory
<> Showing file size in KB/MB/GB
<> Showing output in column(s)
<>List content in current directory for 0 argument 
<> List corresponding contents in the order of multiple arguments 
<> If the content is directory, shows the numbers of entry, otherwise list the size of file 

REQUIREMENTS
------------

1. This code was tested with Bash on a Centos 7 host. 
2. This code requires sed, xargs, awk commands 

RUNNING THE PROGRAM
-------------------

Root privilege is required to run the program if the user doesn’t have enough permission to list some directories.

