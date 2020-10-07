#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import subprocess
import time
import select
import sys

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
                                      stdout=subprocess.PIPE,
                                      stderr=subprocess.PIPE
                                      )
        # Make sure that the stdout is to PIPE.

    def handle_exit(self, returncode):
        raise NotImplementedError

    def handle_stream(self, stream):
        buffer_line = ""
        try:
            for line in stream:
                buffer_line += self.handle_line(line)
        except:
            pass
        finally:
            return buffer_line

    def handle_line(self, line):
        raise NotImplementedError

    def handle_waiting(self):
        if not self._proc:
            return

        r,w,x = select.select( [self._proc.stdout, self._proc.stderr], 
                               [], 
                               [self._proc.stdout, self._proc.stderr]
                               , 1 )
        for out in r:
            # ready for reading
            sys.stdout.write( self.handle_stream( out ) )
            sys.stdout.flush()
        for out in x:
            # exceptional condition
            sys.stdout.write( self.handle_stream( out ) )
            sys.stdout.flush()

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
        

