#!/bin/bash
sudo update-alternatives --set g++ /usr/bin/g++-4.9
sudo update-alternatives --set gcc /usr/bin/gcc-4.9

if ! ps -p $SSH_AGENT_PID > /dev/null ; then
   eval "$(ssh-agent -s)"
fi

ssh-add ~/.ssh/id_rsa_jaw86

# git tags.
export PANDORA_LAR_PHYSICS_CONTENT_VERSION=master
export PANDORA_LAR_DEV_VERSION=master
export THESIS_VERSION=master

export PANDORA_PFA_VERSION=v03-06-00
export PANDORA_SDK_VERSION=v03-01-00
export PANDORA_MONITORING_VERSION=v03-03-00
export PANDORA_LAR_CONTENT_VERSION=v03_08_01
export PANDORA_LAR_RECO_VERSION=v03-08-01
export PANDORA_ML_DATA_VERSION=v03-04-00

# Set file paths.
export PHD_PATH=~/PhD
export ROOT_PATH=$PHD_PATH/root

export THESIS_PATH=$PHD_PATH/thesis
export LAR_DEV_PATH=$PHD_PATH/LArDev
export PANDORA_PATH=$PHD_PATH/pandora
export PANDORA_LAR_PHYSICS_CONTENT_PATH=$PHD_PATH/LArPhysicsContent

export PANDORA_ROOT_DATA_PATH=~/Dropbox/PhD/data.root
export PANDORA_ROOT_BIRKS_PATH=$PANDORA_LAR_PHYSICS_CONTENT_PATH/root/BirksDataFit.c
export PANDORA_ROOT_RANGE=$PANDORA_LAR_PHYSICS_CONTENT_PATH/root/ProcessEnergyFromRangeData.c
export PANDORA_ROOT_PID=$PANDORA_LAR_PHYSICS_CONTENT_PATH/root/ProcessPidData.c
export PANDORA_ROOT_READ=$PANDORA_LAR_PHYSICS_CONTENT_PATH/root/ReadPandoraNtuple.c

# Append paths and library paths.
export PATH=$PATH:$ROOTSYS/bin:$PHD_PATH/bin:$LAR_DEV_PATH/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PANDORA_PATH/PandoraSDK/lib:$PANDORA_PATH/PandoraMonitoring/lib:$PANDORA_PATH/LArContent/lib:$PANDORA_PATH/LArReco/lib:$ROOTSYS/lib

# Default Pandora options.
export PANDORA_DEFAULT_RECO_OPTION=AllHitsNu
export PANDORA_DEFAULT_GEOMETRY_FILE=$PANDORA_PATH/LArReco/geometry/uboone.xml
export PANDORA_DEFAULT_FLAGS="-pN"
export PANDORA_MAX_EVENT_FILES_PER_JOB="50"

# Misc.
export PANDORA_NUM_CORES=$(getconf _NPROCESSORS_ONLN)
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa_jaw86"
export PANDORA_CAV_PATH=$PHD_PATH/cav
export PANDORA_SSHFS_USER_PATH=$PANDORA_CAV_PATH/anthony
export PANDORA_SSHFS_USERA_PATH=$PANDORA_CAV_PATH/usera
export PANDORA_SSHFS_R05_PATH=$PANDORA_CAV_PATH/r05
source $ROOT_PATH/bin/thisroot.sh
