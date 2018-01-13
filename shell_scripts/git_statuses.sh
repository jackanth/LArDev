#!/bin/bash

if [ -z ${PANDORA_PATH+x} ]; 
    then 
        echo "Error: setup pandora first"
        exit 1
fi

originalDir=$(pwd)

printf "\n\e[1mthesis\e[0m\n"
cd $THESIS_PATH
git status

printf "\n\e[1mLArDev\e[0m\n"
cd $LAR_DEV_PATH
git status

printf "\n\e[1mLArPhysicsContent\e[0m\n"
cd $PANDORA_LAR_PHYSICS_CONTENT_PATH
git status

cd $originalDir
