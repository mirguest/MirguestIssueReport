#!/bin/bash

function get-list-of-author-paper-name() {
    xsltproc get_papername.xsl authors.xml > autogen-author-paper-name.txt
}

function get-list-of-org-paper-name() {
    xsltproc get_affils.xsl authors.xml > autogen-org-paper-name.txt
}

#############################################################################
# alias name
#############################################################################
function apn() { get-list-of-author-paper-name; }
function opn() { get-list-of-org-paper-name; }
$*
