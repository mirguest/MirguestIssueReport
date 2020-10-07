#!/bin/bash

function f() {
    return 0
}

f || {
    echo hello
}

function g() {
    return 1
}

g || {
    echo hello
    exit
}

echo end
