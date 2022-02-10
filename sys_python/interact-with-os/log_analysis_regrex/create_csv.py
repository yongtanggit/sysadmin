'''
## Problem statement
Two reports
1) a ranking of errors generated by the system
a list of:
<> all error messages logged
<> sorted by the most common error to the least common error
2) usage statistics for the service
a list of :
<> all users used the system including: how many info messages and how many error messages
<>sorted by username
3) csv to html
'''

import re
from operator import itemgetter
import csv

pattern_error = 'ERROR (.+)\(.+\)'
pattern_info = 'INFO (.+)\(.+\)'
pattern_user = '[INFO,ERROR] .+\((.+)\)'

''' Create an ERROR list'''


def identify_errors():
    errors = []
    with open('syslog.log') as f:
        for line in f:
            if re.search(pattern_error, line):
                match = re.search(pattern_error, line).group(1)
                errors.append(match.strip())
    return errors


''' Return a unique list with set method '''


def group_errors():
    errors = identify_errors()
    return set(errors)


''' 
    Return a dictionary sorted by values
    https://stackoverflow.com/questions/613183/how-do-i-sort-a-dictionary-by-value
'''


def analyze_errors():
    errors = identify_errors()
    error_count = {}
    for i in group_errors():
        count = errors.count(i)
        error_count.update({i: count})
    return sorted(error_count.items(), key=itemgetter(1), reverse=True)


''' search for INFO'''

def identify_infos():
    infos = []
    with open('syslog.log') as f:
        for line in f:
            if re.search(pattern_info, line):
                match = re.search(pattern_info, line).group(1)
                infos.append(match.strip())
    return infos

''' Search for users'''
def identify_users():
    users = []
    with open('syslog.log') as f:
        for line in f:
            if re.search(pattern_user, line):
                match = re.search(pattern_user, line).group(1)
                users.append(match.strip())
    return set(users)


'''
# ceate a dictionary of list
# loop through the file with user list
# find info and error and count them
# write the result in the dictionary of list
'''
user_info_error = {}

users = identify_users()
user_info_error_dict = {}

''' find info and error and count them according to users '''

def analyze_users_info_error():
    for user in users:
        pattern_user_info = r'INFO (.+)\({}\)'.format(user)
        pattern_user_error = r'ERROR (.+)\({}\)'.format(user)
        count_info = 0
        count_error = 0
        with open('syslog.log') as f:
            for line in f:
                if re.search(pattern_user_info, line):
                    count_info += 1
                    user_info_error = {user: [count_info, count_error]}
                if re.search(pattern_user_error, line):
                    count_error += 1
                    user_info_error = {user: [count_info, count_error]}
        user_info_error_dict.update(user_info_error)
    return sorted(user_info_error_dict.items())


new_dict_data = {}

''' Convert list to dictionary'''


def list_to_dictionary():
    dict_data = analyze_users_info_error()  # This produce a list of tuple
    for data in dict_data:
        data = {data[0]: data[1]}
        new_dict_data.update(data)
    return new_dict_data

''' 
Write the dictionary to CSV file
https://www.geeksforgeeks.org/python-write-dictionary-of-list-to-csv/
'''

def write_csv_users_info_error():
    dict_list = list_to_dictionary()
    with open('test.csv', 'w') as outfile:
        writer = csv.writer(outfile)
        key_list = list(dict_list.keys())
        limit = len(key_list)
        writer.writerow(dict_list.keys())
        for i in range(limit):
            if i:
                writer.writerow([dict_list[x][i]] for x in key_list)


write_csv_users_info_error()