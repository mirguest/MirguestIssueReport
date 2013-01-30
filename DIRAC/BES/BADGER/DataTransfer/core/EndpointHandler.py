#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import tornado.web

from Monitor import gMonitor

class EndPointListHandler(tornado.web.RequestHandler):

    @tornado.web.removeslash
    def get(self):
        result = gMonitor.list_endpoints()
        self.render("endpoint_list.html", result=result)

class EndPointNewHandler(tornado.web.RequestHandler):

    def get(self):
        self.render("endpoint_new.html")

    def post(self):
        ep_name = self.get_argument("ep_name")
        owner = self.get_argument("owner")
        url = self.get_argument("url")
        description = self.get_argument("description")

        gMonitor.create_endpoint(ep_name, description, owner, url)

        self.redirect("/endpoint")

class EndPointUserHandler(tornado.web.RequestHandler):

    def get(self, user):

        result = gMonitor.list_endpoints_by_owner(user)
        self.render("endpoint_user.html", 
                    user=user,
                    result=result)
