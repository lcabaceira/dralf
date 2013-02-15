#!/bin/bash
# source the properties:  
. dralf.properties 
echo "Checking Alfresco License..."
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Name=License
bean
get Subject
get Days
get HeartBeatDisabled
get MaxUsers
get CloudSyncKeyAvailable
get LicenseMode
get Holder
get ValidUntil
get RemainingDays
get MaxDocs
get Issued
get Issuer
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ./logs/licenseChecker.log 
rm -rf ./alfrescoScript.jmx

