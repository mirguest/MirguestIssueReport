#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import tornado.web

from Monitor import gMonitor

class EndPointListHandler(tornado.web.RequestHandler):

    def get(self):
        result = gMonitor.list_endpoints()
        self.render("endpoint_list.html", result=result)
