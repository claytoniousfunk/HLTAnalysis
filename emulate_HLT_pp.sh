#!/bin/bash

TRIGGERMENU="/users/cbennett/HLT_ppRef_2024/V9"
GLOBALTAG="140X_mcRun3_2024_realistic_v9"
L1MENU="L1Menu_CollisionsPPRef2024_v0_0_0.xml"
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

rm -rf macroLogs
rm -rf myGets
rm -rf openHLTfiles
rm -rf logs

mkdir macroLogs
mkdir myGets
mkdir openHLTfiles
mkdir logs

for((i=1; i <= LIMIT; i++)) ; do

    FILEPATH_i="/store/group/phys_heavyions/cbennett/crabSubmit_RAW_PYTHIA8_DiJet_5360GeV_2024-09-12/PYTHIA8_DiJet_5360GeV/PYTHIA8_DiJet_5360GeV_MC_generation_2024-09-12/240912_184339/0000/PYTHIA8_DiJet_5360GeV_RAW_$i.root"

    echo "[triggerEmulation] Setting up configuration for file $i..."

    echo "hltGetConfiguration $TRIGGERMENU --globaltag $GLOBALTAG --l1Xml $L1MENU --l1-emulator $L1EMULATOR --era $ERA --input $FILEPATH_i --process MyHLT --full --mc --unprescale --no-output --max-events -1" &> myGets/myGet_$i.txt

    ./setup_hltConfig.sh . myGets/myGet_$i.txt

    cmsRun test_pset.py 2>&1 | tee logs/log_$i.txt
    
    echo '
import FWCore.ParameterSet.Config as cms
process = cms.Process("HLTANA")

# Input source
process.maxEvents = cms.untracked.PSet(input = cms.untracked.int32(-1))
process.source = cms.Source("PoolSource", fileNames = cms.untracked.vstring("file:output.root"))

process.load("Configuration.StandardSequences.FrontierConditions_GlobalTag_cff")
from Configuration.AlCa.GlobalTag import GlobalTag
process.GlobalTag = GlobalTag(process.GlobalTag, "auto:phase1_2023_realistic_hi", "")

# add HLTBitAnalyzer
process.load("HeavyIonsAnalysis.EventAnalysis.hltanalysis_cfi")
process.hltanalysis.hltResults = cms.InputTag("TriggerResults::MyHLT")
process.hltanalysis.l1tAlgBlkInputTag = cms.InputTag("hltGtStage2Digis::MyHLT")
process.hltanalysis.l1tExtBlkInputTag = cms.InputTag("hltGtStage2Digis::MyHLT")

process.load("HeavyIonsAnalysis.EventAnalysis.hltobject_cfi")
process.hltobject.triggerResults = cms.InputTag("TriggerResults::MyHLT")
process.hltobject.triggerEvent = cms.InputTag("hltTriggerSummaryAOD::MyHLT")

process.hltAnalysis = cms.EndPath(process.hltanalysis + process.hltobject)
process.TFileService = cms.Service("TFileService", fileName=cms.string("openHLT.root"))
' &> Macro.py

    cmsRun Macro.py 2>&1 | tee macroLogs/macrolog_$i.txt

    cp openHLT.root openHLTfiles/openHLT_$i.root

    rm ./*.root ./*.py 

done


