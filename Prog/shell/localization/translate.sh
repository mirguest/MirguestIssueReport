#!/bin/bash

# create an directory for translating message.
mkdir -p locale/zh_CN/LC_MESSAGES

# Generate hello.pot
bash --dump-po-strings hello.sh > hello.pot

# Edit it.
vim hello.pot

# save.

msgfmt -o locale/zh_CN/LC_MESSAGES/hello.mo hello.pot
