#!/bin/bash

export WORK_DIR=/data/CRAB3-testing/
export CMSSW_release=$CMSSW
export SCRAM_ARCH=slc7_amd64_gcc700

mkdir -p repos
cd ${WORK_DIR}/repos

#clone needed directories
git clone https://github.com/dmwm/CRABClient.git
git clone https://github.com/dmwm/CRABServer.git

cp CRABServer/src/python/ServerUtilities.py CRABClient/src/python/
cp CRABServer/src/python/RESTInteractions.py CRABClient/src/python/

git clone https://github.com/dmwm/WMCore.git
cd WMCore; git checkout ${WMCore_tag}; cd ..

git clone https://github.com/dmwm/DBS.git
cd DBS; git checkout ${DBS_tag}

cd ${WORK_DIR}


myproxy-logon -d -n -l test-cmsbld-proxy-20201006 -s myproxy.cern.ch
export X509_USER_PROXY=`voms-proxy-info -path`
voms-proxy-init -noregen -voms cms -rfc
unset X509_USER_CERT
unset X509_USER_KEY


source /cvmfs/cms.cern.ch/cmsset_default.sh
scramv1 project ${CMSSW_release}

cd ${CMSSW_release}/src
eval `scramv1 runtime -sh`

set -x
GitDir=${WORK_DIR}/repos

MY_DBS=${GitDir}/DBS
MY_CRAB=${GitDir}/CRABClient
MY_WMCORE=${GitDir}/WMCore

export PYTHONPATH=${MY_DBS}/Client/src/python:${MY_DBS}/PycurlClient/src/python:$PYTHONPATH
export PYTHONPATH=${MY_WMCORE}/src/python:$PYTHONPATH
export PYTHONPATH=${MY_CRAB}/src/python:$PYTHONPATH

export PATH=${MY_CRAB}/bin:$PATH
source ${MY_CRAB}/etc/crab-bash-completion.sh

cd ${WORK_DIR}
set +x
