#!/bin/bash

TRIGGERMENU="/users/cbennett/HLT_jetTriggerAnalysis_ppRef/V15"
GLOBALTAG="auto:phase1_2021_realistic_hi"
L1MENU="L1Menu_CollisionsHeavyIons2022_v0_0_0.xml"
L1EMULATOR="uGT"
ERA="Run3_pp_on_PbPb"


echo ""
echo "ppRef trigger menu = $TRIGGERMENU"
echo ""

LIMIT=25

echo"Listing input filenames (test)"
for((i=1; i <= LIMIT; i++)) ; do

    FILEPATH_i="root://cmsxrootd.fnal.gov//store/user/ddesouza/Dijet_TuneCP5_5p36TeV_ppref-pythia8/Dijet_TuneCP5_5p36TeV_ppref-pythia8/20230408PrivateDijet/230411_173439/0002/ppref_HINAutumn18GS-00032_py_GEN_SIM_$i.root"

    echo "Setting up configuration for file $i..."

    hltGetConfiguration $TRIGGERMENU --globaltag $GLOBALTAG --l1Xml $L1MENU --l1-emulator $L1EMULATOR --era $ERA --input $FILEPATH_i --process MyHLT --full --mc --unprescale --no-output --max-events -1 > ExportedMenu.py

    #echo "Editing ExportMenu.py..."




    
done
