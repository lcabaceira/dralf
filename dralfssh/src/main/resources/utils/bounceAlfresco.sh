#!/bin/bash
# source the properties:  
. ./dralf.properties


echo " Boucing Application Server with Alfresco .... check logs "
#cd ${alfAppServerBin}
#./shutdown.sh
${drAlfDir}/utils/alfrescoAgent.sh restart
echo "... Alfresco is Starting, press any key to return to DrAlf menu..."  

