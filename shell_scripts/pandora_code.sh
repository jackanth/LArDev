#/bin/bash
if [ -z ${PANDORA_PATH+x} ]; then
    echo "Need to set PANDORA_PATH variable (i.e. source setup.sh script)"
    exit 1
fi

set -e
codelite $PHD_PATH/LArDev/codelite/Pandora.workspace> /dev/null 2>&1 &
