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

-------------------------------------
8 - JMX SYSTEM REPORT
------------------------------------- 


    * Script Name : jmxSystemReport.sh
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : bean Alfresco:Name=RepositoryDescriptor,Type=Server
    * Bean Id     : Alfresco:Name=Runtime
    * Bean Id     : Alfresco:Name=Authority
    * Bean Id     : Alfresco:Name=ConnectionPool
    * Bean Id     : Alfresco:Name=ContentTransformer,Type=ImageMagick
    * Bean Id     : Alfresco:Name=ContentTransformer,Type=pdf2swf
    * Bean Id     : Alfresco:Name=LuceneIndexes,Index=workspace/SpacesStore 
    * Bean Id     : Alfresco:Name=LuceneIndexes,Index=archive/SpacesStore 
    * Bean Id     : Alfresco:Name=LuceneIndexes,Index=user/alfrescoUserStore 
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco 

Description: Generates System Report from the Monitoring Beans targeting specific pre-defined Beans. This report includes the following :

    - Alfresco Edition ( Community | Enterprise )
    - Alfresco Total Memory
    - Alfresco Max Memory
    - Alfresco Free Memory
    - Number of syncronized Groups
    - Number of syncronized Users
    - Active Connections on the Alfresco Connection Pool
    - Idle Connections on the Alfresco Connection Pool
    - Initial Size of the the Alfresco Connection Pool
    - Other relevant Connection Pool metrics
    - Information on the Content Transformers being used
    - Information on the Indexes ( # Indexed Documents, etc ) 

* Action Jmx Code *
    
domain Alfresco <br/>
bean Alfresco:Name=RepositoryDescriptor,Type=Server<br/>
bean<br/>
get Version<br/>
get Edition<br/>
bean Alfresco:Name=Runtime<br/>
bean<br/>
get TotalMemory<br/>
get MaxMemory<br/>
get FreeMemory<br/>
bean Alfresco:Name=Authority<br/>
bean<br/>
get NumberOfGroups<br/>
get NumberOfUsers<br/>
bean Alfresco:Name=ConnectionPool<br/>
bean<br/>
get NumActive<br/>
get NumIdle<br/>
get InitialSize<br/>
get MaxActive<br/>
get MaxIdle<br/>
get MaxWait<br/>
bean Alfresco:Name=ContentTransformer,Type=ImageMagick<br/>
bean<br/>
get Available<br/>
get VersionString<br/>
bean Alfresco:Name=ContentTransformer,Type=pdf2swf<br/>
bean<br/>
get Available<br/>
get VersionString<br/>
bean Alfresco:Name=LuceneIndexes,Index=workspace/SpacesStore<br/>
bean<br/>
get ActualSize<br/>
get EntryStatus<br/>
get EventCounts<br/>
get NumberOfDocuments<br/>
get NumberOfFields<br/>
get NumberOfIndexedFields<br/>
get UsedSize<br/>
bean Alfresco:Name=LuceneIndexes,Index=archive/SpacesStore<br/>
bean<br/>
get ActualSize<br/>
get EntryStatus<br/>
get EventCounts<br/>
get NumberOfDocuments<br/>
get NumberOfFields<br/>
get NumberOfIndexedFields<br/>
get UsedSize<br/>
bean Alfresco:Name=LuceneIndexes,Index=user/alfrescoUserStore<br/>
bean<br/>
get ActualSize<br/>
get EntryStatus<br/>
get EventCounts<br/>
get NumberOfDocuments<br/>
get NumberOfFields<br/>
get NumberOfIndexedFields<br/>
get UsedSize<br/>
quit<br/>

-------------------------------------
9 - DATABASE CHECK 
------------------------------------- 

    * Script Name : schemaValidator.sh
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : Alfresco:Name=DatabaseInformation,Tool=SchemaValidator 
    * Bean Id     : Alfresco:Name=DatabaseInformation,Tool=SchemaExport
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco 

Description: Validates Database and dumps validated schema as XML

* Action Jmx Code *
    
domain Alfresco<br/>
bean Alfresco:Name=DatabaseInformation,Tool=SchemaValidator<br/> 
run validateSchema<br/>
bean Alfresco:Name=DatabaseInformation,Tool=SchemaExport<br/>
run dumpSchemaToXML<br/>
quit<br/>

-------------------------------------
10 - EXECUTE CONTENT STORE CLEANER
------------------------------------- 

    * Script Name : contentCleanUpJobTrigger.sh
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=contentStoreCleanerTrigger
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco 

Description: Triggers the execution of the Content Store Cleaner Scheduled Job

"Guidelines" 

Cleaning up Orphaned Content (Purge)
Once all references to a content binary have been removed from the metadata, the content is said to be orphaned. Orphaned content can 
be deleted or purged from the content store while the system is running. Identifying and either sequestering or deleting the orphaned 
content is the job of the contentStoreCleaner.

In the default configuration, the contentStoreCleanerTrigger fires the contentStoreCleaner bean. This bean 

  <bean id="contentStoreCleaner" class="org.alfresco.repo.content.cleanup.ContentStoreCleaner" >
     ...
     <property name="protectDays" >
        <value>14</value>
     </property>
     <property name="stores" >
        <list>
           <ref bean="fileContentStore" />
        </list>
     </property>
     <property name="listeners" >
        <list>
           <ref bean="deletedContentBackupListener" />
        </list>
     </property>
  </bean>

This DrAlf action can be extended to cope with the user business needs by setting the following properties  :

- protectDays
        
Use this property to dictate the minimum time that content binaries should be kept in the contentStore. In the above example,if a file is created
and immediately deleted, it will not be cleaned from the contentStore for at least 14 days. The value should be adjusted to account for backup 
strategies, average content size and available disk space. Setting this value to zero will result in a system warning as it breaks the transaction
model and it is possible to lose content if the orphaned content cleaner runs whilst content is being loaded into the system. If the system backup
strategy is just to make regular copies, then this value should also be greater than the number of days between successive backup runs.

- store

This is a list of ContentStore beans to scour for orphaned content.

- listeners

When orphaned content is located, these listeners are notified. In this example, the deletedContentBackupListener copies the orphaned content to a separate
deletedContentStore.Note that this configuration will not actually remove the files from the file system but rather moves them to the designated deletedContentStore,
usually contentstore.deleted. The files can be removed from the deletedContentStore via script or cron job once an appropriate backup has been performed.

* Action Jmx Code *
    
domain Alfresco<br/>
bean Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=contentStoreCleanerTrigger<br/>
run executeNow<br/>
quit<br/>

-------------------------------------
11 - BOUNCE ALFRESCO
------------------------------------- 

    * Script Name : bounceAlfresco.sh
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : N/A
    * Jmx Server  : N/A   
    * Jmx Domain  : N/A

Description: Restarts your alfresco application server

* Action Jmx Code *
    
N/A

-----------------------------
12 - INVALIDATE USER SESSIONS
-----------------------------

    * Script Name : bounceAlfresco.sh
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : Alfresco:Name=RepoServerMgmt
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco 

Description: Invalidates all current user sessions.

* Action Jmx Code *

domain Alfresco<br/>
bean Alfresco:Name=RepoServerMgmt<br/>
run invalidateTicketsAll<br/>
quit<br/>

-----------------------------
14 - MANAGE SCHEDULER JOBS
-----------------------------

    * Script Name : scheduleJobsManager.sh
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=contentStoreCleanerTrigger
    * Bean Id     : Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=nodeServiceCleanupTrigger
    * Bean Id     : Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=search.alfrescoCoreBackupTrigger
    * Bean Id     : Alfresco:Name=Schedule,Group=DEFAULT,Type=MonitoredCronTrigger,Trigger=tempFileCleanerTrigger
    * Bean Id     : Alfresco:Type=Configuration,Category=Synchronization,id1=default
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco 


Description: Allows Immediate control over the execution of the Alfresco common schedule Jobs. It allows the user to execute 
the content store cleaner, the node service cleaner, the index backup trigger, the temporary files cleaner and to perform the
ldap user/group synchronization.

- About the Node Service Cleaner
    
The Node service cleaner is a scheduled job that runs to tidy up the database. This clean-up job executes every day at 21:00 (bean 'nodeServiceCleanupTrigger')
leading to bean 'nodeServiceCleanupJobDetail'), and performs the work found inside 'DeletedNodeCleanupWorker'.
After 30 days from when the 'node_deleted' field was set to '1', this process considers it safe to truly delete the node with a call to the DAO service purge.
Note: it doesn't use the audit_modifed date, since this wasn't changed when the row was marked for deletion. Instead, it uses the commit_time_ms transaction time 
from the alf_transaction table. This job also removes old transactions from the alf_transaction table. Transactions are considerd old using the same property as node
removal work: '30 days'; Defined using the property 'index.tracking.minRecordPurgeAgeDays').

Performs cleanup operations on DM node data, including old deleted nodes and old transactions. In a clustered environment, this job could be enabled on a headless 
(non-public) node only, which will improve efficiently.

Note : You can debug the Node service cleaner job by enabling log4j.logger.org.alfresco.repo.node.cleanup.NodeCleanupJob=DEBUG

- About the Content Store Cleaner

Launches the contentStoreCleaner bean, which identifies, and deletes or purges orphaned content from the content store while the system is running. Content is said 
to be orphaned when all references to a content binary have been removed from the metadata. By default, this job is triggered at 4:00 am each day. In a clustered 
environment, this job could be enabled on a headless (non-public) node only, which will improve efficiently.

- About the Temporary Files Cleaner

Cleans up all Alfresco temporary files that are older than the given number of hours. Subdirectories are also emptied and all directories below the primary temporary 
subdirectory are removed. The job data must include the protectHours property, which is the number of hours to protect a temporary file from deletion since its last 
modification.

- About the Index Backup Trigger

Creates a safe backup of the Lucene/Solr directories.

- About the Ldap User Syncronization

Triggers a Users/Groups Ldap syncronization

