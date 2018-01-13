#!/bin/bash
rsync -av --size-only --delete anthony@pcle.hep.phy.cam.ac.uk:/r05/uboone/anthony/cut/mcc8_1_prodgenie_bnb_nu_uboone_reco2/ ./mcc8_1_prodgenie_bnb_nu_uboone_reco2
rsync -av --size-only --delete anthony@pcle.hep.phy.cam.ac.uk:/r05/uboone/anthony/cut/mcc8_1_prodgenie_bnb_intrinsic_nue_cosmic_uboone_reco2/ ./mcc8_1_prodgenie_bnb_intrinsic_nue_cosmic_uboone_reco2
