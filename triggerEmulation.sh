#!/bin/bash

TRIGGERMENU="/users/cbennett/HLT_jetTriggerAnalysis_slim/V32"
GLOBALTAG="auto:phase1_2021_realistic_hi"
L1MENU="L1Menu_CollisionsHeavyIons2022_v0_0_0.xml"
L1EMULATOR="uGT"
ERA="Run3_pp_on_PbPb"

echo "[triggerEmulation] ######## SETTINGS ########"
echo "[triggerEmulation] PbPb trigger menu = $TRIGGERMENU"
echo "[triggerEmulation] .... global tag   = $GLOBALTAG"
echo "[triggerEmulation] .... L1 menu      = $L1MENU"
echo "[triggerEmulation] .... L1 emulator  = $L1EMULATOR"
echo "[triggerEmulation] .... era          = $ERA"
echo "[triggerEmulation] ##########################"

LIMIT=1

for((i=1; i <= LIMIT; i++)) ; do

    FILEPATH_i="root://cmsxrootd.fnal.gov//store/user/mnguyen/Run3MC/QCD_pThat15_Run3_HydjetEmbedded/QCD_pThat15_Run3_HydjetEmbedded_DIGI/220225_125759/0000/step2_DIGI_L1_DIGI2RAW_HLT_PU_$i.root"

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
    
    echo "[triggerEmulation] deleting lines in ExportedMenu.py..."

    sed -in '12226,12241d' ExportedMenu.py; rm ExportedMenu.pyn;

    echo "[triggerEmulation] running the menu..."

    cmsRun ExportedMenu.py &> menulog.txt

    
done
