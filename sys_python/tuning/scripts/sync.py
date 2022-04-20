
import multiprocessing
import subprocess
import os


class sync_all():
    '''
    def __init__(self,src,dest)
        self.src = src
        self.dest = dest
    '''
    def start(self):
        multiprocessing.Process(target=self.dir).start()

    def dir(self):
        for root, dirs, files in os.walk("../data/prod", topdown=True):
            self.dest = root.replace("prod","prod_backup")
            print(root)
            print(self.dest)
            multiprocessing.Process(target=self.sync,args=(root,self.dest)).start()

    def sync(self,root,dest):
        subprocess.call(["rsync", "-arq", root, dest])



sync_it = sync_all()
sync_it.start()


'''
#!/usr/bin/env python3

from multiprocessing import Pool
from pathlib import Path
import subprocess


def run(src_subdir):
    subprocess.call(["rsync", "-arq", src_subdir, dest])


if __name__ == "__main__":
    ROOT_DIR = Path(__file__).resolve().parents[1]
    src = ROOT_DIR / "data/prod/"
    dest = str(ROOT_DIR / "data/prod_backup/")

    # Create a pool of specific number of CPUs
    src_subdirs = [str(x) for x in src.iterdir() if x.is_dir()]
    p = Pool(len(src_subdirs))

    # Start each task within the pool
    p.map(run, src_subdirs)
'''