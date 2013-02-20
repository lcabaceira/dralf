#!/bin/bash
# source the properties:  
. ./dralf.properties 

function endIt {
         echo "  ... Exiting File Servers Changer.... "
         sleep 1
         exit 0
}


function cifschanger {
select operation in "Enable Cifs" "Disable Cifs" ; do
    case $operation in
        "Enable Cifs" ) cifsvalue="true"; break;;
        "Disable Cifs"  ) cifsvalue="false"; break;;
        * ) echo "InvalidOption";endIt;;
    esac
done
echo " Changing Fileserver SubSystem (CIFS) via JMX... "
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Name=FileServerConfig
run setCIFSServerEnabled ${cifsvalue}
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/logs/solrChanger.log
rm -rf ./alfrescoScript.jmx 
echo "Also Changing properties in alfresco-global.properties for consistency .... "
#usage: properties_changer.sh <property> <new value> <path properties file>
#./utils/properties_changer.sh index.subsystem.name lucene $alfProperties
}


function ftpchanger {
select operation in "Enable Ftp" "Disable Ftp" ; do
    case $operation in
        "Enable Ftp" ) ftpvalue="true"; break;;
        "Disable Ftp"  ) ftpvalue="false"; break;;
        * ) echo "InvalidOption";endIt;;
    esac
done
echo " Changing Fileserver SubSystem (FTP) via JMX... "
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Name=FileServerConfig
run setFTPServerEnabled ${ftpvalue}
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/logs/solrChanger.log
rm -rf ./alfrescoScript.jmx 
echo "Also Changing properties in alfresco-global.properties for consistency .... "
#usage: properties_changer.sh <property> <new value> <path properties file>
#./utils/properties_changer.sh index.subsystem.name lucene $alfProperties
}


function nfschanger {  
select operation in "Enable Nfs" "Disable Nfs" ; do
    case $operation in
        "Enable Nfs" ) nfsvalue="true"; break;;
        "Disable Nfs"  ) nfsvalue="false"; break;;
        * ) echo "InvalidOption";endIt;;
    esac
done
echo " Changing Fileserver SubSystem (NFS) via JMX... "
cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Name=FileServerConfig
run setNFSServerEnabled ${nfsvalue}
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/logs/solrChanger.log
rm -rf ./alfrescoScript.jmx 
echo "Also Changing properties in alfresco-global.properties for consistency .... "
#./utils/properties_changer.sh index.subsystem.name solr $alfProperties
#./utils/properties_changer.sh solr.host $solrhost $alfProperties
#./utils/properties_changer.sh solr.port $solrport $alfProperties
#./utils/properties_changer.sh solr.port.ssl $solrsslport $alfProperties
}



clear
select yn in "CIFS" "FTP" "NFS"; do
    case $yn in
        "CIFS" ) cifschanger; break;;
        "FTP"  ) ftpchanger; break;;
        "NFS"  ) nfschanger; break;;
        * ) echo "InvalidOption";endIt;;
    esac
done
