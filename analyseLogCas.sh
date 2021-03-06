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
	echo "$0 -u <user> -p <path> -f <file> -t <table>"
	echo "$0 -u PMAA769 -p /home/centos/analyseLogCAS/TEST1 -f cas_2021-07-26_lp30022.posix.covea.priv_129846.log -t PUMA"
	echo ""
	
}

echo $OPTARG
while getopts "u:p:f:t:h" opt
do
   case "$opt" in
      u ) export casUserName="$OPTARG" ;;
      p ) export logPath="$OPTARG" ;;
      f ) export logCasCtrl="$OPTARG" ;;
      t ) export tableToFilter="$OPTARG" ;;
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

listSession()
{
	for sessionId in $(cat /tmp/$$.casCtrl  | grep 'session' | grep 'Process ID'  | awk '{print $1"|"$15}' | cut -d "." -f 1 )
	do
		dateSession=$(echo $sessionId | cut -d "|" -f 1)
		idSession=$(echo $sessionId | cut -d "|" -f 2)
	
		if [ "$tableToFilter" == "" ]
		then
			FindInMemoryTable=$(grep $idSession /tmp/$$.casCtrl | grep  FindInMemoryTable| grep -v "="  |  awk '{print $NF}' | cut -d "(" -f 2 |  cut -d ")" -f 1 | sort -u | tail -3 ) 
		else
			FindInMemoryTable=$(grep $idSession /tmp/$$.casCtrl | grep  FindInMemoryTable|  grep -v "="  |  awk '{print $NF}' | cut -d "(" -f 2 |  cut -d ")" -f 1 | sort -u | grep $tableToFilter | tail -3 ) 
		fi
		endSession=$(grep $idSession /tmp/$$.casCtrl | grep "tkcsesinst.c:3968]" | tail -1  | awk '{print $1}' )
		
		if [ "$FindInMemoryTable" != "" ]
		then
			echo -en "${YELLOW}"$dateSession"${NC} "$endSession" ${YELLOW}"$idSession"${NC} "$FindInMemoryTable"\n"
		fi
	done
}

#FindInMemoryTable

listSession
echo -en "${BLUE} Enter session ID (q to quit) : ${NC}"
read TackingSessionCtrlID
while [ $TackingSessionCtrlID <> "q" ] 
do

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

	
	
	echo -en "${BLUE} Press a key to continue ${NC}\n"
	read pause
	echo ""
	echo "**************************************************************"
	echo ""
	listSession
	echo -en "${BLUE} Enter session ID (q to quit) : ${NC}"
	read TackingSessionCtrlID
done
