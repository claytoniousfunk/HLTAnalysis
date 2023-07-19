#!/bin/bash

echo "[setupCMSSW130X] running cmsrel..."

cmsrel CMSSW_13_2_0_pre1

cd CMSSW_13_2_0_pre1/src

cmsenv

echo "[setupCMSSW130X] retrieving packages from git..."

git cms-addpkg HLTrigger/Configuration

git cms-addpkg L1Trigger/L1TGlobal

git cms-addpkg RecoPixelVertexing/PixelTriplets

mkdir -p L1Trigger/L1TGlobal/data/Luminosity/startup/ && cd L1Trigger/L1TGlobal/data/Luminosity/startup/

echo "[setupCMSSW130X] retrieving L1 menu..."

wget https://raw.githubusercontent.com/cms-l1-dpg/L1MenuRun3/master/development/L1Menu_CollisionsHeavyIons2022_v1_1_0/L1Menu_CollisionsHeavyIons2022_v1_1_0.xml

cd $CMSSW_BASE/src

echo "[setupCMSSW130X] retrieving more info from git..."

git cms-addpkg HLTrigger/HLTanalyzers

git cms-addpkg RecoPixelVertexing/PixelVertexFinding

git cms-addpkg Geometry/CommonTopologies

git cms-addpkg RecoPixelVertexing/PixelTriplets

git cms-merge-topic denerslemos:HLTBitAna_CMSSW_13_0_X

echo "[setupCMSSW130X] compiling code..."

scram b -j 10

echo "[setupCMSSW130X] running cmsenv in src..."

cmsenv

echo "[setupCMSSW130X] Creating workstation folder..."

cd HLTrigger/Configuration/test && mkdir workstation && cd workstation

echo "[setupCMSSW130X] copying over triggerEmulation.sh..."

cp ../../../../../../triggerEmulation.sh .

echo "[setupCMSSW130X] done!"




