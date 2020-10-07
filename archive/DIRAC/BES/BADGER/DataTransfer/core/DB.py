#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

# use sqlite.

import sqlite3

def make_connection(path):
    return sqlite3.connect(path)

class DB(object):

    def __init__(self, path):
        self.m_conn = make_connection(path)
        self.m_conn.row_factory = sqlite3.Row

    def check_exist_table(self, table):
        cursor = self.m_conn.cursor()
        cursor.execute("""
            SELECT count(*) FROM sqlite_master 
            WHERE type='table' AND name='%s'; 
        """%table)

        result = cursor.fetchall()

        return True if result[0][0] else False


    def drop_table(self, table, forced_drop=False):
        if forced_drop and self.check_exist_table(table):
            with self.m_conn:
                self.m_conn.execute("drop table ?", (table))

class UserTransferTable(object):

    def __init__(self, db):
        self.m_db = db
        self.m_conn = db.m_conn

        self.forced_drop = True
        self.m_db.drop_table("user_transfer", self.forced_drop)
        self.create_not_exist()

    def create_table(self):
        self.m_conn.execute("""
            create table user_transfer 
            (user text, 
             guid text)
        """)

    def create_not_exist(self):
        if not self.m_db.check_exist_table("user_transfer"):
            self.create_table()

    def add(self, user, guid):
        with self.m_conn:
            self.m_conn.execute("""
                insert into user_transfer
                (user, guid)
                values (?, ?)
            """, (user, guid))


class EndPointTable(object):

    def __init__(self, db):
        self.m_db = db
        self.m_conn = db.m_conn

        self.forced_drop = True
        self.m_db.drop_table("endpoint", self.forced_drop)
        self.create_not_exist()

    def create_table(self):
        self.m_conn.execute("""
            create table endpoint
            (ep_name text, 
             description text,
             owner text,
             url text)
        """)

    def create_not_exist(self):
        if not self.m_db.check_exist_table("endpoint"):
            self.create_table()

    # API

    def create_endpoint(self, endpoint, description, owner, url):
        with self.m_conn:
            self.m_conn.execute("""
            insert into endpoint 
            ( ep_name, description, owner, url)
            values (?, ?, ?, ?)
            """, (endpoint, description, owner, url))

    def get_endpoint(self, endpoint):
        cursor = self.m_conn.cursor()

        cursor.execute("""
           select * from endpoint
           where ep_name=?
        """, (endpoint,))

        return cursor.fetchone()

    def get_endpoints_by_owner(self, owner):
        cursor = self.m_conn.cursor()

        cursor.execute("select * from endpoint where owner=?", (owner,))
        return cursor.fetchall()


    def check(self, endpoint):

        return True if self.get_endpoint(endpoint) else False
            
    def get_all(self):
        cursor = self.m_conn.cursor()

        cursor.execute("select * from endpoint")
        return cursor.fetchall()

    def dump_all(self):
        cursor = self.m_conn.cursor()

        cursor.execute("select * from endpoint")
        for line in cursor:
            print line


class TransferRequestTable(object):

    def __init__(self, db):
        self.m_db = db
        self.m_conn = db.m_conn

        self.forced_drop = True
        self.m_db.drop_table("trans_req", self.forced_drop)
        self.create_not_exist()

    def create_table(self):
        self.m_conn.execute("""
            create table trans_req
            (guid text, 
             from_ep text,
             to_ep text,
             user text,
             trans_protocol text,
             status text,
             submit_time timestamp,
             finish_time timestamp)
        """)

    def create_not_exist(self):
        if not self.m_db.check_exist_table("trans_req"):
            self.create_table()


    # API

    def create_new_request(self, guid, 
                                 from_ep, to_ep, 
                                 user, trans_protocol,
                                 status, 
                                 submit_time,
                                 ):
        with self.m_conn:
            self.m_conn.execute("""
            insert into trans_req
            ( guid, from_ep, to_ep, user, trans_protocol, status, submit_time)
            values (?, ?, ?, ?, ?, ?, ?)
            """, (guid, from_ep, to_ep, user, trans_protocol, status,
                  submit_time))

        return guid

    def get_request(self, guid):
        cursor = self.m_conn.cursor()

        cursor.execute("""
            select * from trans_req
            where guid=?
        """, (guid,))

        return cursor.fetchone()

    def modify_status(self, guid, status):
        with self.m_conn:
            self.m_conn.execute("""
                update trans_req 
                set status=?
                where guid=?
            """, (status, guid))

    def finish(self, guid, timestamp):
        with self.m_conn:
            self.m_conn.execute("""
                update trans_req 
                set finish_time=?
                where guid=?
            """, (timestamp, guid))

    def get_one(self, status):
        cursor = self.m_conn.cursor()

        cursor.execute("""
            select * from trans_req
            where status=?
        """, (status,))

        return cursor.fetchone()

    def get_all(self, status=None):
        cursor = self.m_conn.cursor()

        if status:
            cursor.execute("""
                select * from trans_req
                where status=?
            """, (status,))
        else:
            cursor.execute("""
                select * from trans_req
            """)

        return cursor.fetchall()


    def dump_all(self):
        cursor = self.m_conn.cursor()

        cursor.execute("select * from trans_req")
        for line in cursor:
            print line

