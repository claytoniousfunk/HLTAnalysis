#!/bin/bash

TRIGGERMENU="/users/cbennett/HLT_jetTriggerAnalysis_slim/V30"
GLOBALTAG="auto:phase1_2021_realistic_hi"
L1MENU="L1Menu_CollisionsHeavyIons2022_v0_0_0.xml"
L1EMULATOR="uGT"
ERA="Run3_pp_on_PbPb"


echo ""
echo "[triggerEmulation] PbPb trigger menu = $TRIGGERMENU"
echo ""

LIMIT=1



for((i=1; i <= LIMIT; i++)) ; do

    FILEPATH_i="root://cmsxrootd.fnal.gov//store/user/mnguyen/Run3MC/QCD_pThat15_Run3_HydjetEmbedded/QCD_pThat15_Run3_HydjetEmbedded_DIGI/220225_125759/0000/step2_DIGI_L1_DIGI2RAW_HLT_PU_%i.root"

    echo "[triggerEmulation] Setting up configuration for file $i..."

    hltGetConfiguration $TRIGGERMENU --globaltag $GLOBALTAG --l1Xml $L1MENU --l1-emulator $L1EMULATOR --era $ERA --input $FILEPATH_i --process MyHLT --full --mc --unprescale --no-output --max-events -1 > ExportedMenu.py

    echo "[triggerEmulation] editing ExportedMenu.py..."

    echo '
# adapt the HCAL configuration to run over 2018 data
from HLTrigger.Configuration.customizeHLTforCMSSW import customiseFor2018Input
process = customiseFor2018Input(process)
process.hltHcalDigis.saveQIE10DataNSamples = cms.untracked.vint32(10) 
process.hltHcalDigis.saveQIE10DataTags = cms.untracked.vstring("MYDATA")

from HLTrigger.Configuration.common import producers_by_type
for producer in producers_by_type(process, "ClusterCheckerEDProducer"):
    producer.cut = cms.string( "strip < 1000000 && pixel < 150000 && (strip < 500000 + 10*pixel) && (pixel < 5000 + strip/2.)" )

# use rawDataRepacker and skip zero suppression
from PhysicsTools.PatAlgos.tools.helpers import massSearchReplaceAnyInputTag
massSearchReplaceAnyInputTag(process.SimL1Emulator, cms.InputTag("rawDataCollector","","@skipCurrentProcess"), cms.InputTag("rawDataRepacker","","@skipCurrentProcess"))
process.hltHITrackingSiStripRawToClustersFacilityZeroSuppression.DigiProducersList= cms.VInputTag("hltSiStripRawToDigi:ZeroSuppressed")
process.hltHITrackingSiStripRawToClustersFacilityFullZeroSuppression .DigiProducersList = cms.VInputTag("hltSiStripRawToDigi:ZeroSuppressed")
for lbl in ["hltSiStripZeroSuppression", "hltSiStripDigiToZSRaw", "rawDataRepacker"]:
    delattr(process, lbl)

# Define the output
process.output = cms.OutputModule("PoolOutputModule",
    outputCommands = cms.untracked.vstring("drop *", "keep *_TriggerResults_*_*", "keep *_hltTriggerSummaryAOD_*_*", "keep *_hltGtStage2Digis_*_*", "keep *_hltGtStage2ObjectMap_*_*"),
    fileName = cms.untracked.string("output.root"),
)
process.output_path = cms.EndPath(process.output)

process.schedule.append( process.output_path )  # enable this line if you want to get an output containing trigger info to be used for further analysis, e.g. "TriggerResults", digis etc

' >> ExportedMenu.py

    #echo "[triggerEmulation] deleting lines in ExportedMenu.py..."

    #sed -in '10163,10178d' ExportedMenu.py; rm ExportedMenu.pyn;

    #echo "[triggerEmulation] running the menu..."

    #cmsRun ExportedMenu.py &> menulog.txt

    
done
