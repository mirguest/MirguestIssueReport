#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao


import Sniper

if __name__ == "__main__":

    task = Sniper.Task("task")
    task.setEvtMax(1)
    task.setLogLevel(2)

    Sniper.loadDll("libDatabaseSvc.so")
    import libDatabaseSvc
    dbsvc = task.createSvc("MyMongoDB")
    print dbsvc
