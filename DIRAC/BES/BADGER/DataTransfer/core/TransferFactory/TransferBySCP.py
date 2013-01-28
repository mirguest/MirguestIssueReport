#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

from ITransferProcess import ITransferProcess
from ITransferWorker import ITransferWorker

class SCPTransferProcess(ITransferProcess):

    def construct_url(self, endpoint, path):
        return "%s:%s"%(endpoint, path)

    def construct_cmd(self, from_url, to_url):
        cmd_list = ["scp", from_url, to_url]

        return cmd_list

class SCPTransferWorker(ITransferWorker):

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

    import sys

    if len(sys.argv) != 5:
        print "python %s from_ep from_path to_ep to_path"%sys.argv[0]
        sys.exit(-1)

    from_ep = sys.argv[1] or "ihep@ihep"
    to_ep = sys.argv[3] or "ihep@ihep2"

    from_path = sys.argv[2] or "/home/ihep/paw.metafile.2.no"
    to_path = sys.argv[4] or "/home/ihep/paw.metafile.3"

    scp = SCPTransferProcess(from_ep, from_path, to_ep, to_path)

    sys.exit( scp.transfer() )
