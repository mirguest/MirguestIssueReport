#!/bin/bash

# Using command_not_found_handle to override the 
# object getter/setter
function command_not_found_handle() {
    local cmd=$1
    local obj=$(echo $cmd|cut -d '.' -f 1)
    local method=$(echo $cmd|cut -d '.' -f 2)

    echo $obj $method
    # find the class name
    # indirect reference
    local cls=${!obj[__cls__]}
    echo $obj cls: $cls

    $cls __magic__ $obj $method
}

# class def
function Class () {
    local cls=$FUNCNAME

    # constructor 
    init() {
        local this=$1; shift
        eval "${this}[__cls__]=$cls"
    }

    hello() {
        local this=$1; shift
        echo hello
    }

    # magic handle
    if [ "$1" != "__magic__" ]; then
        init $*
    else
        shift;
        local obj=$1; shift
        local method=$1; shift
        # check method here
        if type -t $method >& /dev/null; then
            # call it
            $method $obj $*
        else
            echo $cls.$method unknown.
        fi
    fi
}

Class a
echo ${a[__cls__]}
a.hello
a.world
