------------------------------
Dr Alf Technical Details - 0.1
------------------------------

This document contains the technical details on each one of the actions exposed by DrAlf.

    Project location : https://github.com/lcabaceira/dralf

-----------------
Target Audience :
-----------------

    Alfresco Administrators 
    Alfresco developers and Alfresco Students
    A Tool for Alfresco Support Team 

----------------------------
Maven Multi Module Project :
----------------------------

DrAlf is released as a multi-module maven project but currently only dralfssh module is being used.
The other dralfjar module is reserved for future usage as the project grows.

--------------------------------
0 - SEARCH ENGINE BACKUP TRIGGER
-------------------------------- 

    * Script Name : searchEngineBackupTrigger.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=search.indexBackupTrigger
    * Bean Type   : MonitoredCronTrigger
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco   

Description : This script executes the Alfresco indexBackupTrigger schedule Job.

    - Trigger the Search Sub System Indexes Backup Scheduled Job

It executes the same action that you can see on the following jconsole screenshot.

<img align="left" src="images/IndexBackupTrigger.png" alt="Schedule Task Execution"/> 

----------------
1 - HOT BACKUP :
---------------- 

    * Script Name : hotBackup.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : N/A
    * Bean Type   : N/A
    * Jmx Server  : N/A   
    * Jmx Domain  : N/A  

Description : This script automates a full Alfresco Backup according to the recommended best practices.

    - Run the Content Store Cleanup Scheduled Job
    - Trigger the Search Sub System Indexes Backup Scheduled Job
    - Execute the database Hot Backup procedure
    - Backup the repository filesystem
    - Backup Search Sub System Indexes
    - Build the backup bundel (.abk file)

The backups are created as a single .abk file ( Alfresco Backup File ). The backup files follow a
naming convention that uses the current timestamp to differentiate backup file.

    - "Backup-YYYYmmddhhmm.abk". 
    -  YYYY - current year, mm current month, dd current day, hh current hour, mm current minute.
    
The backup file it's built using the Linux command 'tar'. This command allow us to generate a package, that once 
uncompressed will place the files on the correct locations with little effort.

"Guidelines" 

According to Alfresco best practices hot backups should be performed in the following order:

1.  Backup the Lucene indexes.
2.  Backup the database Alfresco is configured to use, using your database vendor's backup.
3.  As soon as the database backup completes, backup specific subdirectories in the Alfresco dir.root
4.  Finally, store both the database and Alfresco dir.root backups together as a single unit. For example, 
    store the backups in the same directory or in a single compressed file.
    
Lucene then SQL: Lucene indexes have to be backed up first and before SQL because if new rows are added in 
SQL aTer the lucene backup is done, a lucene reindex (AUTO) can regenerate the missing Lucene indexes from 
the SQL transacCon data.

SQL then Files: SQL have to be done before files because if you have a SQL node pointing to a missing file that 
node will be orphan. On the contrary, if you have a file without SQL node data, this just means that the user 
has added the file too late to be included in a backup.
    
-----------------
2 - COLD BACKUP :
----------------- 

    * Script Name : coldBackup.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : N/A
    * Bean Type   : N/A
    * Jmx Server  : N/A   
    * Jmx Domain  : N/A   
    
Description: This script automates a full Alfresco Backup according to the recommended best practices. Its exaclty the same procedure 
as the Hot backup with the only difference that it stops alfresco during the backup execution.
    
----------------------
3 - RESTORE ALFRESCO :
---------------------- 

    * Script Name : restoreAlfresco.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : N/A
    * Bean Type   : N/A
    * Jmx Server  : N/A   
    * Jmx Domain  : N/A  

Description:  Restoring its all about reverting the Backup Process, so the restore action compromises the following;

    - Extract bundled files using the tar command
    - Shutdown Alfresco
    - Restore database backup using the appropriate database tool
    - Restore filesystem backup using the tar command
    - Start Alfresco
    - Monitor the alfresco.log file for any errors/ warnings.
    
-----------------------------------
4 - SET ALFRESCO TO READONLY MODE :
----------------------------------- 

    * Script Name : readonly.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : Alfresco:Type=Configuration,Category=sysAdmin,id1=default
    * Bean Type   : Configuration
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco    

Description: Sets alfresco to ReadOnly mode. 

* Action Jmx Code * 
 
domain Alfresco<br/>
bean Alfresco:Type=Configuration,Category=sysAdmin,id1=default<br/>
set server.allowWrite false<br/>
quit

-----------------------------------
5 - SET ALFRESCO TO WRITE MODE :
----------------------------------- 

    * Script Name : writeMode.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : Alfresco:Type=Configuration,Category=sysAdmin,id1=default
    * Bean Type   : Configuration
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco  

Description: Sets alfresco to Write mode. 

* Action Jmx Code *
  
domain Alfresco<br/>
bean Alfresco:Type=Configuration,Category=sysAdmin,id1=default<br/>
set server.allowWrite true<br/>
quit

-----------------------------------
6 - TROUBLESHOOT LUCENE INDEXING 
----------------------------------- 

    * Script Name : troubleshootIndexing.sh
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : log4j:logger=org.alfresco.repo.search.impl.lucene.fts.FullTextSearchIndexerImpl
    * Bean Id     : log4j:logger=org.alfresco.repo.search.Indexer
    * Bean Id     : log4j:logger=org.alfresco.repo.search.impl.lucene.index
    * Bean Type   : Configuration
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco 

Description: Sets the FullTextSearch Indexer Log levels to Debug allowing for quick troubleshoot by tailing
tailing the alfresco log file and getting detailed logs for a controlled period of time.

* Action Jmx Code *
    
domain log4j<br/>
bean log4j:logger=org.alfresco.repo.search.Indexer<br/>
set priority DEBUG<br/>
bean log4j:logger=org.alfresco.repo.search.impl.lucene.fts.FullTextSearchIndexerImpl<br/>
set priority DEBUG<br/>
bean log4j:logger=org.alfresco.repo.search.impl.lucene.index<br/>
set priority DEBUG<br/>
quit

-------------------------------------
7 - STOP TROUBLESHOOT LUCENE INDEXING 
------------------------------------- 

    * Script Name : troubleshootIndexing.sh
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : log4j:logger=org.alfresco.repo.search.impl.lucene.fts.FullTextSearchIndexerImpl
    * Bean Id     : log4j:logger=org.alfresco.repo.search.Indexer
    * Bean Id     : log4j:logger=org.alfresco.repo.search.impl.lucene.index
    * Bean Type   : Configuration
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco 

Description: Stops the troubleshoot on Lucene Indexing by setting the FullTextSearch Indexer Log levels back to their original values. 

* Action Jmx Code *
    
domain log4j<br/>
bean log4j:logger=org.alfresco.repo.search.Indexer<br/>
set priority ERROR<br/>
bean log4j:logger=org.alfresco.repo.search.impl.lucene.fts.FullTextSearchIndexerImpl<br/>
set priority ERROR<br/>
bean log4j:logger=org.alfresco.repo.search.impl.lucene.index<br/>
set priority ERROR<br/>
quit<br/>

