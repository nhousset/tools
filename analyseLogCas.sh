#!/bin/bash


RED='\033[031m'
GREEN='\033[032m'
YELLOW='\033[033m'
BLUE='\033[034m'
NC='\033[0m' 


erreur()
{
	echo "error: unsupported option"
	usage
}

usage()
{
	
	echo ""
	echo "Usage:"
	echo "$0 [options]"
	echo ""
	echo "Try :"
	echo "$0 -u <user> -p <path> -f <file>"
	echo "$0 -u PMAA769 -p /home/centos/analyseLogCAS/TEST1 -f cas_2021-07-26_lp30022.posix.covea.priv_129846.log"
	echo ""
	
}

echo $OPTARG
while getopts "u:p:f:h" opt
do
   case "$opt" in
      u ) export casUserName="$OPTARG" ;;
      p ) export logPath="$OPTARG" ;;
      f ) export logCasCtrl="$OPTARG" ;;
	  h ) usage ;; 
      ? ) erreur ;; 
   esac
done

if [ "$casUserName" == "" ]
then
 erreur
 exit
fi


if [ "$logPath" == "" ]
then
 erreur
 exit
fi

if [ "$logCasCtrl" == "" ]
then
 erreur
 exit
fi

grep $casUserName $logPath/$logCasCtrl > /tmp/$$.casCtrl

echo -en "${BLUE} Start ${NC}\n"

#export startSession=$( grep "launchServicesLaunch"  /tmp/$$.casCtrl | cut -d " " -f 1 | head -1)
#echo $startSession

echo -en "${RED} Tracking Session ${NC}\n"

cat /tmp/$$.casCtrl  | grep 'session' | grep 'Process ID'  | awk '{print $1 $10 $11 $12}' 

exit;


export TackingSessionCtrl=$(grep "[casgeneral.c:4997] - Launched session controller. Process ID is " /tmp/$$.casCtrl | head -1 |cut -d "/" -f 1)
echo $TackingSessionCtrl

export TackingSessionCtrlID=$(echo $TackingSessionCtrl | awk -F " " '{print $NF}' )
echo $TackingSessionCtrlID
#export TackingSessionCtrlID=94273

exit;

grep $TackingSessionCtrlID /tmp/$$.casCtrl > /tmp/$$.$TackingSessionCtrlID.casCtrl

echo -en "${BLUE} Connnect to worker node ${NC}\n"
grep tkcsesop  /tmp/$$.$TackingSessionCtrlID.casCtrl | grep "adding to queue"
grep tkcsesop  /tmp/$$.$TackingSessionCtrlID.casCtrl | grep "Session will wait for"
grep tkcsesop  /tmp/$$.$TackingSessionCtrlID.casCtrl | grep "Enough nodes are connected"

echo -en "${BLUE} Synchronizing caslibs ${NC}\n"
grep tkcaslib  /tmp/$$.$TackingSessionCtrlID.casCtrl | grep "Synchronizing caslibs"
grep tkcaslib  /tmp/$$.$TackingSessionCtrlID.casCtrl | grep "tkcaslib.c:3547" | tail -1


echo -en "${BLUE} Cas Action ${NC}\n"
grep  "casgeneral.c:942"  /tmp/$$.$TackingSessionCtrlID.casCtrl > /tmp/$$.$TackingSessionCtrlID.casACtion
grep "tkcastaba.c"  /tmp/$$.$TackingSessionCtrlID.casCtrl > /tmp/$$.$TackingSessionCtrlID.casACtion
sort  /tmp/$$.$TackingSessionCtrlID.casACtion

echo -en "${BLUE} END ${NC}\n"
grep "tkcsesinst.c:3968]"  /tmp/$$.$TackingSessionCtrlID.casCtrl


