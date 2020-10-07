#!/bin/bash

# Refer: http://en.wikipedia.org/wiki/Here_document
# Refer: http://serverfault.com/questions/72476/clean-way-to-write-complex-multi-line-string-to-a-variable
var=`python << EOF
print "echo 1 ;"
print "\n"
print "echo 2 ;"
EOF
`
echo $var
$var

var2=$(python << EOF
print "hello"
print "hello"
EOF
)
echo $var2

for i in $var2
do
  echo $i
done
