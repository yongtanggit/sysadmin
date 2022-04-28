#! /usr/bin/env python3

'''
Interact with a running web service
Convert local text files to dictionaries.
Upload dictionaries  to the running web service
'''

import os
import requests
import threading

class uploader:
    def __init__(self,dir_full_path, http_full_url):
        self.dir_path = dir_full_path
        self.url = http_full_url
    def convert_upload(self,file):
        # convert raw data to dictionary
        keys = ['title','name','date', 'feedback']
        dicts = {}
        with open(file) as f:
            values = []
            for v in f:
                v = v.strip()
                if len(v):
                   values.append(v)
        keys_values = dict(zip(keys,values))
        # Upload the dictionary
        response = requests.post(self.url, data=keys_values)
        if response.ok:
           print("loaded entry")
        else:
           print(response.status_code)

    def process(self):
        for file_name in os.listdir(self.dir_path): # List the files
            file_full_path = "{}/{}".format(self.dir_path,file_name)
            uploading = threading.Thread(target=self.convert_upload,args=(file_full_path,))
            uploading.start()

f=uploader('feedback','http://localhost/feedback/')
f.process()
