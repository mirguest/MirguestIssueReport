#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

from subprocess import Popen
import time

import random

from Monitor import gMonitor
from TransferFactory import gTransferFactory

MAX_TRANSFER = 2

class Transfer(object):

    def __init__(self):
        self.transfer_worker = []

        self.initialize()

    def initialize(self):
        pass

    def add_new_transfer(self):
        """
        If we add a new transfer worker, 
        this function return True.
        """
        result = gMonitor.get_new_one_request()
        if result is None:
            return False
        guid = result["guid"]
        trans_protocol = result["trans_protocol"]
        from_ep = gMonitor.get_endpoint_url(result["from_ep"])
        to_ep = gMonitor.get_endpoint_url(result["to_ep"])

        result = gMonitor.get_request_new_one_file(guid)
        if result is None:
            return False

        guid = result["guid"]
        index = result["file_index"]

        info = {"trans_protocol": trans_protocol,
                "from_ep": from_ep,
                "to_ep": to_ep,
                "from_path": result["from_path"],
                "to_path": result["to_path"],
                }

        dtw = gTransferFactory.generate(info)

        time.sleep(0.1)

        self.transfer_worker.append( (guid, 
                                      index, 
                                      dtw) )

        # Change the status
        gMonitor.change_one_file_transfer(guid, index)

        time.sleep(0.1)

        return True

    def finish_transfer(self, guid, index):
        gMonitor.change_one_file_finish(guid, index)

    def start(self):
        while True:
            # Handle the existed transfer worker.
            for worker in self.transfer_worker:
                retcode = worker[2].proc.poll()

                if retcode is not None:

                    self.transfer_worker.remove(worker)
                    # Handle retcode
                    result = worker[2].handle_exit(retcode)

                    # Change the status.
                    self.finish_transfer(worker[0], worker[1])

                    break
                else:
                    # handle when the job is not OK.
                    worker[2].handle_waiting()
            else:
                time.sleep(1)

            # Create new transfer worker.
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
