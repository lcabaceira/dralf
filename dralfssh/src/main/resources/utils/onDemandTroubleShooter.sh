#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "Welcome to the OnDemand Troubleshooter ..."

# If cache not working you have this last resource
#> java -jar ehcache-1.3.0-remote-debugger.jar
#Command line to list caches to monitor: java -jar ehcache-remote-debugger.jar path_to_ehcache.xml
#Command line to monitor a specific cache: java -jar ehcache-remote-debugger.jar path_to_ehcache.xml cacheName

#
function bounceAlfresco {
         echo " Boucing Application Server with Alfresco .... check logs "
         cd ${alfAppServerBin}
      	 ./shutdown.sh
      	 # TODO check when alfresco has finished its shutdown processes
      	 sleep 20   
     	 ./startup.sh
     	 cd -
     	 echo "... Alfresco is Starting, press any key to return to DrAlf menu..."    
}

function cifsDebug {  
echo "Adding Cifs Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.smb.protocol
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}


function ftpDebug {  
echo "Adding Ftp Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.ftp.protocol
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}

function webdavDebug {  
echo "Adding WebDav Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.webdav.protocol
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}

function fsDebug {  
echo "Adding File Servers Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.fileserver
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}


function modelingDebug {  
echo "Adding Property Sheets and Modeling Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.web.ui.repo.component.property.UIAssociation
set priority DEBUG
bean log4j:logger=org.alfresco.web.ui.repo.component.property.UIChildAssociation
set priority DEBUG
bean log4j:logger=org.alfresco.repo.dictionary
set priority DEBUG
bean log4j:logger=org.alfresco.repo.dictionary.types.period
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}

function clusterDebug {  
echo "Adding Clustering Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.repo.content.ReplicatingContentStore
set priority DEBUG
bean log4j:logger=org.alfresco.repo.content.replication
set priority DEBUG

bean log4j:logger=net.sf.ehcache.distribution
set priority DEBUG
bean log4j:logger=org.alfresco.repo.node.index.IndexTransactionTracker
set priority DEBUG
bean log4j:logger=org.alfresco.repo.node.index.AVMRemoteSnapshotTracker
set priority DEBUG
bean log4j:logger=org.alfresco.repo.jgroups
set priority DEBUG
bean log4j:logger=org.alfresco.enterprise.repo.cache.jgroups
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}


function cmisDebug {  
echo "Adding Cmis Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.opencmis
set priority DEBUG
bean log4j:logger=org.alfresco.opencmis.AlfrescoCmisServiceInterceptor
set priority DEBUG
bean log4j:logger=org.alfresco.cmis
set priority DEBUG
bean log4j:logger=org.alfresco.cmis.dictionary
set priority DEBUG
bean log4j:logger=org.apache.chemistry.opencmis
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}

function formsDebug {  
echo "Adding Forms Engine Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.repo.forms
set priority DEBUG
bean log4j:logger=org.alfresco.web.config.forms
set priority DEBUG
bean log4j:logger=org.alfresco.web.scripts.forms
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}


function imapDebug {  
echo "Adding Imap/Email Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.repo.imap
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}

function workflowDebug {  
echo "Adding workflowDebug jBpm and Activity Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.jbpm.graph.def.GraphElement
set priority DEBUG
bean log4j:logger=org.alfresco.repo.activities
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}

function endIt {
         echo " Exiting Tool .... "
         break
         exit 0
}

function webscriptsDebug {  
echo "Adding WebScripts Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.springframework.extensions.webscripts
set priority DEBUG
bean log4j:logger=org.springframework.extensions.webscripts.ScriptLogger
set priority DEBUG
bean log4j:logger=org.springframework.extensions.webscripts.ScriptDebugger
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}



function expertUser {  
read -p "Enter class name ( org.alfresco... ) :  " classname  
if [ "$classname" != "" ]; then
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=${classname}
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
fi
}


function metaExtractionDebug {  
echo "Adding MetaData Extraction Debug Options"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.repo.content.metadata.AbstractMappingMetadataExtracter
set priority DEBUG
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}

function revertAll {  
echo "Reverting all to WARN"
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean log4j:logger=org.alfresco.fileserver
set priority ERROR
bean log4j:logger=org.alfresco.webdav.protocol
set priority ERROR
bean log4j:logger=org.alfresco.ftp.protocol
set priority ERROR
bean log4j:logger=org.alfresco.smb.protocol
set priority ERROR
bean log4j:logger=org.alfresco.web.ui.repo.component.property.UIAssociation
set priority WARN
bean log4j:logger=org.alfresco.web.ui.repo.component.property.UIChildAssociation
set priority WARN
bean log4j:logger=org.alfresco.repo.dictionary
set priority WARN
bean log4j:logger=org.alfresco.repo.dictionary.types.period
set priority WARN 
bean log4j:logger=org.alfresco.repo.content.ReplicatingContentStore
set priority ERROR
bean log4j:logger=org.alfresco.repo.content.replication
set priority ERROR
bean log4j:logger=org.alfresco.opencmis
set priority ERROR
bean log4j:logger=org.alfresco.opencmis.AlfrescoCmisServiceInterceptor
set priority ERROR
bean log4j:logger=org.alfresco.cmis
set priority ERROR
bean log4j:logger=org.alfresco.cmis.dictionary
set priority WARN
bean log4j:logger=org.apache.chemistry.opencmis
set priority INFO
bean log4j:logger=org.alfresco.repo.forms
set priority INFO
bean log4j:logger=org.alfresco.web.config.forms
set priority INFO
bean log4j:logger=org.alfresco.web.scripts.forms
set priority INFO
bean log4j:logger=org.alfresco.repo.imap
set priority INFO
bean log4j:logger=org.jbpm.graph.def.GraphElement
set priority FATAL
bean log4j:logger=org.alfresco.repo.activities
set priority WARN
bean log4j:logger=org.springframework.extensions.webscripts
set priority INFO
bean log4j:logger=org.springframework.extensions.webscripts.ScriptLogger
set priority WARN
bean log4j:logger=org.springframework.extensions.webscripts.ScriptDebugger
set priority OFF
bean log4j:logger=org.alfresco.repo.content.metadata.AbstractMappingMetadataExtracter
set priority WARN
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
}


clear
select yn in "CIFS Debug" "FTP Debug" "Webdav Debug" "File Servers" "Content Modelling Debug" "Clustering Debug" "Forms Engine Debug" "CMIS Debug" "Email/Imap Debug" "Workflow Debug" "Webscripts Debug" "MetaData Extraction Debug" "Expert User Options" "Stop Troubleshooting" ; do
    case $yn in
        "CIFS Debug" ) cifsDebug; break;;
        "FTP Debug"  ) ftpDebug; break;;
        "Webdav Debug"  ) webdavDebug; break;;
        "File Servers"  ) fsDebug; break;;
        "Content Modelling Debug"  ) modelingDebug; break;;
        "Clustering Debug" ) clusterDebug; break;;
        "Forms Engine Debug" ) formsDebug; break;;
        "CMIS Debug" ) cmisDebug; break;;
        "Email/Imap Debug" ) imapDebug; break;;
        "Workflow Debug" ) workflowDebug; break;;
        "Webscripts Debug" ) webscriptsDebug; break;;
        "MetaData Extraction Debug" ) metaExtractionDebug; break;;
        "Expert User Options"  ) expertUser; break;;
        "Stop Troubleshooting"  ) revertAll; break;;
        * ) echo "InvalidOption";endIt;;
    esac
done

