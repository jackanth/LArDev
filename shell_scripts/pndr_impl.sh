#!/bin/bash
pandoraCommand=$1
eventsFile=$2
settingsFile=$3
outputFolder=$4

eventsList=""
counter=1

source $ROOT_PATH/bin/thisroot.sh

if [ "$eventsFile " == " " ]; then
    echo "Events file was empty"
    echo "Usage: pndr[-clean] [events.txt] [settings.txt] [output_dir]"
    exit
fi

if [ "$outputFolder " == " " ]; then
    echo "Output folder was not given"
    echo "Usage: pndr[-clean] [events.txt] [settings.txt] [output_dir]"
    exit
fi

if [ -d "$outputFolder" ]; then
    echo "Output directory already exists"
    exit
fi

numEventFiles=$(wc -l < "$eventsFile")

while IFS='' read -r line || [[ -n "$line" ]]; do
    if [ $counter ==  $numEventFiles ]; then
        eventsList="$eventsList$line"
     else
        eventsList="$eventsList$line:"
    fi

    counter=$((counter+1))
done < "$eventsFile"

if [ "$eventsList " == " " ]; then
    echo "Events list was empty"
    echo "Usage: pndr[-clean] [events.txt] [settings.txt] [output_dir]"
    exit
fi
    
if [ "$settingsFile " == " " ]; then
    echo "Settings file was blank"
    
    echo "Usage: pndr[-clean] [events.txt] [settings.txt] [output_dir]"
    exit
fi
    
mkdir -p $outputFolder
outputFolderFull=`realpath $outputFolder`
tmpSettingsFile=".settings.tmp.xml"
sed s#OUTPUT_DIR#$outputFolderFull# $settingsFile > $tmpSettingsFile
settingsFile=$tmpSettingsFile

fullCommand="$pandoraCommand -r $PANDORA_DEFAULT_RECO_OPTION -i $settingsFile -g $PANDORA_DEFAULT_GEOMETRY_FILE $PANDORA_DEFAULT_FLAGS -e $eventsList"
echo -ne "Running command:\n$fullCommand\n"
eval $fullCommand

if [ "$tmpSettingsFile " != " " ]; then
    rm $tmpSettingsFile
fi
