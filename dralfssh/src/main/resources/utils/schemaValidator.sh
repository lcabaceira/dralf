#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "Validating Alfresco Database Schema .... Dumping Schema to XML file ..."
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Name=DatabaseInformation,Tool=SchemaValidator 
run validateSchema
bean Alfresco:Name=DatabaseInformation,Tool=SchemaExport
run dumpSchemaToXML
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
tail -q -n6 ${alfRootDir}/tomcat/logs/catalina.out > ${drAlfDir}/reports/databaseSchemaValidator.log

