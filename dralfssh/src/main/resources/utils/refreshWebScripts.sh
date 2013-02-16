#!/bin/bash
# source the properties:  
. dralf.properties 
echo "Refreshing Web Scripts..."
curl http://${alfUser}:${alfPass}@${alfServer}:${alfPort}/share/page/index -dreset=on > ./logs/refreshWebScriptsResult.html


