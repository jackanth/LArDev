#!/bin/bash

if [ -z ${PANDORA_PATH+x} ]; 
    then 
        echo "Error: setup pandora first"
        exit 1
fi

originalDir=$(pwd)

buildClean=false
if [ "$1 " == "clean " ]; then
    buildClean=true;
fi

#---------------------------------------------------------------------------------------------

printf "\n\e[1mInstalling PandoraPFA\e[0m\n"
cd $PANDORA_PATH/PandoraPFA
git checkout $PANDORA_PFA_VERSION

#---------------------------------------------------------------------------------------------

printf "\n\e[1mInstalling PandoraSDK\e[0m\n"
cd $PANDORA_PATH/PandoraSDK
git checkout $PANDORA_SDK_VERSION

if [ $buildClean == true ]; then
    rm -rf build
fi

mkdir -p build
cd build
cmake -DCMAKE_MODULE_PATH=$PANDORA_PATH/PandoraPFA/cmakemodules ..
make -j$PANDORA_NUM_CORES install

#---------------------------------------------------------------------------------------------

printf "\n\e[1mInstalling PandoraMonitoring\e[0m\n"
cd $PANDORA_PATH/PandoraMonitoring
git checkout $PANDORA_MONITORING_VERSION

if [ $buildClean == true ]; then
    rm -rf build
fi

mkdir -p build
cd build
cmake -DCMAKE_MODULE_PATH="$PANDORA_PATH/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake" -DPandoraSDK_DIR=$PANDORA_PATH/PandoraSDK ..
make -j$PANDORA_NUM_CORES install

#---------------------------------------------------------------------------------------------

printf "\n\e[1mInstalling LArContent\e[0m\n"
cd $PANDORA_PATH/LArContent
git checkout $PANDORA_LAR_CONTENT_VERSION

if [ $buildClean == true ]; then
    rm -rf build
fi

mkdir -p build
cd build
cmake -DCMAKE_MODULE_PATH="$PANDORA_PATH/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake" -DPANDORA_MONITORING=ON -DPandoraSDK_DIR=$PANDORA_PATH/PandoraSDK -DPandoraMonitoring_DIR=$PANDORA_PATH/PandoraMonitoring -DEigen3_DIR=$PANDORA_PATH/Eigen3/share/eigen3/cmake/ ..
make -j$PANDORA_NUM_CORES install

#---------------------------------------------------------------------------------------------

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

#---------------------------------------------------------------------------------------------

printf "\n\e[1mInstalling MachineLearningData\e[0m\n"
cd $PANDORA_PATH/MachineLearningData
git checkout $PANDORA_ML_DATA_VERSION

#---------------------------------------------------------------------------------------------

printf "\n\e[1mInstalling LArReco\e[0m\n"
cd $PANDORA_PATH/LArReco
git checkout $PANDORA_LAR_RECO_VERSION

if [ $buildClean == true ]; then
    rm -rf build
fi

mkdir -p build
cd build
cmake -DCMAKE_MODULE_PATH="$PANDORA_PATH/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake" -DPANDORA_MONITORING=ON -DPHYSICS_CONTENT=ON -DLArPhysicsContent_DIR=$PANDORA_LAR_PHYSICS_CONTENT_PATH -DPandoraSDK_DIR=$PANDORA_PATH/PandoraSDK/ -DPandoraMonitoring_DIR=$PANDORA_PATH/PandoraMonitoring/ -DLArContent_DIR=$PANDORA_PATH/LArContent/ ..
make -j$PANDORA_NUM_CORES install

cd $originalDir
