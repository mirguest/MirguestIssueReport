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

function object-prototype-property() {
    local obj=$1; shift
    local method=$1; shift
    local value="$*"
    # create getter
    eval "${obj}.${method}() { echo $value; }"
}

function object-property-method() {
    local cls=$1; shift
    local obj=$1; shift
    local method=$1; shift

    eval "${obj}.${method}() { ${cls}.${method} ${obj} \$*;}"
}

function A() {
    local cls=${FUNCNAME}

    function A.doc() {
cat << EOF
    A is the constructor method.
EOF
    }
    # normal function
    function A.prodxy() {
        local obj=$1; shift
        echo $(($(${obj}.x) * $(${obj}.y)))
    }

    function A.prodx() {
        local obj=$1; shift
        local val=$1; shift
        echo $(($(${obj}.x) * ${val}))
    }

    function A.init() {
        # keep the obj in the method
        local obj=$1; shift;
        local x=$1; shift
        local y=$1; shift
        # create property
        object-prototype-property ${obj} x $x
        object-prototype-property ${obj} y $y
        # create normal method
        object-property-method ${cls} ${obj} prodxy
        object-property-method ${cls} ${obj} prodx
        object-property-method ${cls} ${obj} doc
    }

    A.init $*
}

function main() {
    A a 1 2

    a.x
    a.y

    a.prodxy
    a.prodx 3

    a.doc

    A a2 13 2

    a2.x
    a2.y

    a2.prodxy
    a2.prodx 3

    a2.doc
}

main
