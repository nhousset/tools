#!/bin/bash

export casUserName=PMAA769

export logPath=/home/centos/analyseLogCAS/TEST1
export logCasCtrl=cas_2021-07-26_lp30022.posix.covea.priv_129846.log



grep $casUserName $logPath/$logCasCtrl
