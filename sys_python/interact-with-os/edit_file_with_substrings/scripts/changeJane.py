#! /urs/bin/python3

"""
change file name from jane_* to jdoe_*

"""
import subprocess

path = 'old_files.txt'

full_path = '/home/kali/coding/sysadmin/sys_python/interact-with-os/edit_file_with_substrings/scripts/'

with open(path) as f:
    for i in f.readlines():


        i_new = i.replace('jane_', 'jj_').rstrip()
        i_full_path = full_path + i

        i_new_full_path=full_path+i_new
        subprocess.Popen("mv" + " " + i_full_path + " " + i_new_full_path, shell=True)

https://stackoverflow.com/questions/21804935/how-to-use-the-mv-command-in-python-with-subprocess# files = subprocess.Popen("date", stdout=subprocess.PIPE, shell=True)

# print(files)


# pattern = 'jane_'
