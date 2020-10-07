#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import time
import random
import sys

# Before the work
time.sleep(3)

# Do the work
for i in range(10):
    st = random.randint(3, 5)
    print "will sleep ", st
    sys.stdout.flush()
    time.sleep( st )
    print i
    sys.stdout.flush()
