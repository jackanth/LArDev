#!/bin/bash

if [ -z ${PANDORA_PATH+x} ]; 
    then 
        echo "Error: setup pandora first"
        exit 1
fi

PrintStatus()
{
    name=$1
    path=$2
    cd $path

    printf "\n\e[1m$name\e[0m\n"
    git status
}

originalDir=$(pwd)

PrintStatus PandoraPFA          $PANDORA_PFA_DIR
PrintStatus PandoraSDK          $PANDORA_SDK_DIR
PrintStatus PandoraMonitoring   $PANDORA_MONITORING_DIR
PrintStatus MachineLearningData $LAR_MACHINE_LEARNING_DIR
PrintStatus LArContent          $LAR_CONTENT_DIR
PrintStatus LArReco             $LAR_RECO_DIR
PrintStatus LArDev              $LAR_DEV_DIR
PrintStatus LArPhysicsContent   $LAR_PHYSICS_CONTENT_DIR

cd $originalDir
