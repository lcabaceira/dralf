--------------
Dr Alf - 0.1
------------- 
    
    Project location : https://github.com/lcabaceira/dralf

-----------------
Target Audience :
-----------------
    Alfresco Administrators 
    Alfresco developers and students
    
-------------
Introduction :
------------- 
Dr. Alf is mostly a Jmx encapsulator that communicates with Alfresco via JMX. It targets and automate specific
JMX actions giving the user a most rewarding experience on administration and troubleshooting tasks within Alfresco.

It also automates processes such as hot backups, cold backups , alfresco restores and other handy operations. 
It uses jmxterm as a command line jmx client , you can find documentation on jmxterm at http://wiki.cyclopsgroup.org/jmxterm/features

----------------------
1 - Installing Dr Alf. 
----------------------

-----------------------------------------
2 - Configure for the target environment
-----------------------------------------

Dr. Alf works directly with your alfresco, and has the ability to read the properties configured either in 
the alfresco-global.properties on in the repository.properties file of Alfresco. There are a few
initial properties that have to be set to have a fully functional version of Dr. Alf.

-----------------------
3 - Accessing the tool
-----------------------

    * Go to the installation directory of Dr Alf.
    * Change to dralfssh 
    * run ./dralf.sh menu
    
------------------------------------    
Future view
------------------------------------
The idea is to integrate Dr. Alf within Share, along with the other administrator tasks.
It will be distributed as software package + an AMP file for the share UI adaptations.
