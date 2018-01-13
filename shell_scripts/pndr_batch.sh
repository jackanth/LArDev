#!/bin/bash
eventsFile=$1
settingsFile=$2
outputFolder=$3
numCores=$4

$LAR_DEV_PATH/shell_scripts/pndr_batch_impl.sh $PHD_PATH/bin/pandora $eventsFile $settingsFile $outputFolder $PANDORA_MAX_EVENT_FILES_PER_JOB $numCores 
