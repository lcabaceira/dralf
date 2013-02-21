#!/bin/bash
# source the properties:  
. ./dralf.properties 
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

