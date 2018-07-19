#!/bin/bash
pandoraCommand=$1
eventsFile=$2
outputFolder=$3
settingsFile=$4
shift 4

eventsList=""
counter=1

source $ROOT_PATH/bin/thisroot.sh

if [ "$eventsFile " == " " ]; then
    echo "Events file was empty"
    echo "Usage: pndr[-clean] [events.txt] [output_dir] [main settings file] [other settings files...]"
    exit
fi

if [ "$outputFolder " == " " ]; then
    echo "Output folder was not given"
    echo "Usage: pndr[-clean] [events.txt] [output_dir] [main settings file] [other settings files...]"
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
        eventsList="$eventsList$line "
    fi

    counter=$((counter+1))
done < "$eventsFile"

if [ "$eventsList " == " " ]; then
    echo "Events list was empty"
    echo "Usage: pndr[-clean] [events.txt] [output_dir] [main settings file] [other settings files...]"
    exit
fi
    
if [ "$settingsFile " == " " ]; then
    echo "Settings file was blank"
    
    echo "Usage: pndr[-clean] [events.txt] [output_dir] [main settings file] [other settings files...]"
    exit
fi
    
mkdir -p $outputFolder
outputFolderFull=`readlink -f $outputFolder`
tmpSettingsFile=".settings.tmp.xml"
sed s#OUTPUT_DIR#$outputFolderFull# $settingsFile > $tmpSettingsFile
sed -i s#GEOMETRY_FILE#$PANDORA_DEFAULT_GEOMETRY_FILE# $tmpSettingsFile
sed -i "s#EVENT_FILES#$eventsList#" $tmpSettingsFile
settingsFile=$tmpSettingsFile

echo "Wrote to $tmpSettingsFile"

for otherSettingsFile in "$@"; do
    tmpName="$otherSettingsFile.tmp.xml"
    echo "Created tmp file $tmpName"
    
    sed s#OUTPUT_DIR#$outputFolderFull# $otherSettingsFile > $tmpName
    sed -i s#GEOMETRY_FILE#$PANDORA_DEFAULT_GEOMETRY_FILE# $tmpName
    sed -i "s#EVENT_FILES#$eventsList#" $tmpName
done

fullCommand="$pandoraCommand -r $PANDORA_DEFAULT_RECO_OPTION -i $settingsFile $PANDORA_DEFAULT_FLAGS"
echo -ne "Running command:\n$fullCommand\n"
eval $fullCommand
