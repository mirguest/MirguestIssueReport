#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

from DIRAC.Core.Base import Script

Script.parseCommandLine( ignoreErrors = False )

for dataset in Script.getPositionalArgs():
    print dataset
