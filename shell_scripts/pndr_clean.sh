#!/bin/bash
eventsFile=$1
settingsFile=$2
outputFileName=$3

$LAR_DEV_PATH/shell_scripts/pndr_impl.sh $PHD_PATH/bin/pandora-clean $eventsFile $settingsFile $outputFileName
