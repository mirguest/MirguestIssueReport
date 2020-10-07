#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

import sys
helpmore = False
if '--help-more' in sys.argv:
    helpmore = True

import argparse

parser = argparse.ArgumentParser(description='Run JUNO Detector Simulation.')
parser.add_argument("--evtmax", type=int, default=10, help='events to be processed')
parser.add_argument("--help-more", action='store_true')
# put hide options
def h(helpstr):
    if helpmore:
        return helpstr
    return argparse.SUPPRESS
parser.add_argument("--mac", default="run.mac", help=h("mac "))


args = parser.parse_args()
if '--help-more' in sys.argv:
    parser.print_help()
