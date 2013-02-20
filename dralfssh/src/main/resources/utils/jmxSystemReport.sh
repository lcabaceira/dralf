#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "Generating System Report from the Monitoring Beans...."
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Name=RepositoryDescriptor,Type=Server
bean
get Version
get Edition
bean Alfresco:Name=Runtime
bean
get TotalMemory
get MaxMemory
get FreeMemory
bean Alfresco:Name=Authority
bean
get NumberOfGroups
get NumberOfUsers
bean Alfresco:Name=ConnectionPool
bean
get NumActive
get NumIdle
get InitialSize
get MaxActive
get MaxIdle
get MaxWait
bean Alfresco:Name=ContentTransformer,Type=ImageMagick
bean
get Available
get VersionString
bean Alfresco:Name=ContentTransformer,Type=pdf2swf
bean
get Available
get VersionString
bean Alfresco:Name=LuceneIndexes,Index=workspace/SpacesStore
bean
get ActualSize
get EntryStatus
get EventCounts
get NumberOfDocuments
get NumberOfFields
get NumberOfIndexedFields
get UsedSize
bean Alfresco:Name=LuceneIndexes,Index=archive/SpacesStore
bean
get ActualSize
get EntryStatus
get EventCounts
get NumberOfDocuments
get NumberOfFields
get NumberOfIndexedFields
get UsedSize
bean Alfresco:Name=LuceneIndexes,Index=user/alfrescoUserStore
bean
get ActualSize
get EntryStatus
get EventCounts
get NumberOfDocuments
get NumberOfFields
get NumberOfIndexedFields
get UsedSize
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/reports/jmxSystemReport.log
rm -rf ./alfrescoScript.jmx

