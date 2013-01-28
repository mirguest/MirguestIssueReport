#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import subprocess

class TransferFactory(object):

    def generate_cmd(self, info):
        """
        >>> info is {}
        >>> gTransferFactory.generate_cmd(info)
        ["python", "-m", "TransferFactory.TransferBySCP", x, x, x, x]
        """
        protocol = info["trans_protocol"].upper()
        cmd_list = ["python", 
                    "-m", 
                    "TransferFactory.TransferBy%s"%(protocol),
                    info["from_ep"],
                    info["from_path"],
                    info["to_ep"],
                    info["to_path"]
                    ]
        return cmd_list
    pass


gTransferFactory = TransferFactory()
