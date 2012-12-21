#!/bin/tcsh

set ARGS=($_)
echo $ARGS
echo $1


if ("$ARGS" != "" && "$1" == "") then
    echo "HELLO"
    echo ${ARGS[2]}
else
    echo "WORLD"
endif
