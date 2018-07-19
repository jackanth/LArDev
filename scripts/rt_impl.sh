#!/bin/bash
commandBase=$1
numArguments=$(($#-2))
command="$commandBase '$2"

if [ "$numArguments" == "0" ]; then
    command="$command'"
else
    command="$command("
    counter=1
    for var in "${@:3}"; do
        command="$command$var"
        
        if [ $counter -lt $numArguments ]; then
            command="$command, "
        fi
        
        counter=$((counter+1))
    done
    command="$command)'"
fi

echo "Running command: $command"
eval $command
