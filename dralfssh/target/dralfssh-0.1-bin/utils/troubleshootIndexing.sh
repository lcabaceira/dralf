#!/bin/bash
# source the properties:  
. dralf.properties 
echo "Setting Indexing Sub-System Log Levels to DEBUG ...."
cat >./alfrescoScript.jmx<<EOF
domain log4j
bean log4j:logger=org.alfresco.repo.search.Indexer
set priority DEBUG
bean log4j:logger=org.alfresco.repo.search.impl.lucene.fts.FullTextSearchIndexerImpl
set priority DEBUG
bean log4j:logger=org.alfresco.repo.search.impl.lucene.index
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx

#run addAppender org.apache.log4j.FileAppender Cabaceira