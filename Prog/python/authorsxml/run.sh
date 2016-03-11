#!/bin/bash

function get-list-of-author-paper-name() {
    xsltproc get_papername.xsl authors.xml > autogen-author-paper-name.txt
}

#############################################################################
# alias name
#############################################################################
function apn() { get-list-of-author-paper-name; }
$*
