#!/bin/bash
directory=$1

for f in $(find $directory -name '*.cxx' -or -name '*.h' -or -name '*.txx' -or -name '*.in' -or -name '*.cmake' -or -name '*.cc' -or -name '*.cpp') 
do 
    echo "Deleting trailing wspace: $f"
    sed -i 's/[ \t]*$//' "$f"
done
