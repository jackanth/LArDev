#!/bin/bash
if [ -z ${PANDORA_PATH+x} ]; 
    then 
        echo "Error: setup pandora first"
        exit 1
fi

buildClean=false
if [ "$1 " == "clean " ]; then
    buildClean=true;
fi

originalDir=$(pwd)

printf "\n\e[1mInstalling LArPhysicsContent\e[0m\n"
cd $PANDORA_LAR_PHYSICS_CONTENT_PATH
git checkout $PANDORA_LAR_PHYSICS_CONTENT_VERSION

if [ $buildClean == true ]; then
    rm -rf build
fi

mkdir -p build
cd build
cmake -DCMAKE_MODULE_PATH="$PANDORA_PATH/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake" -DPANDORA_MONITORING=ON -DPandoraSDK_DIR=$PANDORA_PATH/PandoraSDK/ -DPandoraMonitoring_DIR=$PANDORA_PATH/PandoraMonitoring/ -DLArContent_DIR=$PANDORA_PATH/LArContent/ ..
make -j$PANDORA_NUM_CORES install

cd $originalDir
