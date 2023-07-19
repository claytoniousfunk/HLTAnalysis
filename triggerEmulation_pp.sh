#!/bin/bash

TRIGGERMENU="/users/cbennett/HLT_jetTriggerAnalysis_ppRef_slim/V15"
GLOBALTAG="auto:phase1_2023_realistic_hi"
L1MENU="L1Menu_CollisionsHeavyIons2022_v1_1_0.xml"
L1EMULATOR="uGT"
ERA="Run3"

echo "[triggerEmulation] ######## SETTINGS ########"
echo "[triggerEmulation] pp trigger menu = $TRIGGERMENU"
echo "[triggerEmulation] .... global tag   = $GLOBALTAG"
echo "[triggerEmulation] .... L1 menu      = $L1MENU"
echo "[triggerEmulation] .... L1 emulator  = $L1EMULATOR"
echo "[triggerEmulation] .... era          = $ERA"
echo "[triggerEmulation] ##########################"

LIMIT=1

for((i=1; i <= LIMIT; i++)) ; do

    FILEPATH_i="root://cmsxrootd.fnal.gov//store/user/soohwan/DIGIRAW_MC_QCDJets_forPPRef_CMSSW_13_2_0_pre1_10Jun2023_v1/Dijet_TuneCP5_5p36TeV_ppref-pythia8/DIGIRAW_MC_QCDJets_forPPRef_CMSSW_13_2_0_pre1_10Jun2023_v1/230611_154057/0000/JME-RunIIAutumn18DR-00003_step1_$i.root"

    #FILEPATH_i="root://cmsxrootd.fnal.gov//store/user/mnguyen/Run3MC/QCDPhoton_pThat15_Run3_HydjetEmbedded/QCDPhoton_pThat15_Run3_HydjetEmbedded_DIGI/211126_120712/0000/step2_DIGI_L1_DIGI2RAW_HLT_PU_177.root"

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
    
    #echo "[triggerEmulation] deleting lines in ExportedMenu.py..."

    #sed -in '12226,12241d' ExportedMenu.py; rm ExportedMenu.pyn;

    #echo "[triggerEmulation] running the menu..."

    #cmsRun ExportedMenu.py &> menulog.txt

    
done
