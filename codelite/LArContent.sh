
echo Executing Pre Build commands ...
cd $PANDORA_PATH/LArContent
if [ ! -d "build" ]; then
mkdir build
fi

cd build
cmake -DCMAKE_MODULE_PATH="$PANDORA_PATH/PandoraPFA/cmakemodules;$ROOTSYS/etc/cmake" -DPANDORA_MONITORING=ON -DPandoraSDK_DIR=$PANDORA_PATH/PandoraSDK -DPandoraMonitoring_DIR=$PANDORA_PATH/PandoraMonitoring ..
echo Done
pandora-build LArContent
