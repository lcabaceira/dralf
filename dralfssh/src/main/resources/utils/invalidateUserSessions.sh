#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "Invalidating all Alfresco user Sessions...."
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Name=RepoServerMgmt
run invalidateTicketsAll
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx

