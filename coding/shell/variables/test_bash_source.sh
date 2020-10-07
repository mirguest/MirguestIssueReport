#!/bin/bash

function f1 () {
    echo ${FUNCNAME}
    echo ${BASH_SOURCE}
    echo ${FUNCNAME[@]}
    echo ${BASH_SOURCE[@]}
}

function f2 () {
    echo ${FUNCNAME}
    echo ${BASH_SOURCE}
    echo ${FUNCNAME[@]}
    echo ${BASH_SOURCE[@]}

    f1
}

echo ${BASH_SOURCE}
echo ${BASH_SOURCE[@]}

f2
