#!/bin/bash
# source the properties:  
. ../dralf.properties
encKeyLoc=`./parser.sh encryption.ssl.keystore.location ${alfProperties}`
encKeyProv=`./parser.sh encryption.ssl.keystore.provider ${alfProperties}` 
encKeyType=`./parser.sh encryption.ssl.keystore.type ${alfProperties}`
encKeyMetaLoc=`./parser.sh encryption.ssl.keystore.keyMetaData.location ${alfProperties}`
encTruLoc=`./parser.sh encryption.ssl.truststore.location ${alfProperties}`
encTruProv=`./parser.sh encryption.ssl.truststore.provider ${alfProperties}` 
encTruType=`./parser.sh encryption.ssl.truststore.type ${alfProperties}`
encTruMetaLoc=`./parser.sh encryption.ssl.truststore.keyMetaData.location ${alfProperties}`

echo "Installing Solr .... ${sacra}"

if [ "$encKeyLoc" == "" ]; then 
#echo "encryption.ssl.keystore.location=${alfDataDir}/keystore" >> ${alfProperties}
fi

if [ "$encKeyProv" == "" ]; then 
#echo "encryption.ssl.keystore.provider=${alfDataDir}/keystore" >> ${alfProperties}
fi

if [ "$encKeyType" == "" ]; then 
#echo "encryption.ssl.keystore.type=${alfDataDir}/keystore" >> ${alfProperties}
fi

if [ "$encKeyMetaLoc" == "" ]; then 
#echo "encryption.ssl.keystore.keyMetaData.location=${alfDataDir}/keystore" >> ${alfProperties}
fi

if [ "$encTruLoc" == "" ]; then 
#echo "encryption.ssl.truststore.location=${alfDataDir}/keystore" >> ${alfProperties}
fi

if [ "$encTruProv" == "" ]; then 
#echo "encryption.ssl.truststore.provider=${alfDataDir}/keystore" >> ${alfProperties}
fi

if [ "$encTruType" == "" ]; then 
#echo "encryption.ssl.truststore.type=${alfDataDir}/keystore" >> ${alfProperties}
fi

if [ "$encTruMetaLoc" == "" ]; then 
#echo "encryption.ssl.truststore.keyMetaData.location=${alfDataDir}/keystore" >> ${alfProperties}
fi

select yn in "Install Solr in the same tomcat Server as Alfresco" "Install Solr in a dedicated Tomcat"; do
    case $yn in
        "Install Solr in the same Server as Alfresco" ) cifschanger; break;;
        "Install Solr in a dedicated Tomcat"  ) ftpchanger; break;;
        * ) echo "InvalidOption";endIt;;
    esac
done