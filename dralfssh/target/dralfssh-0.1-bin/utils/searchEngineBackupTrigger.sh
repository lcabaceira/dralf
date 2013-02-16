#!/bin/bash
# source the properties:  
. dralf.properties 
echo "Running indexBackupTrigger...."
cat >./searchEngineBackupTrigger.jmx<<EOF
domain Alfresco
bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=search.indexBackupTrigger
run executeNow
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./searchEngineBackupTrigger.jmx 
rm -rf ./searchEngineBackupTrigger.jmx