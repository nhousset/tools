#!/bin/bash

export casUserName=PMAA769

export logPath=/home/centos/analyseLogCAS/TEST1
export logCasCtrl=cas_2021-07-26_lp30022.posix.covea.priv_129846.log



grep $casUserName $logPath/$logCasCtrl > /tmp/$$.casCtrl

export startSession=$( grep "launchServicesLaunch"  /tmp/$$.casCtrl | cut -d " " -f 1)
echo $startSession


export TackingSessionCtrl=$(grep "Tracking Session:" /tmp/$$.casCtrl | head -1 |cut -d "/" -f 1)
echo $TackingSessionCtrl

export TackingSessionCtrlID=$(echo $TackingSessionCtrl | awk -F " " '{print $NF}' )
echo $TackingSessionCtrlID

grep $TackingSessionCtrlID /tmp/$$.casCtrl > /tmp/$$.$TackingSessionCtrlID.casCtrl





