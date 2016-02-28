#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import argparse

parser = argparse.ArgumentParser(description='Run JUNO Detector Simulation.')
parser.add_argument("--evtmax", type=int, default=10, help='events to be processed')
parser.add_argument("--help-more", action='store_true')
helpmore = parser.parse_args()
print helpmore
# put hide options
def h(helpstr):
    if helpmore.help_more:
        return helpstr
    return argparse.SUPRESS
parser.add_argument("--mac", default="run.mac", help=h("mac "))


args = parser.parse_args()
if args.help_more:
    parser.print_help()
