#!/bin/bash - 
#===============================================================================
#
#          FILE: prototype.sh
# 
#         USAGE: ./prototype.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Tao Lin (lintao51@gmail.com), 
#  ORGANIZATION: IHEP
#       CREATED: 
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

function object-prototype-doc() {
cat << EOF
The function name in bash can contain '.', '-', '/' or something else. 
We can use '.' to mimic the object method.

I think we can define two types functions:
* property
* normal function, get values from property
EOF
}

function A() {
    function A.doc() {
cat << EOF
    A is the constructor method.
EOF
    }
    # property
    function A.x() {
        local obj=$1; shift
        ${obj}.x
    }

    function A.y() {
        local obj=$1; shift
        ${obj}.y
    }
    # normal function
    function A.prod() {
        local obj=$1; shift
        echo $(($(${obj}.x) * $(${obj}.y)))
    }

    function A.init() {
        local obj=$1; shift
        local x=$1; shift
        local y=$1; shift
        # create function
        eval "${obj}.x () { echo ${x};}"
        eval "${obj}.y () { echo ${y};}"

        eval "${obj}.prod() { A.prod ${obj};}"
        eval "${obj}.doc() { A.doc;}"
    }

    A.init $*
}

function main() {
    A a 1 2

    a.x
    a.y

    a.prod

    a.doc
}

main
