#!/bin/bash

echo "[setupCMSSW123X] running cmsrel..."

cmsrel CMSSW_12_3_0

cd CMSSW_12_3_0/src

cmsenv

echo "[setupCMSSW123X] retrieving packages from git..."

git cms-addpkg HLTrigger/Configuration

git cms-addpkg L1Trigger/L1TGlobal

echo "[setupCMSSW123X] making L1Trigger folder..."

mkdir -p L1Trigger/L1TGlobal/data/Luminosity/startup/ && cd L1Trigger/L1TGlobal/data/Luminosity/startup/

echo "[setupCMSSW123X] retrieving L1 menu..."

wget https://raw.githubusercontent.com/mitaylor/HIMenus/main/Menus/L1Menu_CollisionsHeavyIons2022_v0_0_0.xml

cd $CMSSW_BASE/src

echo "[setupCMSSW123X] retrieving more info from git..."

git cms-merge-topic denerslemos:HLTBitAna_CMSSW_12_3_X

echo "[setupCMSSW123X] compiling code..."

scram b -j 8

echo "[setupCMSSW123X] Creating workstation folder..."

cd HLTrigger/Configuration/test && mkdir workstation && cd workstation

echo "[setupCMSSW123X] copying over triggerEmulation.sh..."

cp ../../../../../../triggerEmulation.sh .

echo "[setupCMSSW123X] done!"




