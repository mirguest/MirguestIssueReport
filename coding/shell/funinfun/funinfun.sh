#!/bin/bash

function f {
    if [ $# -gt 0 ]; then
        function g {
            echo hello
        }
    g
    fi
}

f
f 2
f 3
