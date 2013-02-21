#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "... please wait ... Starting Alfresco Hot Backup   ..."  
    if [ $dbtype != 'mysql' -a $dbtype != 'postgres' ];
    then
        echo "... Sorry, currently DrAlf supports Hot Backup only on mysql or postgressql databases   ..." 
        echo "... You should use the specific database tools to perform an Hot Backup on $dbtype " 
        echo "... Exiting, Press any key to return to DrAlf menu ..." 
    else
    	echo "... Starting Hot Backup , lean back and Relax DrAlf is working ..."  
    	echo "... Running Content Store Cleanup  ..."
    	${drAlfDir}/utils/contentCleanUpJobTrigger.sh > ${drAlfDir}/logs/contentCleanUpJobTrigger.log
    if [ $searchengine != 'lucene' ];
    then 
      	echo "... Triggering Backup for $searchengine Indexes  ..."
      	${drAlfDir}/utils/solrBackupTrigger.sh > ${drAlfDir}/logs/solrBackupTrigger.log
    else
    	echo "... Triggering Backup for $searchengine Indexes  ..."
    	${drAlfDir}/utils/searchEngineBackupTrigger.sh > ${drAlfDir}/logs/searchEngineBackupTrigger.log
    fi

    	echo "... Triggering a Hot Backup for $dbtype database  ..."
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
    		echo "... BackingUp $searchengine Indexes  ... Including backed up Solr indexes."
    		tar -czvf filesystem.tgz ${alfDataDir} ${solrRoot}/solrdata/workspace
    	else
    			echo "... BackingUp $searchengine Indexes. Lucene is part of alfresco filesystem ..."
      	    	tar -czvf filesystem.tgz ${alfDataDir}
    	fi
    	echo "... Building your Alfresco backupfile .abk  ..."
    	tar -cvf ./backups/Backup-$(date +%Y%m%d).abk filesystem.tgz ${targetBackupFile} 
    	rm -rf ./filesystem.tgz ./${dbname}.sql
    	echo "... Press any key to continue ..."
    fi

