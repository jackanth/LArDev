#!/bin/bash
eventsFile=$1
settingsFile=$2
outputFileName=$3

source $LAR_DEV_PATH/shell_scripts/pndr_impl.sh $PHD_PATH/bin/pandora $eventsFile $settingsFile $outputFileName
