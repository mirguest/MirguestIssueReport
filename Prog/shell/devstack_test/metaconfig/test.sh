#!/bin/bash  

export LOCALCONF=local.conf

function generate_metaconfig () {
cat << EOF > $LOCALCONF 

[[local|localrc]]
[DEFAULT]
a=b
fun xyz
fun xyz xyz2
EOF
}

function test_get_meta_section () {
    source config
    generate_metaconfig 
    get_meta_section $LOCALCONF local localrc

}

function test_get_meta_section_files () {
    source config
    generate_metaconfig 
    get_meta_section_files $LOCALCONF local
}

function test_merge_config_file () {
    source config
    generate_metaconfig 
    merge_config_file $LOCALCONF local localrc
}

test_get_meta_section
test_get_meta_section_files
test_merge_config_file
