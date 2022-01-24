#! /usr/bin/env python3

import sys
import re
import os

# Command line argument
log_file = sys.argv[1]
# Log file location
error_file_location = '/coding/sysadmin/sys_python/interact-with-os/log_files/errors_found.log'
# Rex pattern
pattern = r"CRON\[\d+\]: ERROR: Failed to start"

# Search log with specified error.
def error_search(log_file):
    with open (log_file, encoding='UTF-8') as f: # UTF-8 encoded for special chars such as Chinese
        returned_errors = []
        for line in f:
            if re.search(pattern,line):
               returned_errors.append(line)
    return returned_errors

# Write the found log entry into the file
def file_output(returned_errors):
    with open (os.path.expanduser('~') + error_file_location, 'w') as f:
        f.writelines(returned_errors)

results = error_search(log_file)
file_output(results)