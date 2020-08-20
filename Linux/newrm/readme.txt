INTRODUCTION
------------

This program replace rm command, which deletes file by actually removing filename(unlink). 
This program saves a copy of deleted file by creating a new hard link with mv command.
The "deleted file" is saved in a hidden and secured directory(~./archive). 


REQUIREMENTS
------------

This code was tested with bash on CentOS6,7


RUNNING THE PROGRAM
-------------------

Root privilege is required to run the program if the user doesn’t have enough permission to list some directories.
