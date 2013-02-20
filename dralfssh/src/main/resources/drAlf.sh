#!/bin/bash
#########################################################################################
# Main Script for DrAlf Processor
# Developed by Luis Cabaceira 28/02/2013
# DrAlf uses jmxterm -  documentation at http://wiki.cyclopsgroup.org/jmxterm/features
#########################################################################################
# IMPORTANT : Configure properties in drAlf.properties to match your environment details
########################################################################3################
# source the properties
. ./dralf.properties
# TODO1 : If mandatory executables dont exist on the system, prevent DrAlf from running
# TODO2 : Check if alfresco is stopped and when it has finish starting, better way to kill alfresco
# TODO3 : RESTORE with SOLR is different than RESTORE with LUCENE

checkexists() {
    while [ -n "$1" ]; do
        [ -n "$(which "$1")" ] || echo "WARNING $1": command not found "DrAlf will not work correctly without this program on the classpath";
        shift
    done
}
# checking for mandatory executables in the classpath for drAlf
if [ $dbtype != 'mysql' ]; then
			checkexists tar ls pg_dump	    		
else
			checkexists tar ls mysqldump 	
			
fi

# checking drAlf directory structure

	if [[ ! -e backups ]]; then
		echo "Backups directory does not exist, creating directory"
		mkdir -p ${drAlfDir}/backups 
	fi
	if [[ ! -e logs ]]; then
		echo "Logs directory does not exist, creating directory"
		mkdir -p ${drAlfDir}/logs 
	fi
	if [[ ! -e tmp ]]; then
		echo "Tmp directory does not exist, creating directory"
		mkdir -p ${drAlfDir}/tmp 
	fi
	if [[ ! -e reports ]]; then
		echo "Reports directory does not exist, creating directory"
		mkdir -p ${drAlfDir}/reports 
	fi

