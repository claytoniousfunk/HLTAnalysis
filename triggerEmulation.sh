#!/bin/bash

TRIGGERMENU="/users/cbennett/HLT_jetTriggerAnalysis_ppRef/V15"
GLOBALTAG="auto:phase1_2021_realistic_hi"
L1MENU="L1Menu_CollisionsHeavyIons2022_v0_0_0.xml"
L1EMULATOR="uGT"
ERA="Run3_pp_on_PbPb"


echo ""
echo "[triggerEmulation] ppRef trigger menu = $TRIGGERMENU"
echo ""

LIMIT=1



for((i=1; i <= LIMIT; i++)) ; do

    FILEPATH_i="root://cmsxrootd.fnal.gov//store/user/ddesouza/Dijet_TuneCP5_5p36TeV_ppref-pythia8/Dijet_TuneCP5_5p36TeV_ppref-pythia8/20230408PrivateDijet/230411_173439/0002/ppref_HINAutumn18GS-00032_py_GEN_SIM_$i.root"

    echo "[triggerEmulation] Setting up configuration for file $i..."

    hltGetConfiguration $TRIGGERMENU --globaltag $GLOBALTAG --l1Xml $L1MENU --l1-emulator $L1EMULATOR --era $ERA --input $FILEPATH_i --process MyHLT --full --mc --unprescale --no-output --max-events -1 > ExportedMenu.py

    echo "[triggerEmulation] editing ExportedMenu.py..."

    echo '
      # Define the output
      process.output = cms.OutputModule("PoolOutputModule",
        outputCommands = cms.untracked.vstring("drop *", "keep *_TriggerResults_*_*", "keep *_hltTriggerSummaryAOD_*_*", "keep *_hltGtStage2Digis_*_*", "keep *_hltGtStage2ObjectMap_*_*"),
        fileName = cms.untracked.string("output.root"),
      )
      process.output_path = cms.EndPath(process.output)

      process.schedule.append( process.output_path )  # enable this line if you want to get an output containing trigger info to be used for further analysis, e.g. "TriggerResults", digis etc

    ' >> ExportedMenu.py




    
done
