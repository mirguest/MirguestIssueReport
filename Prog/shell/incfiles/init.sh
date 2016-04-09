#!/bin/bash

function @ { 
    filename=$1; shift; 
    eval $(echo "$(cat $filename) $*"); 
}
# so we can use @ to include the file which defines several variables.
