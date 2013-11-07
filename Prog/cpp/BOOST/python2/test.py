#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import sys
sys.setdlopenflags( 0x100 | 0x2 )    # RTLD_GLOBAL | RTLD_NOW

import base
import svc

x = svc.create_svc()
print x.init()
print x.xxx()
