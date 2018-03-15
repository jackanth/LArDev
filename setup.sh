#!/bin/bash

# Install prerequisites
brew install cmake git wget

# Set up directories
export PHD_DIR=~/PhD
mkdir -p $PHD_DIR/pandora

# Clone my repos
cd $PHD_DIR
git clone git@github.com:jackanth/LArPhysicsContent.git
git clone git@github.com:jackanth/LArDev.git
git clone git@github.com:jackanth/thesis.git

# Clone Pandora repos
cd $PHD_DIR/pandora
git clone https://github.com/PandoraPFA/PandoraPFA.git
git clone https://github.com/PandoraPFA/PandoraSDK.git
git clone https://github.com/PandoraPFA/PandoraMonitoring.git
git clone https://github.com/PandoraPFA/LArContent.git
git clone https://github.com/PandoraPFA/LArReco.git
git clone https://github.com/PandoraPFA/MachineLearningData.git

# Install ROOT
cd $PHD_DIR
wget https://root.cern.ch/download/root_v6.12.06.macosx64-10.13-clang90.tar.gz
tar -xvf root_v6.12.06.macosx64-10.13-clang90.tar.gz
rm root_v6.12.06.macosx64-10.13-clang90.tar.gz

# Install Eigen
wget http://bitbucket.org/eigen/eigen/get/3.3.3.tar.gz
tar -xf 3.3.3.tar.gz
mv eigen-eigen-67e894c6cd8f Eigen3
cd Eigen3
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PHD_DIR/pandora/Eigen3/ ..
make install

# Set up setup script
mkdir $PHD_DIR/bin
ln -s $PHD_DIR/LArDev/shell_scripts/setup.sh $PHD_DIR/setup.sh
source $PHD_DIR/setup.sh

# Build and make symlinks
pandora-build-all
ln -s $PHD_DIR/pandora/LArReco/bin/PandoraInterface $PHD_DIR/bin/pandora-clean
ln -s $PHD_DIR/LArPhysicsContent/bin/PandoraInterface $PHD_DIR/bin/pandora

