#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

from jobgen import JobTemplate

jt = JobTemplate("run.mac")

class RunMac(object):
    def __init__(self, event, run):
        self.event = event
        self.run = run

    
    @property
    def SourceAppend(self):
        return "/dyb2/gen/source/append gamma 2.220 MeV"
    @property
    def SetPosition(self):
        return "/dyb2/gen/pos/face 10 cm"
    @property
    def AcrylicThickness(self):
        return "10 cm"
    @property
    def OutputFileName(self):
        return "ROOT.{EVENT}.{RUN}.root".format(EVENT=self.event, 
                                                RUN=self.run)
    @property
    def Seed(self):
        return str(self.event)
    @property
    def Run(self):
        return str(self.run)

runmac = RunMac(1, 1)

print jt.format(RunMac=runmac)
