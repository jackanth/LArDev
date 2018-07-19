#!/bin/bash

# Function for killing Pandora processes.
function finish
{
    pidString=$1
    kill $pidString > /dev/null 2>&1
    exit
}

pandoraCommand=$1
eventsFile=$2
settingsFile=$3
outputFolder=$4
maxNumFilesPerRun=$5
numCores=$6

# Check that the files exist and the output folder doesn't exist.
if [ "$eventsFile " == " " ]; then
    echo "Events file was not given"
    echo "Usage: pndr-batch [events.txt] [settings.xml] [output_dir]"
    exit
fi

if [ "$settingsFile " == " " ]; then
    echo "Settings file was not given"
    echo "Usage: pndr-batch [events.txt] [settings.xml] [output_dir]"
    exit
fi

if [ "$outputFolder " == " " ]; then
    echo "Output folder was not given"
    echo "Usage: pndr-batch [events.txt] [settings.xml] [output_dir]"
    exit
fi

if [ -d "$outputFolder" ]; then
    echo "Output directory already exists"
    exit
fi

if [ "$numCores " == " " ]; then
    numCores=$PANDORA_NUM_CORES
fi

# Create and print some useful numbers.
numEventFiles=$(wc -l < "$eventsFile")
filesPerJob=$((numEventFiles/numCores))
leftOverFiles=$((numEventFiles - filesPerJob*numCores))

mkdir -p $outputFolder

echo "Running $numEventFiles events files using up to $numCores concurrent jobs and up to $maxNumFilesPerRun files per job"
echo -ne "Outputting to folder $outputFolder\n\n"

# Initialize the output sub-directories and the settings file.
for i in `seq 0 $((numCores-1))`; do
    mkdir -p $outputFolder/$i
    
    # Copy over the settings file, replacing 'OUTPUT_FILE' with a file in the core's output subdirectory.
    outputDir=`readlink -f $outputFolder/$i`
    sed s#OUTPUT_DIR#$outputDir# $settingsFile > $outputFolder/$i/settings.xml
done

echo -ne "Running commands of the form:\n$pandoraCommand -r $PANDORA_DEFAULT_RECO_OPTION -i $outputFolder/[core_number]/settings.xml -g $PANDORA_DEFAULT_GEOMETRY_FILE $PANDORA_DEFAULT_FLAGS -e [events]\n\n"

runNumber=1;
numberOfRuns=$(( (numEventFiles + maxNumFilesPerRun * numCores - 1) / (maxNumFilesPerRun * numCores) ))

# The events lists are the colon-separated string lists passed to pandora for each core.
declare -a eventsLists
declare -a eventNumbers

# Fill the events list array.
lineNumber=1
SECONDS=0
lastTotalSeconds=0

while [[ $lineNumber -le $numEventFiles ]]; do
    # Initialize the events lists array, the output sub-directories and the settings file.
    for i in `seq 0 $((numCores-1))`; do
        eventsLists[$i]=""
        eventNumbers[$i]=0
    done

    coreNumber=0

    counter=0
    firstTime=true
    
    while [[ $lineNumber -le $numEventFiles ]]; do
        line=`sed -n ${lineNumber}p $eventsFile`
        coreNumber=$((coreNumber + 1))
        
        if [[ $coreNumber -ge $numCores ]]; then
            coreNumber=0
            firstTime=false
        fi
        
        counter=$((counter+1))
        
        if [[ $((${eventNumbers[$coreNumber]} + 1)) -gt $maxNumFilesPerRun ]]; then
            break
        fi
        
        lineNumber=$((lineNumber + 1))

        if [[ "$firstTime " == "true " ]]; then
            eventsLists[$coreNumber]="${eventsLists[$coreNumber]}$line"
        else
	        eventsLists[$coreNumber]="${eventsLists[$coreNumber]}:$line"
        fi

        eventNumbers[$coreNumber]=$((${eventNumbers[$coreNumber]} + 1))
    done

    declare -a pidList
    pidString=""

    # Run the Pandora command and keep all the pids.
    for i in `seq 0 $((numCores-1))`; do
        if [ "${eventsLists[$i]} " != " " ]; then # ignore if there were no events passed to that core
	    pandoraPid=""
            echo -ne "Running ${eventNumbers[$i]} event files on core $((i+1))\n"
            
            $pandoraCommand -r $PANDORA_DEFAULT_RECO_OPTION -i $outputFolder/$i/settings.xml -g $PANDORA_DEFAULT_GEOMETRY_FILE $PANDORA_DEFAULT_FLAGS -e ${eventsLists[$i]} > /dev/null 2>&1 & pandoraPid=$!
            
            pidList[$i]="$pandoraPid"
            pidString="$pidString $pandoraPid"
        fi
    done

    # Now if we exit, we want to first kill the Pandora processes.
    trap "finish '$pidString'" EXIT
    
    echo -ne "\n"

    # Check how many processes are remaining. Loop until there are none left.
    while true; do
        numProcessesRemaining=0

        for i in `seq 0 $((numCores-1))`; do
            if [ "${pidList[$i]} " != " " ]; then # ignore if there were no events passed to that core
                if [ "$(ps -p ${pidList[$i]} --no-headers) " != " " ]; then
                    numProcessesRemaining=$((numProcessesRemaining+1))
                fi
            fi
        done    
        
        if [[ $runNumber -gt 1 ]]; then
            minsRemaining=$(((numberOfRuns * (lastTotalSeconds / (runNumber - 1)) - SECONDS) / 60))
        else
            minsRemaining="?"
        fi
        
        echo -ne "\r\033[K[$runNumber / $numberOfRuns] Processes remaining: $numProcessesRemaining. Time elapsed: ${SECONDS}s, estimated time remaining: ${minsRemaining}m"

        if [ "$numProcessesRemaining " == "0 " ]; then
            echo -ne "\n"
            break
        fi

        sleep 1
    done
    
    lastTotalSeconds=$SECONDS
    
    runNumber=$((runNumber + 1))
done

echo "Concatenating .root files to $outputFolder"

for f in $outputFolder/*/*.root; do
    rootFile=$(basename $f)

    if [ ! -f "$outputFolder/$rootFile" ]; then
        hadd $outputFolder/$rootFile $outputFolder/*/$rootFile > /dev/null 2>&1
    fi
done
