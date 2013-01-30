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

    # For web API

    def create_open_request(self, from_ep, to_ep, user, trans_protocol):
        if self.m_endpoint.check(from_ep) and self.m_endpoint.check(to_ep):
            # generate the uuid
            guid = uuid.uuid1()
            # create an *open* request
            guid = self.m_transfer_request.create_new_request(
                    str(guid),
                    from_ep,
                    to_ep,
                    user,
                    trans_protocol,
                    "open",
                    datetime.datetime.now())
            self.m_user_transfer.add(user, guid)
            return guid

    def list_request(self, status=None):
        return self.m_transfer_request.get_all(status)

    def list_request_files(self, guid):
        result = self.m_transfer_file.get_all(guid)
        return result

    def submit_open_request(self, guid):
        self.m_transfer_request.modify_status(guid, "new")

    def list_endpoints(self):
        return self.m_endpoint.get_all()

    def create_endpoint(self, endpoint, description, owner, url):
        self.m_endpoint.create_endpoint(endpoint, description, owner, url)

    # End For web API

    def create_request(self, from_ep, to_ep, user, trans_protocol, filelists):
        if self.m_endpoint.check(from_ep) and self.m_endpoint.check(to_ep):
            # generate the uuid
            guid = uuid.uuid1()

            guid = self.m_transfer_request.create_new_request(
                    str(guid),
                    from_ep,
                    to_ep,
                    user,
                    trans_protocol,
                    "new",
                    datetime.datetime.now())
            self.m_transfer_file.create_new_filelist(guid, filelist, "new")
            self.m_user_transfer.add(user, guid)
            return True
        return False


    def get_new_one_request(self):
        # TODO
        new_one = self.m_transfer_request.get_one("new")
        # Make sure the guid --> File with new status.
        if new_one is None:
            return
        guid = new_one["guid"]
        if self.m_transfer_file.get_request_count(guid):
            if self.m_transfer_file.get_request_count(guid, "new"):
                return new_one
            else:
                # Change the status
                self.m_transfer_request.modify_status(guid, "transfer")

    def get_request_new_one_file(self, guid):
        return self.m_transfer_file.get_one(guid, "new")

    def change_one_file_transfer(self, guid, file_index):
        self.m_transfer_file.modify_status(guid, file_index, "transfer")

    def change_one_file_finish(self, guid, file_index):
        self.m_transfer_file.modify_status(guid, file_index, "finish")

    def get_endpoint_url(self, ep):
        result = self.m_endpoint.get_endpoint(ep)
        if result:
            return result["url"]


if __name__ == "__main__":

    monitor = Monitor()

    filelist = [("/from/here", "/to/there"), 
                ("/from/here2", "/to/there2")]

    from_ep = "lintao#test1"
    to_ep = "lintao#test2"
    user = "lintao"
    trans_protocol = "scp"
    monitor.create_request(from_ep,
                           to_ep,
                           user,
                           trans_protocol, 
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
    trans_protocol = "scp"

    gMonitor.create_request(from_ep,
                           to_ep,
                           user,
                           trans_protocol, 
                           filelist)
    print "Create A New Request"
    filelist = [("/new/from/here1", "/new/to/there1"), 
                ("/new/from/here2", "/new/to/there2"),
                ("/new/from/here3", "/new/to/there3"),
                ("/new/from/here4", "/new/to/there4"),]
    gMonitor.create_request(from_ep,
                           to_ep,
                           user,
                           trans_protocol, 
                           filelist)
    print "Create A New Request"
    filelist = [("/home/ihep/paw.metafile.2", "/home/ihep/paw.2"), 
                ("/home/ihep/paw.metafile.2", "/home/ihep/paw.3"),
                ("/home/ihep/paw.metafile.2", "/home/ihep/paw.4"),
                ("/home/ihep/paw.metafile.2", "/home/ihep/paw.5"),]
    gMonitor.create_request(from_ep,
                           to_ep,
                           user,
                           trans_protocol, 
                           filelist)


