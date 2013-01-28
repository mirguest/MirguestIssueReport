#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import subprocess
import time
import select

class ITransferWorker(object):
    """
    This is an Interface.
    """

    def __init__(self):
        self._proc = None

    @property
    def proc(self):
        return self._proc

    def create_popen(self, cmd):
        self._proc = subprocess.Popen(cmd, 
                                      stdout=subprocess.PIPE)
        # Make sure that the stdout is to PIPE.

    def handle_exit(self, returncode):
        raise NotImplementedError

    def handle_stream(self, stream):
        try:
            line = stream.readline()

            return self.handle_line(line)

        except:
            return ""

    def handle_line(self, line):
        raise NotImplementedError

    def handle_waiting(self):
        if not self._proc:
            return
        if select.select( [self._proc.stdout], [], [], 1 )[0]:
            return self.handle_stream( self._proc.stdout )

class DemoTransferWorker(ITransferWorker):

    # Interface

    def handle_exit(self, returncode):
        if returncode is None:
            return
        if returncode != 0:
            print "some error happens."
        print "work done"

    def handle_line(self, line):
        return line


if __name__ == "__main__":

    dtw = DemoTransferWorker()

    dtw.create_popen(["sleep", "5"])

    returncode = dtw.proc.poll()
    while returncode is None:
        time.sleep(0.2)
        dtw.handle_waiting()
        returncode = dtw.proc.poll()
    else:
        dtw.handle_exit(returncode)

    print "Work Done."
        

