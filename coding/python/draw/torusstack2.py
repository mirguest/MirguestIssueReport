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
rect = plt.Rectangle((-255,116.71),255, (188-116.71), facecolor="none", edgecolor="none")
ax.add_artist(circle1)
ax.add_artist(rect)
circle1.set_clip_path(rect)

circle2=plt.Circle((-103.451, 0), radius=(150.549), fill=False, color='g')
rect = plt.Rectangle((-255,-116.71),255, (2*116.71), facecolor="none", edgecolor="none")
ax.add_artist(circle2)
ax.add_artist(rect)
circle2.set_clip_path(rect)

#circle3=plt.Circle((0, -77.585), radius=(265.585), fill=False, color='b')
#ax.add_artist(circle3)

circle4=plt.Circle((-34.1509, 127), radius=(293.976), fill=False, color='b')
rect = plt.Rectangle((-255,-136.05),255, (136.05-116.71), facecolor="none", edgecolor="none")
ax.add_artist(circle4)
ax.add_artist(rect)
circle4.set_clip_path(rect)

circle5=plt.Circle((-191.449, -195), radius=(64.4487), fill=False, color='r')
rect = plt.Rectangle((-255,-195),255, (-136.05+195), facecolor="none", edgecolor="none")
ax.add_artist(circle5)
ax.add_artist(rect)
circle5.set_clip_path(rect)

circle7=plt.Circle((-52.0203, -280), radius=(75.0064), fill=False, color='g')
rect = plt.Rectangle((-255,-355),255, (355-282), facecolor="none", edgecolor="none")
ax.add_artist(circle7)
ax.add_artist(rect)
circle7.set_clip_path(rect)

circle8=plt.Circle((-56.8317, -370), radius=(15.4817), fill=False, color='b')
rect = plt.Rectangle((-255,-370),255, (-355+370), facecolor="none", edgecolor="none")
ax.add_artist(circle8)
ax.add_artist(rect)
circle8.set_clip_path(rect)

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

plt.savefig("R3600-TorusStack-with-CLIP.png")
plt.show()
