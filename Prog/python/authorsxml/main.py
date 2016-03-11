#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao

#############################################################################
# PART I: parse tex file
#############################################################################
## { "IHEP": 
##        {"RawTex": "Institute~of~High~Energy~Physics, Beijing",
##         ""
##        }
##    ,
## }

class EntryAffi(object):
    def __init__(self, name, raw):
        self.name = name
        self.raw_tex = raw
        self.magic()
    def magic(self):
        return
class EntryAuthor(object):
    def __init__(self, raw_name, affis):
        self.raw_name = raw_name
        self.affis = affis
        self.family_name = ""
        self.given_name = ""
        self.paper_name = ""
        self.magic()
    def magic(self):
        # check affis
        for a in self.affis:
            if map_tex_affi.has_key(a):
                # it's ok
                pass
            else:
                print "don't understand affi name: %s"%a
        # remove ~ and get the given/family name
        self.magic_name()
        return

    def magic_name(self):
        # J.~P.~Ochoa-Ricoux
        #    \  \ 
        #    i2  i1
        i1 = self.raw_name.rfind("~")
        self.family_name = self.raw_name[i1+1:]
        #print self.family_name 
        tmp_given_name = self.raw_name[:i1]
        #print tmp_given_name
        # if the name has -, give warning
        if tmp_given_name.find('-')>0:
            print "WARN: There is a dash in given name: %s"%self.raw_name
        self.given_name = tmp_given_name.replace('~', '')
        
        self.paper_name = "%s %s"%(self.given_name, self.family_name)

map_tex_affi = {}
map_tex_author = {}
map_paper_author = {}
list_tex_author = []

def parse_tex_line_affi(line):
    """
    \newcommand{\IHEP}{\affiliation{Institute~of~High~Energy~Physics, Beijing}}
               /    /              /                                        /
             i1    i2             i3                                       i4
    """
    length = len(line)
    i1 = line.find('{')
    i2 = line.find('}', i1)
    i3 = line.find('{', i2)
    i3 = line.find('{', i3+1)
    i4 = line.find('}', i3)

    abbr = line[i1+2:i2]
    raw = line[i3+1:i4]
    map_tex_affi[abbr] = EntryAffi( abbr, raw )

def parse_tex_line_author(line):
    """
    \author{S.~C.~Li}\HKU\VirginiaTech
          /        / |   |
        i1       i2  i   i
    """
    length = len(line)
    i1 = line.find('{')
    i2 = line.find('}', i1)

    raw_name = line[i1+1:i2]

    affis = []
    # after the raw name, the affiliation could be multiple
    i3 = line.find('\\', i2)
    while i3 < length:
        istart = i3+1
        iend = line.find('\\', istart)
        if iend < 0:
            iend = length
        affi = line[istart:iend]
        affis.append( affi )
        i3 = iend

    if map_tex_author.has_key(raw_name):
        print "author name conflict: ", raw_name

    ea = EntryAuthor(raw_name, affis)
    map_tex_author[raw_name] = ea
    map_paper_author[ea.paper_name] = ea
    list_tex_author.append( ea )

def parse_tex_line(line):
    line = line.strip()
    if line.startswith("#"):
        return
    # affiliation
    if line.find('affiliation') > 0:
        parse_tex_line_affi(line)
        return
    # author
    if line.find('author') > 0:
        parse_tex_line_author(line)
    return
def parse_tex(filename):
    with open(filename) as f:
        for line in f:
            parse_tex_line(line)

def format_it():
    for a in list_tex_author:
        #print "%s %s"%(a.given_name, a.family_name)
        print a.paper_name

def load_paper_name_from_xslt():
    with open("autogen-author-paper-name.txt") as f:
        for line in f:
            line = line.strip()

            # look for the name
            if map_paper_author.has_key(line):
                pass
            else:
                print "cannot find %s"%line 


if __name__ == "__main__":
    parse_tex("PhysRev.tex")
    format_it()
    load_paper_name_from_xslt()
