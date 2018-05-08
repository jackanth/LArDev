#!/bin/bash

Build()
{
    name=$1
    path=$2
    version=$3
    doBuild=$4
    
    printf "\n\e[1mInstalling $name\e[0m\n"
    cd $path
    git remote update
    git checkout $version
    
    if [ $doBuild = true ]; then
        buildClean=$5
        cmakeFlags=$6
        
        if [ $buildClean == true ]; then
            rm -rf build
        fi
    
        mkdir -p build
        cd build
        
        eval "cmake .. $cmakeFlags"
        make -j$PANDORA_NUM_CORES install
    fi
}

#------------------------------------------------------------------------------------------------------------------------------------------

if [ -z ${PANDORA_PATH+x} ]; 
    then 
        echo "Error: setup pandora first"
        return 1
fi

originalDir=$(pwd)

buildClean=false
buildPandoraPFA=false
buildPandoraSDK=false
buildPandoraMonitoring=false
buildLArPhysicsContent=false
buildLArContent=false
buildLArReco=false
buildMachineLearningData=false

for var in "$@"
do
    if [ "$var " = "clean " ]; then
        buildClean=true
        
    elif [ "$var " = "PandoraPFA " ]; then
        buildPandoraPFA=true
        
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
        
    elif [ "$var " = "MachineLearningData " ]; then
        buildMachineLearningData=true
        
    elif [ "$var " = "all " ]; then
        buildPandoraPFA=true
        buildPandoraSDK=true
        buildPandoraMonitoring=true
        buildLArPhysicsContent=true
        buildLArContent=true
        buildLArReco=true
        buildMachineLearningData=true
        
    else
        echo "Unknown option: $var"
    fi
done



#------------------------------------------------------------------------------------------------------------------------------------------

if [ $buildPandoraPFA = true ]; then
    Build PandoraPFA $PANDORA_PATH/PandoraPFA $PANDORA_PFA_VERSION false
fi

if [ $buildPandoraSDK = true ]; then
    Build PandoraSDK $PANDORA_PATH/PandoraSDK $PANDORA_SDK_VERSION true $buildClean "-DCMAKE_MODULE_PATH=$PANDORA_PATH/PandoraPFA/cmakemodules"
fi

if [ $buildPandoraMonitoring = true ]; then
    Build PandoraMonitoring $PANDORA_PATH/PandoraMonitoring $PANDORA_MONITORING_VERSION true $buildClean "-DCMAKE_MODULE_PATH=\"$PANDORA_PATH/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake\" -DPandoraSDK_DIR=$PANDORA_PATH/PandoraSDK"
fi

if [ $buildLArContent = true ]; then
    Build LArContent $PANDORA_PATH/LArContent $PANDORA_LAR_CONTENT_VERSION true $buildClean "-DCMAKE_MODULE_PATH=\"$PANDORA_PATH/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake\" -DPANDORA_MONITORING=ON -DPandoraSDK_DIR=$PANDORA_PATH/PandoraSDK -DPandoraMonitoring_DIR=$PANDORA_PATH/PandoraMonitoring -DEigen3_DIR=$PANDORA_PATH/Eigen3/share/eigen3/cmake/"
fi

if [ $buildLArPhysicsContent = true ]; then
    Build LArPhysicsContent $PANDORA_LAR_PHYSICS_CONTENT_PATH $PANDORA_LAR_PHYSICS_CONTENT_VERSION true $buildClean "-DCMAKE_MODULE_PATH=\"$PANDORA_PATH/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake\" -DPANDORA_MONITORING=ON -DPandoraSDK_DIR=$PANDORA_PATH/PandoraSDK/ -DPandoraMonitoring_DIR=$PANDORA_PATH/PandoraMonitoring/ -DLArContent_DIR=$PANDORA_PATH/LArContent/"
fi

if [ $buildMachineLearningData = true ]; then
    Build MachineLearningData $PANDORA_PATH/MachineLearningData $PANDORA_ML_DATA_VERSION false
fi

if [ $buildLArReco = true ]; then
    Build LArReco $PANDORA_PATH/LArReco $PANDORA_LAR_RECO_VERSION true $buildClean "-DCMAKE_MODULE_PATH=\"$PANDORA_PATH/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake\" -DPANDORA_MONITORING=ON -DPHYSICS_CONTENT=ON -DLArPhysicsContent_DIR=$PANDORA_LAR_PHYSICS_CONTENT_PATH -DPandoraSDK_DIR=$PANDORA_PATH/PandoraSDK/ -DPandoraMonitoring_DIR=$PANDORA_PATH/PandoraMonitoring/ -DLArContent_DIR=$PANDORA_PATH/LArContent/"
fi

#------------------------------------------------------------------------------------------------------------------------------------------

cd $originalDir
