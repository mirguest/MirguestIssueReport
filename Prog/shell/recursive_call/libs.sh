#!/bin/bash - 
#===============================================================================
#
#          FILE: libs.sh
# 
#         USAGE: ./libs.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Tao Lin (lintao51@gmail.com), 
#  ORGANIZATION: IHEP
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

function rec-fn () {
    local fn=$1
    local node=$2

    # handle the dependency first
    local depnode
    for depnode in $(dep-fn $node)
    do
        rec-fn $fn $depnode
    done
    # handle current node 
    $fn $node
}
