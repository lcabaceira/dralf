#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "Setting LOG Levels to ERROR....."
cat >./alfrescoScript.jmx<<EOF
domain log4j
bean log4j:logger=org.alfresco.repo.search.Indexer
set priority ERROR
bean log4j:logger=org.alfresco.repo.search.impl.lucene.fts.FullTextSearchIndexerImpl
set priority ERROR
bean log4j:logger=org.alfresco.repo.search.impl.lucene.index
set priority ERROR
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx

