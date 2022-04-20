#! /usr/bin/python3

"""
    Open an image
    Rotate an image
    Resize an image
    Save an image in a specific format in a separate directory
"""

from PIL import Image
import os
import threading


class correct_icons: 
    def __init__(self,working_path,output_path,file_rotate,file_resize,file_format):
        self.working_path = working_path
        self.output_path = output_path
        self.resize = file_resize
        self.rotate = file_rotate
        self.format = file_format
    def correct(self,file_input_path,file_output_path):
        im=Image.open(file_input_path)
        im.rotate(self.rotate).resize(self.resize).convert('RGB').save(file_output_path,format=self.format)
    def process(self):
        for file_name in os.listdir(self.working_path): # List the files
            file_input_path= "{}/{}".format(self.working_path,file_name)
            file_output_path="{}{}".format(self.output_path,file_name)
            image=threading.Thread(target=self.correct,args=(file_input_path,file_output_path))
            image.start()

icons=correct_icons('images','/opt/icons/',270,(128,128),'jpeg')
icons.process()

