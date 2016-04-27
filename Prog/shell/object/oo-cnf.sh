#!/bin/bash

function oo-debug() {
    return
    #echo 1>&2 $*
}

# Using command_not_found_handle to override the 
# object getter/setter
function command_not_found_handle() {
    local cmd=$1; shift
    local obj=$(echo $cmd|cut -d '.' -f 1)
    local method=$(echo $cmd|cut -d '.' -f 2)

    oo-debug $obj $method
    # find the class name
    # indirect reference
    if type -t ${obj}.__cls__ >& /dev/null ; then
        local cls=$(${obj}.__cls__)
        $cls __magic__ $obj $method $*
        return
    fi
}

# class def
function Class () {
    local cls=$FUNCNAME

    # constructor 
    init() {
        local this=$1; shift
        eval "${this}.__cls__() { echo $cls; }"
        eval "${this}.__var__() { echo 10; }"
    }

    hello() {
        local this=$1; shift
        echo hello
    }

    var() {
        local vn=$FUNCNAME
        local this=$1; shift
        local newval=$1
        if [ -z "$newval" ]; then
            # getter
            local v=${!this[_var]}
            echo $this.$vn $v
        else
            # setter
            eval "${this}[_$vn]=$newval"
            echo ${!this[_var]}
        fi

    }

    # magic handle
    if [ "$1" != "__magic__" ]; then
        oo-debug init begin
        init $*
        oo-debug init end
    else
        shift;
        local obj=$1; shift
        local method=$1; shift
        # check method here
        if type -t $method >& /dev/null; then
            # call it
            oo-debug $method $obj $*
            $method $obj $*
        else
            echo $cls.$method unknown.
        fi
    fi
}

Class a
a.hello
exit
a.var 1
a.var
echo ${a[var]}
