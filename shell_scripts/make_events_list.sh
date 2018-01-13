#!/bin/bash
relativePath=$1
outputFile=$2

for f in $relativePath; do
    echo `readlink -f $f` >> $outputFile
done
