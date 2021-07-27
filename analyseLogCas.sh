#!/bin/bash


RED='\033[031m'
GREEN='\033[032m'
YELLOW='\033[033m'
BLUE='\033[034m'
NC='\033[0m' 


export casUserName=PMAA769

export logPath=/home/centos/analyseLogCAS/TEST1
export logCasCtrl=cas_2021-07-26_lp30022.posix.covea.priv_129846.log



grep $casUserName $logPath/$logCasCtrl > /tmp/$$.casCtrl

echo -en "${BLUE} Start ${NC}\n"

export startSession=$( grep "launchServicesLaunch"  /tmp/$$.casCtrl | cut -d " " -f 1 | head -1)
echo $startSession


export TackingSessionCtrl=$(grep "Tracking Session:" /tmp/$$.casCtrl | head -1 |cut -d "/" -f 1)
#echo $TackingSessionCtrl

export TackingSessionCtrlID=$(echo $TackingSessionCtrl | awk -F " " '{print $NF}' )

grep $TackingSessionCtrlID /tmp/$$.casCtrl > /tmp/$$.$TackingSessionCtrlID.casCtrl

echo -en "${BLUE} Connnect to worker node ${NC}\n"
grep tkcsesop  /tmp/$$.$TackingSessionCtrlID.casCtrl | grep "adding to queue"
grep tkcsesop  /tmp/$$.$TackingSessionCtrlID.casCtrl | grep "Session will wait for"
grep tkcsesop  /tmp/$$.$TackingSessionCtrlID.casCtrl | grep "Enough nodes are connected"

echo -en "${BLUE} Synchronizing caslibs ${NC}\n"
grep tkcaslib  /tmp/$$.$TackingSessionCtrlID.casCtrl | grep "Synchronizing caslibs"
grep tkcaslib  /tmp/$$.$TackingSessionCtrlID.casCtrl | grep "tkcaslib.c:3547" | tail -1


echo -en "${BLUE} Cas Action ${NC}\n"
grep  "casgeneral.c:942"  /tmp/$$.$TackingSessionCtrlID.casCtrl
grep "tkcastaba.c"  /tmp/$$.$TackingSessionCtrlID.casCtrl

grep "tkcsesinst.c:3968]"  /tmp/$$.$TackingSessionCtrlID.casCtrl


