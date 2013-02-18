#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "Setting Alfresco to WriteMode...."
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Type=Configuration,Category=sysAdmin,id1=default
set server.allowWrite true
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx

