#!/bin/bash

Build()
{
    name=$1
    path=$2
    
    printf "\n\e[1mInstalling $name\e[0m\n"
    cd $path
    
    buildClean=$3
    cmakeFlags=$4
    
    if [ $buildClean == true ]; then
        rm -rf build
    fi

    mkdir -p build
    cd build
    
    command="cmake .. $cmakeFlags"
    echo "[cmd] $command"
    eval $command

    command="make -j$PANDORA_NUM_CORES install"
    echo "[cmd] $command"
    eval $command
}

#------------------------------------------------------------------------------------------------------------------------------------------

if [ -z ${PANDORA_DIR+x} ]; 
    then 
        echo "Error: setup pandora first"
        return 1
fi

set -e
originalDir=$(pwd)

buildClean=false
buildPandoraSDK=false
buildPandoraMonitoring=false
buildLArPhysicsContent=false
buildLArContent=false
buildLArReco=false

for var in "$@"
do
    if [ "$var " = "clean " ]; then
        buildClean=true

    elif [ "$var " = "PandoraSDK " ]; then
        buildPandoraSDK=true
        
    elif [ "$var " = "PandoraMonitoring " ]; then
        buildPandoraMonitoring=true  
        
    elif [ "$var " = "LArPhysicsContent " ]; then
        buildLArPhysicsContent=true 
        
    elif [ "$var " = "LArContent " ]; then
        buildLArContent=true 
        
    elif [ "$var " = "LArReco " ]; then
        buildLArReco=true 
        
    elif [ "$var " = "all " ]; then
        buildPandoraSDK=true
        buildPandoraMonitoring=true
        buildLArPhysicsContent=true
        buildLArContent=true
        buildLArReco=true
        
    else
        echo "Unknown option: $var"
    fi
done

#------------------------------------------------------------------------------------------------------------------------------------------

pndrCmakeModulesDir="$PANDORA_PFA_DIR/cmakemodules"
rootCmakeModulesDir="$ROOTSYS/etc/cmake"

if [ $buildPandoraSDK = true ]; then
    Build PandoraSDK $PANDORA_SDK_DIR $buildClean "-DCMAKE_CXX_FLAGS=-std=c++14 -DCMAKE_MODULE_PATH=$pndrCmakeModulesDir"
fi

if [ $buildPandoraMonitoring = true ]; then
    Build PandoraMonitoring $PANDORA_MONITORING_DIR $buildClean "-DCMAKE_CXX_FLAGS=-std=c++14 -DCMAKE_MODULE_PATH=\"$pndrCmakeModulesDir;$rootCmakeModulesDir\" -DPandoraSDK_DIR=$PANDORA_SDK_DIR"
fi

if [ $buildLArContent = true ]; then
    Build LArContent $LAR_CONTENT_DIR $buildClean "-DCMAKE_CXX_FLAGS=-std=c++14 -DCMAKE_MODULE_PATH=\"$pndrCmakeModulesDir;$rootCmakeModulesDir\" -DPANDORA_MONITORING=ON -DPandoraSDK_DIR=$PANDORA_SDK_DIR -DPandoraMonitoring_DIR=$PANDORA_MONITORING_DIR -DEigen3_DIR=$PANDORA_DIR/Eigen3/share/eigen3/cmake/"
fi

if [ $buildLArPhysicsContent = true ]; then
    Build LArPhysicsContent $LAR_PHYSICS_CONTENT_DIR $buildClean "-DCMAKE_CXX_FLAGS=-std=c++14 -DCMAKE_MODULE_PATH=\"$pndrCmakeModulesDir;$rootCmakeModulesDir\" -DPANDORA_MONITORING=ON -DPandoraSDK_DIR=$PANDORA_SDK_DIR -DPandoraMonitoring_DIR=$PANDORA_MONITORING_DIR -DLArContent_DIR=$LAR_CONTENT_DIR"
fi


if [ $buildLArReco = true ]; then
    Build LArReco $LAR_RECO_DIR $buildClean "-DCMAKE_CXX_FLAGS=-std=c++14 -DCMAKE_MODULE_PATH=\"$pndrCmakeModulesDir;$rootCmakeModulesDir\" -DPANDORA_MONITORING=ON -DPHYSICS_CONTENT=ON -DLArPhysicsContent_DIR=$PHYSICS_CONTENT_DIR -DPandoraSDK_DIR=$PANDORA_SDK_DIR -DPandoraMonitoring_DIR=$PANDORA_MONITORING_DIR -DLArContent_DIR=$LAR_CONTENT_DIR"
fi

#------------------------------------------------------------------------------------------------------------------------------------------

cd $originalDir