function hotBackup {
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
      			echo "... BackingUp $searchengine Indexes. Lucene is part of alfresco filesystem ..."
      	    	tar -czvf filesystem.tgz ${alfDataDir}/*
    	else
    		echo "... BackingUp $searchengine Indexes  ... Including backed up Solr indexes."
    		tar -czvf filesystem.tgz ${alfDataDir}/* ${solrRoot}/solrdata/workspace/*
    	fi
    

    	echo "... Building your Alfresco backupfile .abk  ..."
    	tar -cvf ./backups/Backup-$(date +%Y%m%d).abk filesystem.tgz ${targetBackupFile} 
    	rm -rf ./filesystem.tgz  ./${dbname}.sql
    	echo "... Press any key to continue ..."
    fi
}


function coldBackup {
    echo "... please wait ... Starting Alfresco Cold Backup   ..."  
    echo "... Executing Content Store Cleaner ..."
    ${drAlfDir}/utils/contentCleanUpJobTrigger.sh > ${drAlfDir}/logs/contentCleanUpJobTrigger.log
    echo "... Shutting Down alfresco  ..."
      cd ${alfAppServerBin}
      ./shutdown.sh
      cd -
      # TODO check when alfresco has finished its shutdown processes
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
      			echo "... BackingUp $searchengine Indexes. Lucene is part of alfresco filesystem ..."
      	    	tar -czvf filesystem.tgz ${alfDataDir}/*
    	else
    		echo "... BackingUp $searchengine Indexes  ... Including backed up Solr indexes."
    		tar -czvf filesystem.tgz ${alfDataDir}/* ${solrRoot}/solrdata/workspace/*
    	fi
    	
    	echo "... Building your Alfresco backupfile .abk  ..."
    	tar -cvf ./backups/Backup-$(date +%Y%m%d).abk filesystem.tgz ${targetBackupFile} 
    	rm -rf ./filesystem.tgz  ./${dbname}.sql
    	echo "... Cold Backup Complete ... Starting Alfresco ..."
    	cd ${alfAppServerBin}
     	./startup.sh
     	echo "... Alfresco is Starting, press any key to return to DrAlf menu..."
    fi
}

function readonlyMode {
	${drAlfDir}/utils/readOnly.sh > ${drAlfDir}/logs/readOnly.log
}

function writeMode {
	${drAlfDir}/utils/writeMode.sh > ${drAlfDir}/logs/writeMode.log
}

function restoreAlfresco {
      echo "... please wait ... Restoring Alfresco from the last Backup taken with DrAlf  ..." 
      echo "... Changing index.recovery.mode to AUTO using JMX to force index rebuilding   ..."
      ${drAlfDir}/utils/indexAutoRecover.sh > ${drAlfDir}/logs/indexAutoRecover.log
      echo "... Shutting Down alfresco  ..."
      cd ${alfAppServerBin}
      ./shutdown.sh
      cd -
      sleep 20
      # getting the latest backup version
      lastAbkFile=`ls -latr ${drAlfDir}/backups/*.abk | grep ^- |  tail -n 1 | awk '{print $9}'`
      echo "last backup file is $lastAbkFile" 
      echo "Unzipping Backup File ... " 
      tar -xvf ${lastAbkFile} 
      echo "Restoring Alfresco Filesystem ( Including search engine Index data )  ... " 
      tar -xvzf ./filesystem.tgz -C /
      echo "Restoring the database  ... " 
      if [ $dbtype != 'mysql' ];
    	then
    		echo "... Restoring PostGres Backup   ..."
    		pg_restore -d ${dbname} ./${dbname}.pgd
    		rm -rf ./${dbname}.pgd
    	else
    		echo "... Restoring MySql Backup   ..."
    		mysql -u ${dbrootuser} -p${dbrootpassword} ${dbname} < ${dbname}.sql
    		rm -rf ./${dbname}.sql
    	fi
     rm -rf ./filesystem.tgz
     echo "Restoring the search engine Indexes from the backup directory ... "
     cp -R ${alfDataDir}/backup-lucene-indexes ${alfDataDir}/lucene-indexes
     echo "DrAlf is Starting up your restored Alfresco System....  "
     cd ${alfAppServerBin}
     ./startup.sh
     echo "... Alfresco is Starting, press any key to return to DrAlf menu..."
}



function debugIndexing {
    echo "... please wait ... Debugging Indexing SubSystem ..."
    echo "... Setting Log Levels to DEBUG "
    ${drAlfDir}/utils/troubleshootIndexing.sh > ${drAlfDir}/logs/troubleshootIndexing.log
}

function stopDebugIndexing {
     echo "... please wait ... Stopping the Debug on the Indexing SubSystem ..."
     echo "... Setting Log Levels back to ERROR ..."
    ${drAlfDir}/utils/stoptroubleshootIndexing.sh > ${drAlfDir}/logs/stoptroubleshootIndexing.log
}


function jmxSystemReport {
    echo "... please wait ... Generating JmxSystemReport ..." 
    ${drAlfDir}/utils/jmxSystemReport.sh > ${drAlfDir}/logs/jmxSystemReport.log        
}

function invalidateUserSessions {
    echo "... please wait ... Invalidating User Sessions ..." 
    ${drAlfDir}/utils/invalidateUserSessions.sh > ${drAlfDir}/logs/invalidateUserSessions.log        
}

function databaseCheck {
    echo "... please wait ... Checking Database Schema ..."
    ${drAlfDir}/utils/schemaValidator.sh > ${drAlfDir}/logs/schemaValidator.log
}

function executeContentStoreCleaner {
    echo "... please wait ... Executing Content Store Cleaner ..."
    ${drAlfDir}/utils/contentCleanUpJobTrigger.sh > ${drAlfDir}/logs/contentCleanUpJobTrigger.log
}

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

function manageSchedulerJobs {
    echo "... Scheduler Jobs Manager  ..."
    ${drAlfDir}/utils/scheduleJobsManager.sh > ${drAlfDir}/logs/scheduleJobsManager.log 
}

function manageFileServers {
         echo " Managing FileServers ....  "
         ${drAlfDir}/utils/fileServerSubsystemChanger.sh > ${drAlfDir}/logs/fileServerSubsystemChanger.log            
}

function onDemandTroubleShooter {
    echo "... OnDemand TroubleShooter - Helping you to Debug ..."   
    ${drAlfDir}/utils/onDemandTroubleShooter.sh > ${drAlfDir}/logs/onDemandTroubleShooter.log     
}

function searchSubsystemChanger {
	echo "To what search manager to you want to change [solr | lucene] ? "
    ${drAlfDir}/utils/searchSubSystemChanger.sh > ${drAlfDir}/logs/searchSubSystemChanger.log        
}

function licenseChecker {
    echo "... please wait ... Checking Alfresco License.."     
    ${drAlfDir}/utils/licenseChecker.sh > ${drAlfDir}/logs/licenseChecker.log   
}


function checkLock {
    if [ ! -r ToolRunner.lck ]
    then
        ant lockStart > lockStart.log
    else
        echo "DrAlf is in Use, wait until other user finishes"
    exit -1
    fi
}


function checkOptionLock {
    if [ -r "$1"Runner.lck ]
    then
         echo "The option "$1" is being run by another user, please wait and try again later"
         exit -1
    fi
}



function endIt {
         echo " Exiting Tool .... "
         break
         exit 0
}


function manageAutenticationChain {
clear
echo " Managing your authentication Chain Tool .... "
}

function evtValidate {
clear
  ${drAlfDir}/evtExecuter.sh
}

function rebuildSolrIndexes {
clear
  ${drAlfDir}/utils/rebuildSolrIndexes.sh
}

function troubleshootSolr {
clear
  ${drAlfDir}/utils/troubleshootSolr.sh
}


   
function showHeaders {
    clear
    echo '*********************************************************************************************'
    echo '*                                         DrAlf Processor 0.1                               *'
    echo '*                                       Developed for Alfresco 4                            *'
    echo '*                                              CS 2013                                      *'
    echo '*********************************************************************************************'
    # Load the properties file
}



if [ $searchengine != 'solr' ];
then

function showOptions {
    echo "1)  Hot Backup                                              11) Bounce Alfresco"
    echo "2)  Cold Backup                                             12) Invalidate User Sessions"
    echo "3)  Restore Alfresco                                        13) Manage Authentication Chain"
    echo "4)  Set Alfresto to ReadOnly Mode                           14) Manage Scheduler Jobs"
    echo "5)  Set Alfresco to Write Mode                              15) File Servers Configuration"
    echo "6)  Troubleshoot Lucene Indexing                            16) OnDemand TroubleShooter"
    echo "7)  Stop Troubleshoot Indexing                              17) Change Search SubSystem"
    echo "8)  Jmx System Report                                       18) Alfresco License checker"
    echo "9)  Database Check                                          19) EvtValidate"                                                       
    echo "10) Execute Content Store Cleaner                           20) Quit" 
    echo ''
    echo "Select an option:"
    echo ''

}


function mainMenu {
    select selection in "Hot Backup" "Cold Backup" "Restore Alfresco" "Set Alfresto to ReadOnly" "Set Alfresco to Write Mode" "Troubleshoot Lucene Indexing" "Stop Troubleshoot Indexing" "Jmx System Report" "Database Check" "Execute Content Store Cleaner" "Bounce Alfresco" "Invalidate User Sessions" "Manage Authentication Chain" "Manage Scheduler Jobs" "File Servers Configuration" "OnDemand TroubleShooter" "Change Search SubSystem" "Alfresco License checker" "EvtValidate" "Quit"; do
        case "$selection" in
            "Hot Backup"                     ) hotBackup;;
            "Cold Backup"                    ) coldBackup;;
            "Restore Alfresco"               ) restoreAlfresco;;
            "Set Alfresto to ReadOnly"       ) readonlyMode;;
            "Set Alfresco to Write Mode"     ) writeMode;;
            "Troubleshoot Lucene Indexing"   ) debugIndexing;;
            "Stop Troubleshoot Indexing"     ) stopDebugIndexing;;
            "Jmx System Report"              ) jmxSystemReport;;
            "Database Check"                 ) databaseCheck;;
            "Execute Content Store Cleaner"  ) executeContentStoreCleaner;;
            "Bounce Alfresco"                ) bounceAlfresco;;
            "Invalidate User Sessions"       ) invalidateUserSessions;;
            "Manage Authentication Chain"    ) manageAutenticationChain;;
            "Manage Scheduler Jobs"          ) manageSchedulerJobs;;
            "File Servers Configuration"     ) manageFileServers;;
            "OnDemand TroubleShooter"        ) onDemandTroubleShooter;;
            "Change Search SubSystem"        ) searchSubsystemChanger;;
            "Alfresco License checker"       ) licenseChecker;;
            "EvtValidate"                    ) evtValidate;;
            "Quit"                           ) endIt;;
            * ) echo 'Invalid Option';;  
    esac
    stty -icanon
    Keypress=$(head -c1)
    showHeaders
    showOptions
    done
}

else
# WITH SOLR MENU
function showOptions {
    echo "1)  Hot Backup                                              11) Bounce Alfresco"
    echo "2)  Cold Backup                                             12) Invalidate User Sessions"
    echo "3)  Restore Alfresco                                        13) Manage Authentication Chain"
    echo "4)  Set Alfresto to ReadOnly Mode                           14) Manage Scheduler Jobs"
    echo "5)  Set Alfresco to Write Mode                              15) File Servers Configuration"
    echo "6)  Troubleshoot Solr                                       16) OnDemand TroubleShooter"
    echo "7)  Rebuild Solr Indexes                                    17) Change Search SubSystem"
    echo "8)  Jmx System Report                                       18) Alfresco License checker"
    echo "9)  Database Check                                          19) EvtValidate"                                                       
    echo "10) Execute Content Store Cleaner                           20) Quit" 
    echo ''
    echo "Select an option:"
    echo ''

}


function mainMenu {
    select selection in "Hot Backup" "Cold Backup" "Restore Alfresco" "Set Alfresto to ReadOnly" "Set Alfresco to Write Mode" "Troubleshoot Solr" "Rebuild Solr Indexes" "Jmx System Report" "Database Check" "Execute Content Store Cleaner" "Bounce Alfresco" "Invalidate User Sessions" "Manage Authentication Chain" "Manage Scheduler Jobs" "File Servers Configuration" "OnDemand TroubleShooter" "Change Search SubSystem" "Alfresco License checker" "EvtValidate" "Quit"; do
        case "$selection" in
            "Hot Backup"                     ) hotBackup;;
            "Cold Backup"                    ) coldBackup;;
            "Restore Alfresco"               ) restoreAlfresco;;
            "Set Alfresto to ReadOnly"       ) readonlyMode;;
            "Set Alfresco to Write Mode"     ) writeMode;;
            "Troubleshoot Solr"              ) troubleshootSolr;;
            "Rebuild Solr Indexes"           ) rebuildSolrIndexes;;
            "Jmx System Report"              ) jmxSystemReport;;
            "Database Check"                 ) databaseCheck;;
            "Execute Content Store Cleaner"  ) executeContentStoreCleaner;;
            "Bounce Alfresco"                ) bounceAlfresco;;
            "Invalidate User Sessions"       ) invalidateUserSessions;;
            "Manage Authentication Chain"    ) manageAutenticationChain;;
            "Manage Scheduler Jobs"          ) manageSchedulerJobs;;
            "File Servers Configuration"     ) manageFileServers;;
            "OnDemand TroubleShooter"        ) onDemandTroubleShooter;;
            "Change Search SubSystem"        ) searchSubsystemChanger;;
            "Alfresco License checker"       ) licenseChecker;;
            "EvtValidate"                    ) evtValidate;;
            "Quit"                           ) endIt;;
            * ) echo 'Invalid Option';;  
    esac
    stty -icanon
    Keypress=$(head -c1)
    showHeaders
    showOptions
    done
}


	
fi
    	

showUsage() {
   echo Usage:
   echo     $0 menu
   exit 1
}

if [ $# -eq 0 ]; then
   showUsage
else
   ACTION=$1
fi

case $ACTION in
    menu     ) clear;showHeaders;mainMenu;;
    \?       ) showUsage;;
    *        ) showUsage;;
esac





