------------------------------
Dr Alf - 0.1 - MONITORING SOLR 
------------------------------
    
    Project location : https://github.com/lcabaceira/dralf

-----------------
Target Audience :
-----------------

    Search Administrators 
    Alfresco Administrators
    
---------------------
0 - About this Document :
--------------------- 

Dr. Alf includes de ability to monitor solr by implementing a JManage based monitoring system. Jmanage is a JMX driven monitoring system, 
since  Solr expose its Mbeans via JMX, we can use Jmanage to monitor it.Jmanage is opensource and can be configured to perform monitoring 
and notification on determined values.

This document explains how is the monitoring system is implemented, the statistics that are collected , and the overall view on how to 
monitor Solr using Jmanage. We also analise what performance metrics we want to gather and how we can easily achieve this.

Reference Urls : 

    * http://www.jmanage.org/
    * http://jmanage.blogspot.pt/
    
--------------------------------------
1 - Integrating JManage and Solr  :
---------------------------------------

Very easy to setup and provides a nice set of features that we can target specifically to Solr or to both Solr and Alfresco.
Jmanage includes a embedded jetty server running on port 9090 ( can be changed ).

<u>First Steps </u>

    * DrAlf includes a pre-configured version of JManage ( jmanage-2.0-RC1 ) targetting the solr beans.
    * Edit the Solr Monitoring application to reflect the name and the jmx port of your solr host.
    * Enjoy and extend the monitoring to your own needs
    * You can also use JManage to monitor Alfresco, by doing as follows :
            - login in to jManage
            - click on Add Application
            - click on JSR160 Application
            - name the app as Alfresco Monitoring
            - add the alfresco jmx URL, username and password ( defaults are controlRole | change_asap )
            - click save ( simple isn't it ? :) 

We've implemented our specific solr monitorization targeting specific beans that contain valuable 
information on the SOLR performance. We've also setup a series of bean that are candidates to be target notification triggers.

<u>What's Monitored in Solr</u>

    * General Heap Usage
    * Thread Count
    * Memory Usage
    * Solr Cache 
    * Solr Session

This can be easily extended to your own needs by using and extending jmanage.

<u>What Mbeans are included in the Solr monitoring application</u>

    * Alfresco Authority Cache 	      solr/alfresco:id=org.apache.solr.search.FastLRUCache,type=alfrescoAuthorityCache
    * Alfresco Cache 	              solr/alfresco:id=org.apache.solr.search.FastLRUCache,type=alfrescoCache
    * Alfresco Core Query Component   solr/alfresco:id=org.apache.solr.handler.component.QueryComponent,type=org.apache.solr.handler.component.QueryComponent
    * Alfresco Full Text Search 	  solr/alfresco:id=org.apache.solr.handler.component.SearchHandler,type=/afts
    * Alfresco Path Cache 	          solr/alfresco:id=org.apache.solr.search.FastLRUCache,type=alfrescoPathCache
    * Alfresco Query Result Cache 	  solr/alfresco:id=org.apache.solr.search.LRUCache,type=queryResultCache
    * Alfresco Simple Search Handler  solr/alfresco:id=org.apache.solr.handler.component.SearchHandler,type=/alfresco
    * Query Handler 	              solr/alfresco:id=org.apache.solr.handler.component.SearchHandler,type=tvrh
    * Solr Document Cache 	          solr/alfresco:id=org.apache.solr.search.LRUCache,type=documentCache
    * Solr Field Value Cache 	      solr/alfresco:id=org.apache.solr.search.FastLRUCache,type=fieldValueCache
    * Solr Filter Cache 	          solr/alfresco:id=org.apache.solr.search.FastLRUCache,type=filterCach

--------------------------------------
2 - Running the Monitorization       :
--------------------------------------
You can start and stop the monitorization directly from the command line following the instructions below :

    * cd ${drAlfDir}/tools/jmanage/bin
    * ./startup.sh &
    * enter admin as the password

After starting just open a browser pointing at http://<servername>:9090 and login as admin | admin ( can be changed ).

------------------------------------------------------------------------------------------------------
3 - How does DrAlf integrate Jmanage with Solr 
------------------------------------------------------------------------------------------------------
We've created the Solr monitoring by adding Solr as a JSR160 application trough the Jmanage interface. Since Jmanage persists the configurations
we're simply including a pre-configured version of Jmanage targeting Solr. 

--------------------------------------
4 - Integrating JavaMelody and Solr  :
---------------------------------------

We've chosen to include a reference to JavaMelody to perform global Solr monitoring because of the extreme simplicity in the Integration. 
Basically it only requires you to to copy 3 jar files to the WEB-INF/lib of your solr web-app and to add 10 lines in a xml file.

    * Copy the files javamelody.jar and jrobin-x.jar and itext-2.1.7.jar located at the tools directory of Dralf, to the WEB-INF/lib 
    directory of the solr war file.
    
    * Acess the monitoring System https://<solrhost>:<solrport>/solr/monitoring ( simple isn't it ? :) 
    
This is handy because you will have a global view on your solr host and you can inspect all the beans to produce your jmx extensions.

More information on Java Melody : https://code.google.com/p/javamelody/
 
----------------
5 - Notes :
----------------

You can implement further monitorization scenarios and graphs like the examples below :

    * Solr Query cache
    
        - hits
        - hits pct.
        - evictions
        - size
        - max size
        - lookups
        - autowarm count
        
     * Document cache
     
        - hits
        - hits pct.
        - evictions
        - size
        - max size
        - lookups
        - autowarm count
        
     * Filter cache
     
        - hits
        - hits pct.
        - evictions
        - size
        - max size
        - lookups
        - autowarm count
    
    * Search request rate and latency
    * Index size on disk and number of index files
    * Number of indexed documents, deleted documents, and index segments
    * CPU usage
    * RAM used/free
    * System load
    * Disk reads/writes
    * Disk used/free
    * Network interface traffic
    * Swap IO
    * JVM garbage collection times and counts
    




