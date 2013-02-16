#!/bin/bash
# source the properties:  
. dralf.properties 
echo "Validating your environment with evtTool...."
./evt.sh -t mysql -h ${dbhost} -r ${dbport} -d ${dbname} -l ${dbuser} -p ${dbpass}



