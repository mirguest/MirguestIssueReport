#!/bin/bash

# vim: set expandtab:

MAILMANBIN=/usr/lib/mailman/bin

function get_lists()
{
    echo `$MAILMANBIN/list_lists -b`;
}

function save_list_member_into_dir()
{
    listname="$1";
    dirname="$2"
    
    if [ -z "$listname" ]; then
        echo "Need a list name"
        exit -1
    fi
    if [ -z "$dirname" ]; then
        echo "Need a Directory name"
        exit -1
    fi

    if [ ! -d "$dirname" ]; then
        # if the dir does not exist.
        # create a new dir.
        mkdir "$dirname"
    fi

    filename="$dirname/$listname"

    if [ -f "$filename" ]; then
        filename="$filename.`date +%Y%m%d`"
    fi

    $MAILMANBIN/list_members $listname > $filename
}

function save_all_into_one_date() {
    dirname=`date +%Y%m%d`

    if [ ! -d "$dirname" ]; then
        mkdir "$dirname"
    fi

    for listname in `get_lists`
    do
        echo save $listname
        save_list_member_into_dir "$listname" "$dirname"
    done
}

save_all_into_one_date

