#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

from ITransferProcess import ITransferProcess

class SCPTransferProcess(ITransferProcess):

    def construct_url(self, endpoint, path):
        return "%s:%s"%(endpoint, path)

    def construct_cmd(self, from_url, to_url):
        cmd_list = ["scp", from_url, to_url]

        return cmd_list


if __name__ == "__main__":

    from_ep = "ihep@ihep"
    to_ep = "ihep@ihep2"

    from_path = "/home/ihep/paw.metafile.2"
    to_path = "/home/ihep/paw.metafile.3"

    scp = SCPTransferProcess(from_ep, from_path, to_ep, to_path)

    print scp.from_url
    print scp.to_url

    print scp.transfer_cmd

    scp.transfer()
