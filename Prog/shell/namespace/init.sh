#!/bin/bash
# NOTE: pkg is used to share the information,
# that means we can only install one packages at once.
# If we need to install dependencies, just call them 
# in sub-shell.

# meta constructor
# XXX name -> name
function XXX() {
    local meta=$1; shift
    if [ -z "$*" ]; then
        # getter
        ${pkg}-${meta}
    else
        # setter
        eval "${pkg}-${meta}() { echo $*; }"
    fi
}

# define meta data
function name    () { XXX $FUNCNAME $*; }
function ver     () { XXX $FUNCNAME $*; }
function url     () { XXX $FUNCNAME $*; }
function desc    () { XXX $FUNCNAME $*; }
function homepage() { XXX $FUNCNAME $*; }

# option constructor
# by default, options will be turned off
# on or off
function options() {
    local opt=$1; shift
    local val=${1:-off}; shift
    
    eval "${pkg}-${opt}() { echo $val; }"
}

# depends on
# pkg: 
#    pkg or collections
# options:
#    * :optional
#    * :recommended
function depends-on() {
    local deppkg=$1; shift
    local depopt=$1; shift
    # we can check it directly

    # or let pkg-check to load it.
    # use a cache
    eval PKG_$(name)_DEPENDLIST=\"\${PKG_$(name)_DEPENDLIST} $deppkg\"
    eval "${pkg}-depends-on-${deppkg}() { echo $depopt; }"
}

function show-depends-on() {
    eval local list=\"\${PKG_$(name)_DEPENDLIST}\"
    local i
    for i in ${list}
    do
        echo $i $(${pkg}-depends-on-${i})
    done
}
