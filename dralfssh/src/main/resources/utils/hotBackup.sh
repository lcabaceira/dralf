#!/bin/bash
# source the properties:
# TODO - NOT BACKUP THE lucene indexes ( can generate conflicts ) 
. ./dralf.properties 
echo "... please wait ... Starting Alfresco Hot Backup   ..."  
    if [ $dbtype != 'mysql' -a $dbtype != 'postgres' ];
    then
        echo "... Sorry, currently DrAlf supports Hot Backup only on mysql or postgressql databases   ..." 
        echo "... You should use the specific database tools to perform an Hot Backup on $dbtype " 
        echo "... Exiting, Press any key to return to DrAlf menu ..." 
    else
    	echo "... Starting Hot Backup , lean back and Relax ... working ..."  
    	echo "... Running Content Store Cleanup  ..."
    	${drAlfDir}/utils/contentCleanUpJobTrigger.sh > ${drAlfDir}/logs/contentCleanUpJobTrigger.log
    if [ $searchengine != 'lucene' ];
    then 
      	echo "... Jmx - Triggering Backup for SOLR Indexes on both Cores Alfresco and Archive ..."
      	${drAlfDir}/utils/solrBackupTrigger.sh > ${drAlfDir}/logs/solrBackupTrigger.log
    else
    	echo "... Triggering Backup for Lucene Indexes  ..."
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
    		echo "... BackingUp $searchengine Indexes  ... Excluding the lucene-indexes Including backed up Solr indexes under the alf_data dir"
    		#tar --exclude "$alfDataDir/lucene-indexes/*" -czvf filesystem.tgz ${solrRoot}/solrdata/workspace ${alfDataDir}
    		tar --exclude "$alfDataDir/lucene-indexes/*" -czvf filesystem.tgz ${alfDataDir}
    	else
    		echo "... BackingUp $searchengine Indexes. Excluding the lucene-indexes ..."
      	    tar --exclude "$alfDataDir/lucene-indexes/*" -czvf filesystem.tgz ${alfDataDir}  
    	fi
    	echo "... Building your Alfresco backupfile .abk  ..."
    	tar -cvf ./backups/Backup-$(date +%Y%m%d%H%M).abk filesystem.tgz ${targetBackupFile} 
    	rm -rf ./filesystem.tgz ./${dbname}.sql
    	echo "... Press any key to continue ..."
    fi