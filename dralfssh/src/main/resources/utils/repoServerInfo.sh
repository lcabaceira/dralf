#!/bin/bash
# source the properties:  
. ./dumper.properties 
echo "Reading Information on the Repository Server..."
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Name=RepoServerMgmt
#information on the bean
info
# Get the number of users
get UserCountNonExpired
# Get the existing names
run listUserNamesNonExpired
#Invalidate the session of user admin
run invalidateUser admin
#Invalidate all sessions of users
run invalidateTicketsAll
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx >  ${drAlfDir}/logs/RepoServerInfoOut.txt
rm -rf ./alfrescoScript.jmx

