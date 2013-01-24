#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import uuid
import datetime

import DB

class Monitor(object):

    def __init__(self):

        self.m_db = DB.DB(":memory:")

        self.m_endpoint = DB.EndPointTable(self.m_db)
        self.m_transfer_request = DB.TransferRequestTable(self.m_db)
        self.m_transfer_file = DB.TransferFileListTabel(self.m_db)
        self.m_user_transfer = DB.UserTransferTable(self.m_db)

        self.initialize_db()

    def initialize_db(self):
        # TODO
        self.m_endpoint.create_endpoint("lintao#test1",
                           "For lintao.",
                           "lintao",
                           "ihep@192.168.237.112")
        self.m_endpoint.create_endpoint("lintao#test2",
                           "For lintao.",
                           "lintao",
                           "ihep@192.168.237.61")

    # API

    def create_request(self, from_ep, to_ep, user, filelists):
        if self.m_endpoint.check(from_ep) and self.m_endpoint.check(to_ep):
            # generate the uuid
            guid = uuid.uuid1()

            guid = self.m_transfer_request.create_new_request(
                    str(guid),
                    from_ep,
                    to_ep,
                    user,
                    "new",
                    datetime.datetime.now())
            self.m_transfer_file.create_new_filelist(guid, filelist, "new")
            self.m_user_transfer.add(user, guid)
            return True
        return False


    def get_new_one_request(self):
        return self.m_transfer_request.get_one("new")

    def get_request_new_one_file(self, guid):
        return self.m_transfer_file.get_one(guid, "new")

    def change_one_file_transfer(self, guid, file_index):
        self.m_transfer_file.modify_status(guid, file_index, "transfer")

    def change_one_file_finish(self, guid, file_index):
        self.m_transfer_file.modify_status(guid, file_index, "finish")



if __name__ == "__main__":

    monitor = Monitor()

    filelist = [("/from/here", "/to/there"), 
                ("/from/here2", "/to/there2")]

    from_ep = "lintao#test1"
    to_ep = "lintao#test2"
    user = "lintao"

    monitor.create_request(from_ep,
                           to_ep,
                           user,
                           filelist)

    result = monitor.get_new_one_request()
    guid = result["guid"]

    print monitor.get_request_new_one_file(guid)

else:
    # Create Global Variable
    gMonitor = Monitor()
    filelist = [("/from/here", "/to/there"), 
                ("/from/here2", "/to/there2")]

    from_ep = "lintao#test1"
    to_ep = "lintao#test2"
    user = "lintao"

    gMonitor.create_request(from_ep,
                           to_ep,
                           user,
                           filelist)
    print "Create A New Request"

