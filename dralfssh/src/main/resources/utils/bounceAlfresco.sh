#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo " Boucing Application Server with Alfresco .... check logs "
cd ${alfAppServerBin}
./shutdown.sh
# TODO check when alfresco has finished its shutdown processes
sleep 20   
./startup.sh
cd -
echo "... Alfresco is Starting, press any key to return to DrAlf menu..."  

