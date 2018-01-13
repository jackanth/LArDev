#!/bin/bash

if [ -z ${PANDORA_PATH+x} ]; 
    then 
        echo "Error: setup pandora first"
        exit 1
fi

originalDir=$(pwd)

#---------------------------------------------------------------------------------------------

printf "\n\e[1mCloning repositories\e[0m\n"
cd $PHD_PATH
git clone git@github.com:jaw86/LArPhysicsContent.git
git clone git@github.com:jaw86/thesis.git

#---------------------------------------------------------------------------------------------

printf "\n\e[1mCloning Pandora repositories\e[0m\n"
mkdir $PANDORA_PATH
cd $PANDORA_PATH
git clone https://github.com/PandoraPFA/PandoraPFA.git
git clone https://github.com/PandoraPFA/PandoraSDK.git
git clone https://github.com/PandoraPFA/PandoraMonitoring.git
git clone https://github.com/PandoraPFA/LArContent.git
git clone https://github.com/PandoraPFA/LArReco.git
git clone https://github.com/PandoraPFA/MachineLearningData.git

#---------------------------------------------------------------------------------------------

printf "\n\e[1mInstalling Eigen\e[0m\n"
cd $PANDORA_PATH
wget http://bitbucket.org/eigen/eigen/get/3.3.3.tar.gz
tar -xf 3.3.3.tar.gz
rm 3.3.3.tar.gz
mv eigen-eigen-67e894c6cd8f Eigen3
cd Eigen3
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PANDORA_PATH/Eigen3/ ..
make -j$PANDORA_NUM_CORES install

#---------------------------------------------------------------------------------------------

printf "\n\e[1mSetting symlinks\e[0m\n"
cd $PHD_PATH
mkdir bin
cd bin
ln -s ../pandora/LArReco/bin/PandoraInterface ./pandora-clean
ln -s ../LArPhysicsContent/bin/PandoraInterface ./pandora

source $LAR_DEV_PATH/shell_scripts/pull_all.sh

cd $originalDir
