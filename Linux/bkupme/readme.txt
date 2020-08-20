INTRODUCTION
------------

This program backups my /scripts directory to a remote server.  
This program does not accept any option

REQUIREMENTS
------------

1. This code was tested with Bash on a CentOS 7 host. 
2. Rsync command is required. 

RUNNING THE PROGRAM
-------------------

1. No root privilege is required to run the program
2. Source and destination path are hard coded. 


Notes:
------
Options of rsync in details:

YXcstpoguax  path/to/file
|||||||||||
||||||||||╰- x: The extended attribute information changed
|||||||||╰-- a: The ACL information changed
||||||||╰--- u: The u slot is reserved for future use
|||||||╰---- g: Group is different
||||||╰----- o: Owner is different
|||||╰------ p: Permission are different
||||╰------- t: Modification time is different
|||╰-------- s: Size is different
||╰--------- c: Different checksum (for regular files), or
||              changed value (for symlinks, devices, and special files)
|╰---------- the file type:
|            f: for a file,
|            d: for a directory,
|            L: for a symlink,
|            D: for a device,
|            S: for a special file (e.g. named sockets and fifos)
╰----------- the type of update being done::
             <: file is being transferred to the remote host (sent)
             >: file is being transferred to the local host (received)
             c: local change/creation for the item, such as:
                - the creation of a directory
                - the changing of a symlink,
                - etc.
             h: the item is a hard link to another item (requires 
                --hard-links).
             .: the item is not being updated (though it might have
                attributes that are being modified)
             *: means that the rest of the itemized-output area contains
                a message (e.g. "deleting")

