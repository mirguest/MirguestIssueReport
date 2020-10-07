#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

# dummy variable

PMT = {
        "R": 254.00,
        "H": 680.00,
        "POINT":
            ((0.00, 254.00),
             (-254.00, 0.00),
             (-254.00/2**0.5, -254.00/2**0.5),
             (-254.00/2**0.5, -426.00),
            ),
        "CIRCLE":
            ((0.00, 0.00, 254.00),
            ),

        }

import matplotlib.pyplot as plt

fig = plt.figure(1, figsize=(15,15))
ax = fig.add_subplot(111,aspect='equal')  
#ax.set_xlim(-255, 0)
ax.set_xlim(-370, 370)
#ax.set_ylim(-370, 255)
ax.set_ylim(-450, 265)

circle1 = plt.Circle((0.00, 0.00), radius=254.00, fill=False, color='r')
ax.add_artist(circle1)

linev1 = plt.Line2D(*(zip(
                            (-254.00/2**0.5, -254.00/2**0.5), 
                            (-254.00/2**0.5, -426.00),
                         )))
ax.add_artist(linev1)
linev1_2 = plt.Line2D(*(zip(
                            (254.00/2**0.5, -254.00/2**0.5), 
                            (254.00/2**0.5, -426.00),
                         )))
ax.add_artist(linev1_2)

line1 = plt.Line2D(*(zip(
                            (-254.00/2**0.5, -426.00), 
                            (254.00/2**0.5, -426.00),
                         )))
ax.add_artist(line1)

line2 = plt.Line2D(*(zip(
                            (-254.00/2**0.5, -254.00/2**0.5), 
                            (254.00/2**0.5, -254.00/2**0.5),
                         )))
ax.add_artist(line2)

line3 = plt.Line2D(*(zip(
                            (-254.00/2**0.5, -254.00/2**0.5), 
                            (0.00, 0.00),
                         )))
ax.add_artist(line3)

linev2 = plt.Line2D(*(zip(
                            (0.00, 0.00), 
                            (0.00, -254.00/2**0.5),
                         )))
ax.add_artist(linev2)

plt.plot((0.0,),(0.0,),
         marker='D', ls='')

txt_center = plt.Text(0.00, 0.00, "(0.00, 0.00)")
ax.add_artist(txt_center)

plt.plot(*zip(*PMT["POINT"]),
         marker='D', ls='')

for x,y in PMT["POINT"]:
    t = plt.Text(x, y, "(%.2f, %.2f)"%(x,y))
    ax.add_artist(t)

plt.savefig("DUMMY-TorusStack.png")
plt.show()
