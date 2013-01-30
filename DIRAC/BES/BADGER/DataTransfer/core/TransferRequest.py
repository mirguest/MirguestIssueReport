#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

# This is the Request Service.
# Using tornado

import os.path

import tornado.ioloop
import tornado.web
import tornado.escape

from Monitor import gMonitor

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write('Hello, World')

class RequestNewHandler(tornado.web.RequestHandler):
    def get(self):
        self.render("request_new.html")

    def post(self):
        user = self.get_argument("user")
        from_ep = self.get_argument("from_ep")
        to_ep = self.get_argument("to_ep")
        trans_protocol = self.get_argument("trans_protocol")

        # Handle these INFO.

        result =  gMonitor.get_open_request(from_ep, to_ep,
                                            user,
                                            trans_protocol)

        # Redirect to the NEW Request GUID.

        self.redirect("/request/%s"%result)

class RequestListFileHandler(tornado.web.RequestHandler):
    def get(self, guid):
        files_result = gMonitor.list_request_files(guid)

        request_result = gMonitor.m_transfer_request.get_request(guid)

        self.render("request_listfiles.html",
                    guid = guid,
                    files_result=files_result,
                    request_result=request_result)
    
    def post(self, guid):
        result = tornado.escape.url_unescape( 
                        self.get_argument("from_to_list") )
        file_list = []

        # Parse the result

        for line in result.splitlines():
            line = line.strip()
            if not line:
                continue
            from_path, to_path = map(lambda x: x.strip(), line.split(","))
            file_list.append( (from_path, to_path) )

        gMonitor.m_transfer_file.create_new_filelist(guid, file_list, "new")

        self.redirect("/request/%s"%guid)

class RequestSubmitHandler(tornado.web.RequestHandler):

    def post(self, guid):
        gMonitor.submit_open_request(guid)
        self.redirect("/request/%s"%guid)

settings = dict(
        static_path=os.path.join(os.path.dirname(__file__), "static"),
        template_path=os.path.join(os.path.dirname(__file__), "template"),
)


application = tornado.web.Application([
    (r"/request/new", RequestNewHandler),
    (r"/request/submit/(.+)", RequestSubmitHandler),
    (r"/request/(.+)", RequestListFileHandler),
    (r"/.*", MainHandler),
], **settings)

if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.instance().start()