class TransferFileListTabel(object):

    def __init__(self, db):
        self.m_db = db
        self.m_conn = db.m_conn

        self.forced_drop = True
        self.m_db.drop_table("trans_file", self.forced_drop)
        self.create_not_exist()

    def create_table(self):
        self.m_conn.execute("""
            create table trans_file
            (guid text, 
             file_index integer,
             from_path text,
             to_path text,
             status text,
             begin_time timestamp,
             finish_time timestamp)
        """)

    def create_not_exist(self):
        if not self.m_db.check_exist_table("trans_file"):
            self.create_table()

    def create_new_filelist(self, guid, filelist, status):
        new_list = ( (guid, i, fns[0], fns[1], status) 
                     for i, fns in enumerate(filelist) )
        with self.m_conn:
            self.m_conn.executemany("""
                insert into trans_file
                (guid, file_index, from_path, to_path, status)
                values (?, ?, ?, ?, ?)
            """, new_list)

    def modify_status(self, guid, file_index, status):
        with self.m_conn:
            self.m_conn.execute("""
                update trans_file
                set status=?
                where guid=? and file_index=?
            """, (status, guid, file_index))

    def get_one(self, guid, status):
        cursor = self.m_conn.cursor()

        cursor.execute("""
            select * from trans_file
            where guid=? and status=?
        """, (guid, status))

        return cursor.fetchone()

    def get_all(self, guid, status=None):
        cursor = self.m_conn.cursor()

        if status:
            cursor.execute("""
                select * from trans_file
                where guid=? and status=?
            """, (guid, status))
        else:
            cursor.execute("""
                select * from trans_file
                where guid=? 
            """, (guid,))

        return cursor.fetchall()

    def get_request_count(self, guid, status=None):
        cursor = self.m_conn.cursor()

        if status:
            cursor.execute("""
                select count(*) from trans_file
                where guid=? and status=?
            """, (guid, status))
        else:
            cursor.execute("""
                select count(*) from trans_file
                where guid=? 
            """, (guid,))

        result = cursor.fetchone()
        if result:
            return result[0]
        return 0


    def dump_all(self):
        cursor = self.m_conn.cursor()

        cursor.execute("select * from trans_file")
        for line in cursor:
            print line

if __name__ == "__main__":

    db = DB(":memory:")

    ep = EndPointTable(db)

    ep.create_endpoint("lintao#test1",
                       "For lintao.",
                       "lintao",
                       "ihep@192.168.237.112")
    ep.create_endpoint("lintao#test2",
                       "For lintao.",
                       "lintao",
                       "ihep@192.168.237.61")
    ep.dump_all()

    row = ep.get_endpoint("lintao#test1")
    if row:
        print row["url"]
    row = ep.get_endpoint("lintao#test3")
    if row:
        print row["url"]

    print ep.check("lintao#test3")

    tr = TransferRequestTable(db)

    import uuid
    import datetime

    guid = tr.create_new_request(str(uuid.uuid1()), 
                                 "lintao#test1",
                                 "lintao#test2",
                                 "lintao",
                                 "scp", 
                                 "new",
                                 datetime.datetime.now())

    row = tr.get_request(guid)
    if row:
        print row["status"]
        print row["submit_time"]

    tr.dump_all()

    tr.modify_status(guid, "transfer")
    tr.dump_all()

    import time
    #time.sleep(10)

    tr.finish(guid, datetime.datetime.now())
    tr.dump_all()

    tflt = TransferFileListTabel(db)

    filelist = [("/from/here", "/to/there"), 
                ("/from/here2", "/to/there2")]

    tflt.create_new_filelist(guid, filelist, "new")
    tflt.dump_all()

    tflt.modify_status(guid, 0, "transfer")
    tflt.dump_all()
