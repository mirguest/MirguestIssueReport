#!/bin/bash
export LANG=C
export LC_ALL=C

init-self() {
    source init.sh
    source cmd.sh
}

load-module() {
    local func=$FUNCNAME
    local mod=$1; shift
    local mod_func=pkg-$mod
    local pkg=$mod_func
    local mod_script=${mod}.sh

    source $mod_script
    # create new wrapper function
    # eg. python => -python

    if type -t ${mod_func} >& /dev/null; then
        # ok
        # init
        ${mod_func}
        # call
        ${mod_func}-name
        ${mod_func}-ver
        ${mod_func}-url
        parse-cmds $*
    fi

    # trigger the command
    pkg-$cmd
}

parse-cmds() {
    local opt
    for opt in $*; 
    do
        case $opt in
            --with-*)
                options $(echo $opt|cut -c3-) on
                ;;
            --without-*)
                options with-$(echo $opt|cut -c11-) off
                ;;
            *)
                echo 1>&2 unknown $opt
        esac
    done
}

main() {
    init-self
    local cmd=$1; shift
    local pkg=$1; shift
    load-module $pkg $*
}

#main $*
main install python --with-tck-tk
pkg-python-with-tck-tk

#main install python --without-tck-tk
#pkg-python-with-tck-tk
