#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

from subprocess import Popen
import time

import random

from Monitor import gMonitor

MAX_TRANSFER = 2

class Transfer(object):

    def __init__(self):
        self.transfer_worker = []

        self.initialize()

    def initialize(self):
        pass

    def add_new_transfer(self):

        result = gMonitor.get_new_one_request()
        if result is None:
            return False
        guid = result["guid"]
        result = gMonitor.get_request_new_one_file(guid)
        if result is None:
            return False

        print result

        guid = result["guid"]
        index = result["file_index"]

        sleep_time = str(random.randint(5, 20))
        cmd = ["sleep", sleep_time]

        time.sleep(0.1)
        print "Add A New Transfer, will sleep", sleep_time
        self.transfer_worker.append( (guid, index, Popen(cmd)) )

        # Change the status
        gMonitor.change_one_file_transfer(guid, index)

        time.sleep(0.1)

        return True

    def finish_transfer(self, guid, index):
        gMonitor.change_one_file_finish(guid, index)

    def start(self):
        while True:
            for worker in self.transfer_worker:
                retcode = worker[2].poll()
                #print retcode
                if retcode is not None:
                    # Handle the Result
                    #print retcode
                    print "Finish ", worker[0], worker[1]
                    self.finish_transfer(worker[0], worker[1])

                    self.transfer_worker.remove(worker)
                    break
            else:
                time.sleep(1)
                print "Sleeping"

            idle_worker = MAX_TRANSFER - len(self.transfer_worker)

            if idle_worker:
                for i in range(idle_worker):
                    # append new worker
                    if self.add_new_transfer():
                        break
                else:
                    time.sleep(1)

                    if idle_worker == MAX_TRANSFER:
                        print "No Transfer Request. Sleeping"
                        time.sleep(5)






if __name__ == "__main__":

    transfer = Transfer()

    transfer.start()
