#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import calendar

class MYHTMLCalendar(calendar.HTMLCalendar):
    def formatmonth(self, theyear, themonth, withyear=True):
        """
        Return a formatted month as a table.
        """
        v = []
        a = v.append
        #a('<table border="1" cellpadding="0" cellspacing="0" class="month" style="width: 50%">')
        a('<table border="1" cellpadding="0" cellspacing="0" class="month" style="-evernote-table:true;border-collapse:collapse;margin-left:0px;table-layout:fixed;width:100%;">')
        a('\n')
        a(self.formatmonthname(theyear, themonth, withyear=withyear))
        a('\n')
        a(self.formatweekheader())
        a('\n')
        for week in self.monthdays2calendar(theyear, themonth):
            a(self.formatweek(week))
            a('\n')
        a('</table>')
        a('\n')
        return ''.join(v)

    def formatday(self, day, weekday):
        """
        Return a day as a table cell.
        """
        if day == 0:
            return '<td style="border-style:solid;border-width:1px;border-color:rgb(211,211,211);padding:10px;margin:0px;width:10%;" class="noday">&nbsp;</td>' # day outside month
        else:
            return '<td style="border-style:solid;border-width:1px;border-color:rgb(211,211,211);padding:10px;margin:0px;width:10%%;" class="%s">%d</td>' % (self.cssclasses[weekday], day)

cal = MYHTMLCalendar()

with open("cal.html", "w") as f:
    f.write(cal.formatyearpage(2016, 1))

with open("cal-single.html", "w") as f:
    f.write("<html><body>")
    for i in range(1, 13):
        f.write(cal.formatmonth(2016, i))
        f.write("<br/>")
    f.write("</body></html>")
