#!/bin/bash
# source the properties:  
. ./dralf.properties 

function endIt {
         echo "  ... Exiting search SubSystem Changer.... "
         sleep 1
         exit 0
}

function solrchanger {  
read -p "Enter your solr hostname ( you should have installed solr in tomcat )  :  " solrhost
read -p "Enter your solr port number :  " solrport
read -p "Enter your solr ssl port :  " solrsslport
echo " Changing Search SubSystem to solr via JMX... "
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Type=Configuration,Category=Search,id1=manager
set sourceBeanName solr
bean Alfresco:Type=Configuration,Category=Search,id1=managed,id2=solr
set solr.host ${solrhost}
set solr.port ${solrport}
set solr.port.ssl ${solrsslport}
bean Alfresco:Type=Configuration,Category=Search,id1=manager
run stop
run start
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/logs/solrChanger.log
rm -rf ./alfrescoScript.jmx 
echo "Also Changing properties in alfresco-global.properties for consistency .... "
${drAlfDir}/utils/properties_changer.sh index.subsystem.name solr $alfProperties
${drAlfDir}/utils/properties_changer.sh solr.host $solrhost $alfProperties
${drAlfDir}/utils/properties_changer.sh solr.port $solrport $alfProperties
${drAlfDir}/utils/properties_changer.sh solr.port.ssl $solrsslport $alfProperties
${drAlfDir}/utils/properties_changer.sh solr.secureComms https $alfProperties
}

function lucenechanger {
read -p "Select Indexing Recovery Mode  ( AUTO | VALIDATE | FULL ) :  " recoveryMode  
if [ "$recoveryMode" = AUTO ]; then
  echo "Changing it to AUTO"
elif [ "$recoveryMode" = VALIDATE ]; then
  echo "Changing it to VALIDATE"
elif [ "$recoveryMode" = FULL ]; then
    echo "Changing it to FULL"
else
  echo "INVALID OPTION - EXITING "
  exit 0
fi
read -p "Enable Content Indexing ( true | false ) :  " enableIndexing
if [ "$enableIndexing" = true ]; then
  echo "Changing it to true"
elif [ "$enableIndexing" = false ]; then
  echo "Changing it to false"
else
  echo "INVALID OPTION - EXITING "
  exit 0
fi
echo " Changing Search SubSystem to lucene via JMX... "
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Type=Configuration,Category=Search,id1=manager
set sourceBeanName lucene
bean Alfresco:Type=Configuration,Category=Search,id1=managed,id2=lucene
set index.recovery.mode ${recoveryMode}
set lucene.indexer.contentIndexingEnabled ${enableIndexing} 
bean Alfresco:Type=Configuration,Category=Search,id1=manager
run stop
run start
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/logs/solrChanger.log
rm -rf ./alfrescoScript.jmx 
echo "Also Changing properties in alfresco-global.properties for consistency .... "
#usage: properties_changer.sh <property> <new value> <path properties file>
${drAlfDir}/utils/properties_changer.sh index.subsystem.name lucene $alfProperties
}

clear
select yn in "solr" "lucene"; do
    case $yn in
        solr ) solrchanger; break;;
        lucene ) lucenechanger; break;;
        * ) echo "Please answer solr or lucene";endIt;;
    esac
done


   
 
