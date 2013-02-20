#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "Executing the Orphan Content Store Cleaner ..."
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=contentStoreCleanerTrigger
run executeNow
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx

