#!/bin/bash

echo "running cmsrel..."

cmsrel CMSSW_13_0_0

cd CMSSW_13_0_0/src

cmsenv

echo "retrieving packages from git..."

git cms-addpkg HLTrigger/Configuration

git cms-addpkg L1Trigger/L1TGlobal

git cms-addpkg RecoPixelVertexing/PixelTriplets

mkdir -p L1Trigger/L1TGlobal/data/Luminosity/startup/ && cd L1Trigger/L1TGlobal/data/Luminosity/startup/

echo "retrieving L1 menu..."

wget https://raw.githubusercontent.com/cms-l1-dpg/L1MenuRun3/master/development/L1Menu_CollisionsHeavyIons2022_v1_1_0/L1Menu_CollisionsHeavyIons2022_v1_1_0.xml

cd $CMSSW_BASE/src

echo "retrieving more info from git..."

git cms-addpkg HLTrigger/HLTanalyzers

git cms-addpkg RecoPixelVertexing/PixelVertexFinding

git cms-addpkg Geometry/CommonTopologies

git cms-addpkg RecoPixelVertexing/PixelTriplets

git cms-merge-topic denerslemos:HLTBitAna_CMSSW_13_0_X

echo "compiling code..."

scram b -j 10

cd HLTrigger/Configuration/test && mkdir workstation && cd workstation

echo "done!"




