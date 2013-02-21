------------------------------
Dr Alf Technical Details - 0.1
------------------------------

    Project location : https://github.com/lcabaceira/dralf

-----------------
Target Audience :
-----------------

    Alfresco Administrators 
    Alfresco developers and Alfresco Students
    A Tool for Alfresco Support Team 

----------------
1 - HOT BACKUP :
---------------- 

    * Script Name : hotBackup.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : N/A
    * Bean Type   : N/A
    * Jmx Server  : N/A   
    * Jmx Domain  : N/A  

This script automates a full Alfresco Backup according to the recommended best practices.

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
       
-----------------
2 - COLD BACKUP :
----------------- 

    * Script Name : coldBackup.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : N/A
    * Bean Type   : N/A
    * Jmx Server  : N/A   
    * Jmx Domain  : N/A   
    
    This script automates a full Alfresco Backup according to the recommended best practices.

    - Run the Content Store Cleanup Scheduled Job
    - Shutdown Alfresco 
    - Trigger the Search Sub System Indexes Backup Scheduled Job
    - Execute the database Hot Backup procedure
    - Backup the repository filesystem
    - Backup Search Sub System Indexes
    - Build the backup bundel (.abk file)
    - Start Alfresco 

The backups are created as a single .abk file ( Alfresco Backup File ). The backup files follow a
naming convention that uses the current timestamp to differentiate backup file.

    - "Backup-YYYYmmddhhmm.abk". 
    -  YYYY - current year, mm current month, dd current day, hh current hour, mm current minute.
    
The backup file it's built using the Linux command 'tar'. This command allow us to generate a package, that once 
uncompressed will place the files on the correct locations with little effort. 
    
----------------------
3 - RESTORE ALFRESCO :
---------------------- 

    * Script Name : restoreAlfresco.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : N/A
    * Bean Type   : N/A
    * Jmx Server  : N/A   
    * Jmx Domain  : N/A  

-----------------------------------
4 - SET ALFRESCO TO READONLY MODE :
----------------------------------- 

    * Script Name : readonly.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : Alfresco:Type=Configuration,Category=sysAdmin,id1=default
    * Bean Type   : Configuration
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco    

The Jmx Code for this action :
 
domain Alfresco
bean Alfresco:Type=Configuration,Category=sysAdmin,id1=default
set server.allowWrite false
quit
EOF 
 
-----------------------------------
5 - SET ALFRESCO TO WRITE MODE :
----------------------------------- 

    * Script Name : writeMode.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : Alfresco:Type=Configuration,Category=sysAdmin,id1=default
    * Bean Type   : Configuration
    * Jmx Server  : Alfresco application Server   
    * Jmx Domain  : Alfresco  

The Jmx Code for this action :
  
domain Alfresco
bean Alfresco:Type=Configuration,Category=sysAdmin,id1=default
set server.allowWrite true
quit
EOF 
 