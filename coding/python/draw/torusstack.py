#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import matplotlib.pyplot as plt

fig = plt.figure(1, figsize=(15,15))
ax = fig.add_subplot(111,aspect='equal')  
#ax.set_xlim(-255, 0)
ax.set_xlim(-370, 370)
#ax.set_ylim(-370, 255)
ax.set_ylim(-450, 255)

circle1=plt.Circle((0, -127), radius=(127+188), fill=False, color='r')
ax.add_artist(circle1)
circle2=plt.Circle((-103.451, 0), radius=(150.549), fill=False, color='g')
ax.add_artist(circle2)

#circle3=plt.Circle((0, -77.585), radius=(265.585), fill=False, color='b')
#ax.add_artist(circle3)

circle4=plt.Circle((-34.1509, 127), radius=(293.976), fill=False, color='b')
ax.add_artist(circle4)

circle5=plt.Circle((-191.449, -195), radius=(64.4487), fill=False, color='r')
ax.add_artist(circle5)

circle7=plt.Circle((-52.0203, -280), radius=(75.0064), fill=False, color='g')
ax.add_artist(circle7)

circle8=plt.Circle((-56.8317, -370), radius=(15.4817), fill=False, color='b')
ax.add_artist(circle8)

line0 = plt.Line2D(*(zip((-255, 188), (0, 188))))
ax.add_artist(line0)

line1 = plt.Line2D(*(zip((-255, 116.71), (0, 116.71))))
ax.add_artist(line1)

line2 = plt.Line2D(*(zip((-255, 0), (0, 0))))
ax.add_artist(line2)

line3 = plt.Line2D(*(zip((-255, -116.71), (0, -116.71))))
ax.add_artist(line3)

line4 = plt.Line2D(*(zip((-255, -136.05), (0, -136.05))))
ax.add_artist(line4)

line5 = plt.Line2D(*(zip((-255, -195), (0, -195))))
ax.add_artist(line5)

line6 = plt.Line2D(*(zip((-255, -282), (0, -282))))
ax.add_artist(line6)

line7 = plt.Line2D(*(zip((-255, -355), (0, -355))))
ax.add_artist(line7)

line8 = plt.Line2D(*(zip((-255, -370), (0, -370))))
ax.add_artist(line8)

line9 = plt.Line2D(*(zip((-255, -422), (0, -422))))
ax.add_artist(line9)

linev1 = plt.Line2D(*(zip((-127, -195), (-127, -282))))
ax.add_artist(linev1)

linev2 = plt.Line2D(*(zip((-41.35, -370), (-41.35, -422))))
ax.add_artist(linev2)

plt.plot(*zip((0, 188), (-198.55, 116.71), (-254,0),
              (-198.55, -116.71), (-165.4, -136.05), (-127, -195),
              (-127, -282), (-53, -355), (-41.35, -370), 
              (-41.35, -422),
             ), marker='D', ls='')

plt.savefig("R3600-TorusStack.png")
plt.show()
