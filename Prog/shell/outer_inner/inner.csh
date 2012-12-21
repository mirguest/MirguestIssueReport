#!/bin/tcsh

set ARGS=($_)
echo $ARGS
echo $1


if ("$ARGS" != "" && "$1" == "") then
    echo "HELLO"
else
    echo "WORLD"
endif
