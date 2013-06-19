#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import hello

d = hello.dummy()

x = d.getx()
x.modify(10)

y = d.gety()
y.modify(12.34)

vx = d.getvx()
vx.modify(range(5))

vy = d.getvy()
vy.modify([1.23*i for i in range(5)])

d.run()
