#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

# This is the Request Service.
# Using tornado

import tornado.ioloop
import tornado.web

from Monitor import gMonitor

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write('Hello, World')

class RequestNewHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("""
            <html>
            <body>
            <form action="/request/new" method="post">
            User: <input type="text" name="user" />
            From: <input type="text" name="from_ep" />
            To: <input type="text" name="to_ep" />
            Trans: <input type="text" name="trans_protocol" />
            <input type="submit">
            </form>
            </body>
            </html>
        """)
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

        self.write(result)




application = tornado.web.Application([
    (r"/", MainHandler),
    (r"/request/new", RequestNewHandler),
])

if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.instance().start()
