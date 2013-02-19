#!/bin/bash
# source the properties:  
. dralf.properties 
echo "Welcome to the Alfresco Schedule Jobs Manager ..."


function contentStoreCleaner {  
select operation in "Execute Content Store Cleaner Now" "Write Status Report" ; do
    case $operation in
        "Execute Content Store Cleaner Now" ) executevalue="true"; break;;
        "Write Status Report"  ) executevalue="false"; break;;
        * ) echo "InvalidOption";endIt;;
    esac
done

if [ "$executevalue" = true ]; then
  echo "Cleaning Orphan Content..."
  cat >./alfrescoScript.jmx<<EOF
    domain Alfresco
    bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=contentStoreCleanerTrigger
    run executeNow
    quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
else
    echo "Generating Content Store Cleaner Status Report"
 cat >./alfrescoScript.jmx<<EOF
    domain Alfresco
    bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=contentStoreCleanerTrigger
    get CronExpression
    get Group
    get JobGroup
    get JobName
    get MayFireAgain
    get Name
    get NextFireTime
    get PreviousFireTime
    get Priority
    get StartTime
    get State
    get TimeZone
    get Volatile
    quit
EOF
## Execute Command and write the report
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/logs/ContentStoreCleanerReport.log
rm -rf ./alfrescoScript.jmx
fi
}

function nodeServiceCleaner {  
select operation in "Execute Node Service Cleaner Now" "Write Status Report" ; do
    case $operation in
        "Execute Node Service Cleaner Now" ) executevalue="true"; break;;
        "Write Status Report"  ) executevalue="false"; break;;
        * ) echo "InvalidOption";endIt;;
    esac
done


if [ "$executevalue" = true ]; then
  echo "Executing Node Service Cleaner ..."
  cat >./alfrescoScript.jmx<<EOF
    domain Alfresco
    bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=nodeServiceCleanupTrigger
    run executeNow
    quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
else
    echo "Generating Node Service Cleaner Status Report"
 cat >./alfrescoScript.jmx<<EOF
    domain Alfresco
    bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=nodeServiceCleanupTrigger
    get CronExpression
    get Group
    get JobGroup
    get JobName
    get MayFireAgain
    get Name
    get NextFireTime
    get PreviousFireTime
    get Priority
    get StartTime
    get State
    get TimeZone
    get Volatile
    quit
EOF
## Execute Command and write the report
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/logs/NodeServiceCleanerReport.log
rm -rf ./alfrescoScript.jmx
fi
}

function indexBackup {  
select operation in "Execute Index Backup Now" "Write Status Report" ; do
    case $operation in
        "Execute Index Backup Now" ) executevalue="true"; break;;
        "Write Status Report"  ) executevalue="false"; break;;
        * ) echo "InvalidOption";;
    esac
done

if [ "$executevalue" = true ]; then
  echo "Performing Automated Backup of the Index ( Alfresco )  ..."
  cat >./alfrescoScript.jmx<<EOF
    domain Alfresco
    bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=search.alfrescoCoreBackupTrigger
    run executeNow
    quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
else
    echo "Generating utomated Backup of the Index Status Report"
 cat >./alfrescoScript.jmx<<EOF
    domain Alfresco
    bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=search.alfrescoCoreBackupTrigger
    get CronExpression
    get Group
    get JobGroup
    get JobName
    get MayFireAgain
    get Name
    get NextFireTime
    get PreviousFireTime
    get Priority
    get StartTime
    get State
    get TimeZone
    get Volatile
    quit
EOF
## Execute Command and write the report
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/logs/indexBackupReport.log
rm -rf ./alfrescoScript.jmx
fi
}

function tempCleaner {  
select operation in "Execute Temporary Files Cleaner Now" "Write Status Report" ; do
    case $operation in
        "Execute Temporary Files Cleaner Now" ) executevalue="true"; break;;
        "Write Status Report"  ) executevalue="false"; break;;
        * ) echo "InvalidOption";endIt;;
    esac
done


if [ "$executevalue" = true ]; then
  echo "Executing Alfresco Temporary Files Cleaner  ..."
  cat >./alfrescoScript.jmx<<EOF
    domain Alfresco
    bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=tempFileCleanerTrigger
    run executeNow
    quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx
else
    echo "Generating Node Service Cleaner Status Report"
 cat >./alfrescoScript.jmx<<EOF
    domain Alfresco
    bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=tempFileCleanerTrigger
    get CronExpression
    get Group
    get JobGroup
    get JobName
    get MayFireAgain
    get Name
    get NextFireTime
    get PreviousFireTime
    get Priority
    get StartTime
    get State
    get TimeZone
    get Volatile
    quit
EOF
## Execute Command and write the report
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/logs/TemporaryFilesCleanerReport.log
rm -rf ./alfrescoScript.jmx
fi
}

function ldapUserSync {  
 echo "Fired Ldap Syncronization..."
  cat >./alfrescoScript.jmx<<EOF
    domain Alfresco
    bean Alfresco:Type=Configuration,Category=Synchronization,id1=default
    run stop
    run start
    quit
EOF
## Execute Command and write the report
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ${drAlfDir}/logs/ldapUserSync.log
rm -rf ./alfrescoScript.jmx
}



clear
select yn in "Content Store Cleaner" "Node Service Cleaner" "Index Backup Trigger" "Temporary Files Cleaner" "Start Ldap User Syncronization"; do
    case $yn in
        "Content Store Cleaner" ) contentStoreCleaner;break;;
        "Node Service Cleaner"  ) nodeServiceCleaner;break;;
        "Index Backup Trigger"  ) indexBackup;break;;
        "Temporary Files Cleaner"  ) tempCleaner;break;;
        "Start Ldap User Syncronization") ldapUserSync;break;;
        * ) echo "InvalidOption";endIt;;
    esac
done

