#!/bin/bash
if [ "$1 " == "mount " ]; then
    mkdir -p $PANDORA_SSHFS_USER_PATH
    mkdir -p $PANDORA_SSHFS_USERA_PATH
    mkdir -p $PANDORA_SSHFS_R05_PATH

    sshfs anthony@pcmg.hep.phy.cam.ac.uk:/usera/anthony $PANDORA_SSHFS_USER_PATH
    sshfs anthony@pcmg.hep.phy.cam.ac.uk:/var/clus/usera $PANDORA_SSHFS_USERA_PATH
    sshfs anthony@pcmg.hep.phy.cam.ac.uk:/var/pcfst/r05 $PANDORA_SSHFS_R05_PATH

elif [ "$1 " == "umount " ]; then
    sudo umount $PANDORA_SSHFS_USER_PATH
    sudo umount $PANDORA_SSHFS_USERA_PATH
    sudo umount $PANDORA_SSHFS_R05_PATH

else
    echo "Unknown command: $1 (use 'sshfs-cav mount' or 'sshfs-cav umount')"
fi
