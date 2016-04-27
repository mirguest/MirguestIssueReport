#!/bin/bash

function @ { 
    filename=$1; shift; 
    eval $(echo "$(cat $filename) $*"); 
}
# so we can use @ to include the file which defines several variables.

# another implementation: use command_not_found_handle
if declare -f orig_command_not_found_handle >& /dev/null; then
eval orig_"$(declare -f command_not_found_handle)"
fi
function command_not_found_handle() {
    cmd=$1
    case $cmd in
        @*)
            handle_with_at $*
            ;;
        *)
            orig_command_not_found_handle $*
            ;;
    esac
}

function handle_with_at() {
    local filename=$(echo $1 | cut -c2-); shift
    eval $(echo "$(cat $filename) $*"); 
}
