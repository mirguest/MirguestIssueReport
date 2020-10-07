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

    def generate(self, info):
        protocol = info["trans_protocol"].upper()
        cmd_list = self.generate_cmd(info)
        mod = __import__("TransferBy%s"%(protocol),
                         globals(),
                         locals(),
                         ["%sTransferWorker"%(protocol)]
                         )
        TR = getattr(mod, "%sTransferWorker"%(protocol))
        tr = TR()
        tr.create_popen(cmd_list)
        return tr


gTransferFactory = TransferFactory()
