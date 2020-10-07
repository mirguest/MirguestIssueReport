#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import os
import os.path

#--------------------------------------------------------------------------#
import string
class JobFormatter(string.Formatter):
    def get_field(self, field_name, args, kwargs):
        try:
            obj, arg_used = super(JobFormatter, self).get_field(field_name, args, kwargs)

            return obj, arg_used
        except KeyError as e:
            return "{%s}"%field_name, field_name

jf = JobFormatter()

#--------------------------------------------------------------------------#

def get_JOB_PATH():
    return os.environ.get("JOB_PATH", "").split(":")

class JobTemplate(object):

    def __init__(self, jobname):

        self._jobname = jobname

        self._realpath = self.search_in_path(jobname)

        self._content = self.load(self._realpath)

    @property
    def content(self):
        return self._content

    def format(self, *args, **kwargs):
        return jf.format(self.content, *args, **kwargs)

    def search_in_path(self, jobname):
        if os.path.exists(jobname):
            return os.path.abspath(jobname)
        for jp in get_JOB_PATH():
            tmppath = os.path.abspath( 
                        os.path.expanduser( os.path.join(jp, jobname)))
            if os.path.exists( tmppath ):
                return tmppath
        raise RuntimeError("Can't Find the Job Template in JOB_PATH.")

    def load(self, filename):
        with open(filename) as f:
            return f.read()

    @property
    def name(self):
        return self.gen_name()

    def gen_name(self):
        raise NotImplementedError

# Job Object is an example to show how to combine 
# the template and the object.

class JobObject(object):

    def __init__(self):
        self.i = 0
    
    @property
    def ok(self):
        self.i += 1
        return self.i

    @property
    def func(self):
        return "hello"

if __name__ == "__main__":
    jt = JobTemplate("test.txt")
    hello = JobObject()
    print jt.format(hello=hello)
    print jt.format(hello=hello)
