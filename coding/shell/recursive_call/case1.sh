#!/bin/bash - 
#===============================================================================
#
#          FILE: case1.sh
# 
#         USAGE: ./case1.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Tao Lin (lintao51@gmail.com), 
#  ORGANIZATION: 
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

function import-libs() {
    source libs.sh
}
# construct the node structure
function node-a() {
    echo a
}
function node-a-dep() {
    echo b c d
}
function node-b() {
    echo b
}
function node-b-dep() {
    echo e
}
function node-c() {
    echo c
}
function node-c-dep() {
    echo e
}
function node-d() {
    echo d
}
function node-d-dep() {
    echo 
}

# construct fn
function echo-fn () {
    echo $1
}
# construct dep-fn
function dep-fn() {
    local node=$1
    type -t "node-${node}-dep" 1>&2 && node-${node}-dep
}

function main() {
    import-libs

    rec-fn echo-fn a
}

main
