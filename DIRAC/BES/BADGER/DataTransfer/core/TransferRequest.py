#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

# This is the Request Service.
# Using tornado

import tornado.ioloop
import tornado.web
import tornado.escape

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

        self.redirect("/request/%s"%result)

class RequestListHandler(tornado.web.RequestHandler):
    def get(self, guid):
        files_result = gMonitor.list_request_files(guid)

        requst_result = gMonitor.m_transfer_request.get_request(guid)
        if requst_result and requst_result["status"] in ("open"):
            # If the status is open, we can modify the file list.
            self.write('<div>')
            self.write(requst_result["from_ep"])
            self.write(' -> ')
            self.write(requst_result["to_ep"])
            self.write('</div>')

            self.write("""
            <form action="/request/%s" method="post">
            <textarea name="from_to_list" rows="10" cols="76">"""%guid)
            self.write("""</textarea> 
            <input type="submit">
            </form>
            """)

        self.write(guid)

        # the current list

        self.write('<table>')
        self.write('<tr>')
        self.write('<th>From</th>')
        self.write('<th>To</th>')
        self.write('</tr>')
        for per_file in files_result:
            self.write('<tr>')
            self.write('<td>%s</td>'%(per_file["from_path"]))
            self.write('<td>%s</td>'%(per_file["to_path"]))
            self.write('</tr>')

        self.write('</table>')

        # Only submit the open
        if requst_result and requst_result["status"] in ("open"):
            self.write("""
            <form action="/request/submit/%s" method="post">
            <input type="submit"/>
            </form>
            """%guid)

    
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

application = tornado.web.Application([
    (r"/request/new", RequestNewHandler),
    (r"/request/submit/(.+)", RequestSubmitHandler),
    (r"/request/(.+)", RequestListHandler),
    (r"/.*", MainHandler),
])

if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.instance().start()
