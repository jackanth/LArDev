#!/bin/bash
isRemote=false

if [ "$1" == "remote" ]; then
    isRemote=true
fi

# Setup larsoft and uboonecode.
source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup larsoft v06_82_00 -q e15:prof
setup uboonecode v06_82_00 -q e15:prof
setup clang v5_0_1 # for clang-format

# Deal with libgl.
if [ "$isRemote" = true ]; then
    export LIBGL_ALWAYS_INDIRECT=1
else
    unset LIBGL_ALWAYS_INDIRECT
fi

# Set file paths.
export LAR_DIR=~/LAr
export LAR_DEV_DIR=$LAR_DIR/LArDev
export PANDORA_DIR=$LAR_DIR/pandora

export LAR_PHYSICS_CONTENT_DIR=$PANDORA_DIR/LArPhysicsContent
export PANDORA_PFA_DIR=$PANDORA_DIR/PandoraPFA
export PANDORA_SDK_DIR=$PANDORA_DIR/PandoraSDK
export PANDORA_MONITORING_DIR=$PANDORA_DIR/PandoraMonitoring
export LAR_CONTENT_DIR=$PANDORA_DIR/LArContent
export LAR_RECO_DIR=$PANDORA_DIR/LArReco
export LAR_MACHINE_LEARNING_DATA_DIR=$PANDORA_DIR/LArMachineLearningData

# Append paths and library paths.
export PATH=$PATH:$PHD_DIR/bin:$LAR_DEV_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PANDORA_SDK_DIR/lib:$PANDORA_MONITORING_DIR/lib:$LAR_CONTENT_DIR/lib:$LAR_RECO_DIR/lib:$LAR_PHYSICS_CONTENT_DIR/lib

# Default Pandora options.
export PANDORA_DEFAULT_RECO_OPTION=Full
export PANDORA_DEFAULT_GEOMETRY_FILE=$LAR_RECO_DIR/geometry/PandoraGeometry_MicroBooNE.xml
export PANDORA_DEFAULT_FLAGS="-pN"
export PANDORA_MAX_EVENT_FILES_PER_JOB="50"
export FW_SEARCH_PATH=$FW_SEARCH_PATH:$LAR_RECO_DIR/settings:$LAR_MACHINE_LEARNING_DATA_DIR
export PANDORA_NUM_CORES=$(getconf _NPROCESSORS_ONLN)
