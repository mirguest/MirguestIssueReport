#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import hello

d = hello.dummy()

hello.setProperty("dummy", "x", 42)
hello.setProperty("dummy", "y", 12.34)

hello.setProperty("dummy", "vx", range(5))
hello.setProperty("dummy", "vy", [1.23*i for i in range(5)])

hello.setProperty("dummy", "mx", {str(i):i for i in range(5)})
hello.setProperty("dummy", "my", {str(i):i*1.23 for i in range(5)})

d.run()
