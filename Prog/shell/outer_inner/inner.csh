#!/bin/tcsh

set ARGS=($_)
echo '$ARGS: ' $ARGS
echo '$1: ' $1
echo '$2: ' $2


if ("$ARGS" != "" && "$1" == "") then
    echo "HELLO"
    echo ${ARGS[2]}
else
    echo "WORLD"
    echo ${ARGS[2]}
endif
