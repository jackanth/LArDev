#!/bin/bash

export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
source ~/root_v6_14_04/bin/thisroot.sh

# Set file paths.
export LAR_DIR=/home/jaw/LAr
export LAR_DEV_DIR=$LAR_DIR/LArDev
export PANDORA_DIR=$LAR_DIR/pandora

export LAR_PHYSICS_CONTENT_DIR=$PANDORA_DIR/LArPhysicsContent
export PANDORA_PFA_DIR=$PANDORA_DIR/PandoraPFA
export PANDORA_SDK_DIR=$PANDORA_DIR/PandoraSDK
export PANDORA_MONITORING_DIR=$PANDORA_DIR/PandoraMonitoring
export LAR_CONTENT_DIR=$PANDORA_DIR/LArContent
export LAR_RECO_DIR=$PANDORA_DIR/LArReco
export LAR_MACHINE_LEARNING_DATA_DIR=$PANDORA_DIR/LArMachineLearningData
export LAR_PHYSICS_CONTENT_ROOT_DIR=$LAR_PHYSICS_CONTENT_DIR/root
export BETHE_FASTER_CMAKE_DIR=$LAR_DIR/bethe-faster/lib/cmake/bethe-faster

# Append paths and library paths.
export PATH=$PATH:$LAR_DIR/bin:$LAR_DEV_DIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PANDORA_SDK_DIR/lib:$PANDORA_MONITORING_DIR/lib:$LAR_CONTENT_DIR/lib:$LAR_RECO_DIR/lib:$LAR_PHYSICS_CONTENT_DIR/lib

# Default Pandora versions.
export PANDORA_SDK_VERSION=ThesisVersion
export PANDORA_PFA_VERSION=ThesisVersion
export PANDORA_MONITORING_VERSION=v03-04-01
export PANDORA_LAR_CONTENT_VERSION=ThesisVersion
export PANDORA_LAR_RECO_VERSION=ThesisVersion
export PANDORA_LAR_MACHINE_LEARNING_DATA_VERSION=v03-12-00

# Default Pandora options.
export PANDORA_DEFAULT_RECO_OPTION=Full
export PANDORA_DEFAULT_GEOMETRY_FILE=$LAR_RECO_DIR/geometry/PandoraGeometry_MicroBooNE.xml
export PANDORA_DEFAULT_FLAGS="-pN"
export PANDORA_MAX_EVENT_FILES_PER_JOB="50"
export FW_SEARCH_PATH=$FW_SEARCH_PATH:$LAR_RECO_DIR/settings:$LAR_MACHINE_LEARNING_DATA_DIR
export PANDORA_NUM_CORES=$(getconf _NPROCESSORS_ONLN)
