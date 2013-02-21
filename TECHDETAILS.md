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

-----------------
2 - COLD BACKUP :
----------------- 

    * Script Name : coldBackup.sh   
    * Location    : <drAlfInstallDir>/utils
    * Bean Id     : N/A
    * Bean Type   : N/A
    * Jmx Server  : N/A   
    * Jmx Domain  : N/A    
    
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
 