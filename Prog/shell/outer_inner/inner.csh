#!/bin/tcsh

set ARGS=($_)
if ( "$ARGS" != "" ) then
    echo '$ARGS: ' $ARGS
    echo '$ARGS[0]: ' ${ARGS[0]}
    echo '$ARGS[1]: ' ${ARGS[1]}
    echo '$ARGS[2]: ' ${ARGS[2]}
endif
echo '$0: ' $0
echo '$1: ' $1
echo '$2: ' $2


if ("$ARGS" != "" && "$1" == "") then
    echo "HELLO"
else
    echo "WORLD"
endif
