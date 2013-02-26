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
    echo "... please wait ... Executing Alfresco Hot Backup ..."
    ${drAlfDir}/utils/hotBackup.sh > ${drAlfDir}/logs/hotBackup.log 
}

function coldBackup {
    echo "... please wait ... Executing Alfresco cold Backup ..."
    ${drAlfDir}/utils/coldBackup.sh > ${drAlfDir}/logs/coldBackup.log 
}

function readonlyMode {
	${drAlfDir}/utils/readOnly.sh > ${drAlfDir}/logs/readOnly.log
}

function writeMode {
	${drAlfDir}/utils/writeMode.sh > ${drAlfDir}/logs/writeMode.log
}

function restoreAlfresco {
    echo "... please wait ... Restoring Alfresco from the last backup taken..."
    ${drAlfDir}/utils/restoreAlfresco.sh > ${drAlfDir}/logs/restoreAlfresco.log 
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
      echo "... please wait ... Bouncing Alfresco ..."
      ${drAlfDir}/utils/bounceAlfresco.sh > ${drAlfDir}/logs/bounceAlfresco.log
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


function endIt {
  echo " Exiting Tool .... "
  break
  exit 0
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
    echo "1)  Hot Backup                                              10) Bounce Alfresco"
    echo "2)  Cold Backup                                             11) Invalidate User Sessions"
    echo "3)  Restore Alfresco                                        12) Manage Scheduler Jobs"
    echo "4)  Set Alfresto to ReadOnly Mode                           13) File Servers Configuration"
    echo "5)  Set Alfresco to Write Mode                              14) OnDemand TroubleShooter"
    echo "6)  Troubleshoot Lucene Indexing                            15) Change Search SubSystem"
    echo "7)  Stop Troubleshoot Indexing                              16) Alfresco License checker"
    echo "8)  Jmx System Report                                       17) EvtValidate"
    echo "9)  Database Check                                          18) Quit"                                                       
    echo ''
    echo "Select an option:"
    echo ''

}


function mainMenu {
    select selection in "Hot Backup" "Cold Backup" "Restore Alfresco" "Set Alfresto to ReadOnly" "Set Alfresco to Write Mode" "Troubleshoot Lucene Indexing" "Stop Troubleshoot Indexing" "Jmx System Report" "Database Check" "Bounce Alfresco" "Invalidate User Sessions" "Manage Scheduler Jobs" "File Servers Configuration" "OnDemand TroubleShooter" "Change Search SubSystem" "Alfresco License checker" "EvtValidate" "Quit"; do
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
            "Bounce Alfresco"                ) bounceAlfresco;;
            "Invalidate User Sessions"       ) invalidateUserSessions;;
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
    echo "1)  Hot Backup                                              10) Bounce Alfresco"
    echo "2)  Cold Backup                                             11) Invalidate User Sessions"
    echo "3)  Restore Alfresco                                        12) Manage Scheduler Jobs"
    echo "4)  Set Alfresto to ReadOnly Mode                           13) File Servers Configuration"
    echo "5)  Set Alfresco to Write Mode                              14) OnDemand TroubleShooter"
    echo "6)  Troubleshoot Solr                                       15) Change Search SubSystem"
    echo "7)  Rebuild Solr Indexes                                    16) Alfresco License checker"
    echo "8)  Jmx System Report                                       17) EvtValidate"
    echo "9)  Database Check                                          18) Quit"                                                       
    echo ''
    echo "Select an option:"
    echo ''

}
function mainMenu {
    select selection in "Hot Backup" "Cold Backup" "Restore Alfresco" "Set Alfresto to ReadOnly" "Set Alfresco to Write Mode" "Troubleshoot Solr" "Rebuild Solr Indexes" "Jmx System Report" "Database Check"  "Bounce Alfresco" "Invalidate User Sessions" "Manage Scheduler Jobs" "File Servers Configuration" "OnDemand TroubleShooter" "Change Search SubSystem" "Alfresco License checker" "EvtValidate" "Quit"; do
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
            "Bounce Alfresco"                ) bounceAlfresco;;
            "Invalidate User Sessions"       ) invalidateUserSessions;;
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