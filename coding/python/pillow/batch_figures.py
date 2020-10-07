#!/usr/bin/env python
#-*- coding: utf-8 -*-
#-*- author: Tao Lin -*-

# Description:
#   Generate batch figures from a template figure. The name and donation will be put on the figures.

from PIL import Image, ImageFont, ImageDraw

class FigureGenerator(object):

    def __init__(self):
        # self.path_to_ttf = r'/mnt/c/Windows/Fonts/msyh.ttc'
        self.path_to_ttf = r'/mnt/c/Windows/Fonts/simkai.ttf'
        self.font = ImageFont.truetype(self.path_to_ttf, size=36)
        self.font_small = ImageFont.truetype(self.path_to_ttf, size=30)
        self.template_path = r"template.png"

    def gen(self, email, name, donation):
        # 打开指定文件
        with Image.open(self.template_path) as img:
            # 写文字
            draw = ImageDraw.Draw(img)
            if len(name) < 10:
                draw.text(xy=(100, 130), text=name.decode("UTF-8"), font=self.font,fill=(0,0,0,255))
            else:
                draw.text(xy=(40, 130), text=name.decode("UTF-8"), font=self.font_small,fill=(0,0,0,255))
            draw.text(xy=(100, 182), text=donation.decode("UTF-8"), font=self.font,fill=(0,0,0,255))
            
            # 输出
            img.save("%s.png"%email)

    def genall(self, csvfile):
        import csv
        with open(csvfile) as f:
            reader = csv.reader(f)
            for row in reader:
                name = row[0].strip()
                donation = row[3].strip()
                email = row[4].strip()
                self.gen(email, name, donation)

if __name__ == "__main__":
    fg = FigureGenerator()
    
    fg.genall(r"persons.csv")
