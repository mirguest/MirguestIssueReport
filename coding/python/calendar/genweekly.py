#!/usr/bin/env python
#
# Description: generate weekly in one year
#              such as:
#                * Week of 4 Jan 2021
#

import calendar

year = 2021

results = []

for month in range(1, 13):
    calendar_one_month = calendar.month(year, month).splitlines()
    # print(calendar_one_month)
    # parse the calendar
    #      December 2021
    #  Mo Tu We Th Fr Sa Su
    #         1  2  3  4  5
    #   6  7  8  9 10 11 12
    #  13 14 15 16 17 18 19
    #  20 21 22 23 24 25 26
    #  27 28 29 30 31
    str_month = calendar_one_month[0].strip()
    # print(str_month)
    for str_week in calendar_one_month[2:]:
        firstday_in_week = str_week[:3].strip()
        if not firstday_in_week:
            continue
        # print(firstday_in_week)
        result = "Week of %s %s"%(firstday_in_week, str_month)
        results.append(result)

for r in results[::-1]:
    print (r)
