#!/bin/bash

function get-child() {
    local parent=$1
    local list=
    local child=$(ps --ppid $parent -o pid h)
    for c in $child;
    do
        # check the child again
        if ps --pid $c -o pid h >& /dev/null; then
            echo $c
            get-child $c
        fi
    done
}

function filter-child() {
    for c in $*
    do
        if (ps --pid $c -o args h | grep sleep) >& /dev/null ;
        then
            echo $c
        fi
    done
}

function mom() {
    local parent=$1
    sleep 1
    echo parent: $parent
    local child=$(get-child $parent)
    child=$(filter-child $child)
    echo child: $child
}

mom $$ &

### real program
(time sleep 10)
