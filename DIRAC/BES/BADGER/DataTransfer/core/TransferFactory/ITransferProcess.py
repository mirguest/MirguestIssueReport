#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import subprocess

class ITransferProcess(object):
    def __init__(self, from_ep, from_path, to_ep, to_path):
        self.from_ep = from_ep
        self.from_path = from_path
        self.to_ep = to_ep
        self.to_path = to_path

        self.from_url = self.construct_url(self.from_ep, self.from_path)
        self.to_url = self.construct_url(self.to_ep, self.to_path)

        self.transfer_cmd = self.construct_cmd(self.from_url, self.to_url)
        pass

    def transfer(self):
        tr_proc = subprocess.Popen(self.transfer_cmd,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)
        out, err = tr_proc.communicate()
        print out
        print err
        pass

    # Interface

    def construct_url(self, endpoint, path):
        """
        It should join the endpoint and path to the url.
        Such as: 
        >>> scp.construct_url("ihep@ihep", "/home/ihep")
        "ihep@ihep:/home/ihep"
        """
        raise NotImplemented

    def construct_cmd(self, from_url, to_url):
        """
        It should construct a list for Popen:
        >>> scp.construct_cmd("ihep@ihep:~/a", "ihep@ihep2:~/a")
        ["scp", "ihep@ihep:~/a", "ihep@ihep2:~/a"]
        """
        raise NotImplemented
    
