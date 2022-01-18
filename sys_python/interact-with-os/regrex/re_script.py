#!/usr/bin/env python3

# Import libraries
import re
import csv

"""Returns True if the email address contains the given domain,
 in the domain position, false if not."""
def contains_domain(address, domain):
    domain_pattern = r"[\w\.-]+@"+domain+"$"
    if re.search(domain_pattern, address):
        return True
    return False

old_domain = 'abc.edu'
new_domain = 'xyz.edu'
cvs_file_location =''
updated_file_location=''

# Open the file to read
with open(cvs_file_location, 'r') as f:
    lines = csv.reader(f)
    # Create and write the output file.
    with open('updated_file_location','w+') as output:
        ''' Identify the domain need be changed, and write both 
        the unchanged and changed to file.'''
        writer = csv.writer(output)
        for line in lines:
           if line and not contains_domain(line[1], old_domain):
               writer.writerow(line)
           elif line and contains_domain(line[1].strip(), old_domain):
               line[1] = re.sub(old_domain,new_domain,line[1].strip())
               writer.writerow(line)




