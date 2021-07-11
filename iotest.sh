#!/bin/bash 


RED='\033[031m'
GREEN='\033[032m'
YELLOW='\033[033m'
BLUE='\033[034m'
NC='\033[0m' 

mkdir iotest
cd iotest
curl http://ftp.sas.com/techsup/download/ts-tools/external/SASTSST_UNIX_installation.sh --output SASTSST_UNIX_installation.sh
chmod 777 SASTSST_UNIX_installation.sh
./ SASTSST_UNIX_installation.sh
