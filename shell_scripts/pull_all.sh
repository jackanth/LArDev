#!/bin/bash

if [ -z ${PANDORA_PATH+x} ]; 
    then 
        echo "Error: setup pandora first"
        exit 1
fi

originalDir=$(pwd)

#---------------------------------------------------------------------------------------------

printf "\n\e[1mPulling thesis\e[0m\n"
cd $THESIS_PATH
git remote update

if [ `git rev-parse --verify --quiet $THESIS_VERSION ` ]
then
   git checkout $THESIS_VERSION
   git pull origin $THESIS_VERSION
else
    git checkout origin/$THESIS_VERSION -b $THESIS_VERSION
fi

#---------------------------------------------------------------------------------------------

printf "\n\e[1mPulling LArDev\e[0m\n"
cd $LAR_DEV_PATH
git remote update

if [ `git rev-parse --verify --quiet $PANDORA_LAR_DEV_VERSION ` ]
then
   git checkout $PANDORA_LAR_DEV_VERSION
   git pull origin $PANDORA_LAR_DEV_VERSION
else
    git checkout origin/$PANDORA_LAR_DEV_VERSION -b $PANDORA_LAR_DEV_VERSION
fi

#---------------------------------------------------------------------------------------------

printf "\n\e[1mPulling LArPhysicsContent\e[0m\n"
cd $PANDORA_LAR_PHYSICS_CONTENT_PATH
git remote update

if [ `git rev-parse --verify --quiet $PANDORA_LAR_PHYSICS_CONTENT_VERSION ` ]
then
   git checkout $PANDORA_LAR_PHYSICS_CONTENT_VERSION
   git pull origin $PANDORA_LAR_PHYSICS_CONTENT_VERSION
else
    git checkout origin/$PANDORA_LAR_PHYSICS_CONTENT_VERSION -b $PANDORA_LAR_PHYSICS_CONTENT_VERSION
fi

cd $originalDir
