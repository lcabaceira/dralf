#!/bin/bash
# source the properties:  
. dralf.properties 
echo "Running indexBackupTrigger...."
cat >./solrBackupTrigger.jmx<<EOF
domain Alfresco
bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=search.alfrescoCoreBackupTrigger 
run executeNow
bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=search.archiveCoreBackupTrigger
run executeNow
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./solrBackupTrigger.jmx 
rm -rf ./solrBackupTrigger.jmx
