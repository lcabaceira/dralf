#!/bin/bash
# source the properties:  
. ./dralf.properties 
    echo "... please wait ... Starting Alfresco Cold Backup   ..."  
    echo "... Executing Content Store Cleaner ..."
    ${drAlfDir}/utils/contentCleanUpJobTrigger.sh > ${drAlfDir}/logs/contentCleanUpJobTrigger.log
    echo "... Shutting Down alfresco  ..."
      ${drAlfDir}/utils/alfrescoAgent.sh stop
      sleep 20
    if [ $dbtype != 'mysql' -a $dbtype != 'postgres' ];
    then
        echo "... Sorry, currently DrAlf supports Cold Backup only on mysql or postgressql databases   ..." 
        echo "... You should use the specific database tools to perform an Hot Backup on $dbtype " 
        echo "... Exiting, Press any key to return to DrAlf menu ..." 
    else
    	echo "... Starting Hot Backup , Just lean back and Relax DrAlf will take care of everything ..."  
    	if [ $searchengine != 'lucene' ];
   		then 
      		echo "... Triggering Backup for $searchengine Indexes  ..."
      		${drAlfDir}/utils/solrBackupTrigger.sh > ${drAlfDir}/logs/solrBackupTrigger.log
    	else
    		echo "... Triggering Backup for $searchengine Indexes  ..."
    		${drAlfDir}/utils/searchEngineBackupTrigger.sh > ${drAlfDir}/logs/searchEngineBackupTrigger.log
    	fi
    	echo "... Triggering a Backup for $dbtype database  ..."
    	if [ $dbtype != 'mysql' ];
    	then
    		echo "... PostGres Backup $dbname database  ..."
    		pg_dump -Fc  ${dbname} > ./${dbname}.pgd
    		targetBackupFile=${dbname}.pgd 
    	else
    		echo "... MySql Hot Backup $dbname database  ..."
    		mysqldump -q -u ${dbuser} -p${dbpass} ${dbname} > ./${dbname}.sql 
    		targetBackupFile=${dbname}.sql 
    	fi
    	echo "... Backing Up your repository filesystem  ..."
    	if [ $searchengine != 'lucene' ];
    	then 			      	    	
    		echo "... BackingUp $searchengine Indexes  ... Excluding the lucene-indexes Including backed up Solr indexes under the alf_data dir"
    		tar --exclude "$alfDataDir/lucene-indexes/*" -czvf filesystem.tgz ${alfDataDir}
    	else
    		echo "... BackingUp $searchengine Indexes. Excluding the lucene-indexes ..."
      	    tar --exclude "$alfDataDir/lucene-indexes/*" -czvf filesystem.tgz ${alfDataDir}  
    	fi
    	echo "... Building your Alfresco backupfile .abk  ..."
    	tar -cvf ./backups/Backup-$(date +%Y%m%d%H%M).abk filesystem.tgz ${targetBackupFile} 
    	rm -rf ./filesystem.tgz  ./${dbname}.sql
    	echo "... Cold Backup Complete ... Starting Alfresco ..."
     	${drAlfDir}/utils/alfrescoAgent.sh start
     	echo "... Alfresco is Starting, press any key to return to DrAlf menu..."
    fi

