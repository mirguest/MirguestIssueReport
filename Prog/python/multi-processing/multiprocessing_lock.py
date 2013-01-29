#!/usr/bin/env python
# -*- coding:utf-8 -*-

# Refer to:
# http://www.doughellmann.com/PyMOTW/multiprocessing/communication.html

import multiprocessing
import sys
import time

def worker_with(lock, stream):
    with lock:
        stream.write('Lock acquired via with\n')
        time.sleep(2)
        
def worker_no_with(lock, stream):
    lock.acquire()
    try:
        stream.write('Lock acquired directly\n')
        time.sleep(2)
    finally:
        lock.release()

lock = multiprocessing.Lock()
w = multiprocessing.Process(target=worker_with, args=(lock, sys.stdout))
nw = multiprocessing.Process(target=worker_no_with, args=(lock, sys.stdout))

w.start()
nw.start()

w.join()
nw.join()
