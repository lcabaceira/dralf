#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "Setting Index Recover Mode to Validate...."
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Type=Configuration,Category=Search,id1=managed,id2=lucene
set index.recovery.mode VALIDATE
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx

