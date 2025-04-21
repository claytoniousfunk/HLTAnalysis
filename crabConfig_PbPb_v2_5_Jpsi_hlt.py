from WMCore.Configuration import Configuration

config = Configuration()

config.section_("General")
config.General.requestName = ""
config.General.workArea = 'crab_projects'
config.General.transferOutputs = True
config.General.transferLogs = True

config.section_("JobType")
config.JobType.pluginName = "Analysis"
config.JobType.psetName = ""
config.JobType.maxMemoryMB = 4000         # request high memory machines.
config.JobType.numCores = 1
config.JobType.allowUndistributedCMSSW = True #Problems with slc7
#config.JobType.maxJobRuntimeMin = 1000 #2750    # request longer runtime, ~48 hours.

config.section_("Data")
config.Data.inputDataset = ""
config.Data.inputDBS = 'phys03'
config.Data.splitting = 'FileBased'
config.Data.unitsPerJob = 100
config.Data.totalUnits = -1
config.Data.allowNonValidInputDataset = True #True

config.Data.outLFNDirBase = '/store//%s' % (config.General.requestName)
config.Data.publication = True
#config.Data.runRange = '362290-362299'
#config.Data.lumiMask = '/afs/cern.ch/cms/CAF/CMSCOMM/COMM_DQM/certification/Collisions16/13TeV/HI/Cert_285952-286496_HI8TeV_PromptReco_Pbp_Collisions16_JSON_NoL1T.txt'

config.section_("Site")
config.Site.storageSite = "T2_CH_CERN"
#config.Site.storageSite = "T2_KR_KISTI"
#config.Site.whitelist = ["T2_CH_CERN", "T2_FR_GRIF", "T2_FR_GRIF_LLR"]
