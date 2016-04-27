#!/bin/bash

pkg-python() {
    local pkg=$FUNCNAME

    name Python
    ver  2.7.11
    url "https://www.python.org/ftp/python/$(ver)/Python-$(ver).tgz"

    homepage "https://www.python.org"
    desc "Interpreted, interactive, object-oriented programming language"

    options "with-tcl-tk"

    depends-on "dummy" :optional
    depends-on "dummy2" :optional

    show-depends-on
}
