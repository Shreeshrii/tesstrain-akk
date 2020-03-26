#!/bin/bash
# uses create_dictdata from https://github.com/wincentbalin/pytesstrain
shuf akk.txt > tmp
bash clean.sh
create_dictdata -d ./ -i tmp -l akk
rm tmp
rm *bigram*
