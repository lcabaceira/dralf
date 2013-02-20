#!/bin/bash
# source the properties:  
. ./dralf.properties 

function endIt {
         echo " Exiting solr Troubleshooter .... "
         break
         exit 0
}

function trackerCheck {  
echo "Adding Search Tracker Debug Options"
if grep "log4j.logger.org.alfresco.solr.tracker.CoreTracker" ${solrLog4j} ;then
    # if found delete the line and write the debug statement 
    sed "/log4j.logger.org.alfresco.solr.tracker.CoreTracker*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
    echo "log4j.logger.org.alfresco.solr.tracker.CoreTracker=DEBUG" >> ${solrLog4j}
else
    # not found , lets add it 
    echo "log4j.logger.org.alfresco.solr.tracker.CoreTracker=DEBUG" >> ${solrLog4j}
fi
if grep "log4j.logger.org.alfresco.solr.tracker.CoreTrackerJob" ${solrLog4j} ;then
    # if found delete the line and write the debug statement 
    sed "/log4j.logger.org.alfresco.solr.tracker.CoreTrackerJob*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
    echo "log4j.logger.org.alfresco.solr.tracker.CoreTrackerJob=DEBUG" >> ${solrLog4j}
else
    # not found , lets add it 
    echo "log4j.logger.org.alfresco.solr.tracker.CoreTrackerJob=DEBUG" >> ${solrLog4j}
fi
echo "Stopping Solr...."
${solrAppServerBin}/shutdown.sh
sleep 20
echo "Starting Solr...."
${solrAppServerBin}/startup.sh
echo "Press any key to return...."
}


function parserCheck {  
if grep "log4j.logger.org.alfresco.solr.query.AbstractQParser" ${solrLog4j} ;then
    # if found delete the line and write the debug statement 
    sed "/log4j.logger.org.alfresco.solr.query.AbstractQParser*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
    echo "log4j.logger.org.alfresco.solr.query.AbstractQParser=DEBUG" >> ${solrLog4j}
else
    # not found , lets add it 
    echo "log4j.logger.org.alfresco.solr.query.AbstractQParser=DEBUG" >> ${solrLog4j}
fi
if grep "log4j.logger.org.alfresco.solr.query.AlfrescoFTSQParserPlugin" ${solrLog4j} ;then
    # if found delete the line and write the debug statement 
    sed "/log4j.logger.org.alfresco.solr.query.AlfrescoFTSQParserPlugin*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
    echo "log4j.logger.org.alfresco.solr.query.AlfrescoFTSQParserPlugin=DEBUG" >> ${solrLog4j}
else
    # not found , lets add it 
    echo "log4j.logger.org.alfresco.solr.query.AlfrescoFTSQParserPlugin=DEBUG" >> ${solrLog4j}
fi
if grep "log4j.logger.org.alfresco.solr.query.AlfrescoLuceneQParserPlugin" ${solrLog4j} ;then
    # if found delete the line and write the debug statement 
    sed "/log4j.logger.org.alfresco.solr.query.AlfrescoLuceneQParserPlugin*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
    echo "log4j.logger.org.alfresco.solr.query.AlfrescoLuceneQParserPlugin=DEBUG" >> ${solrLog4j}
else
    # not found , lets add it 
    echo "log4j.logger.org.alfresco.solr.query.AlfrescoLuceneQParserPlugin=DEBUG" >> ${solrLog4j}
fi
if grep "log4j.logger.org.alfresco.solr.query.CmisQParserPlugin" ${solrLog4j} ;then
    # if found delete the line and write the debug statement 
    sed "/log4j.logger.org.alfresco.solr.query.CmisQParserPlugin*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
    echo "log4j.logger.org.alfresco.solr.query.CmisQParserPlugin=DEBUG" >> ${solrLog4j}
else
    # not found , lets add it 
    echo "log4j.logger.org.alfresco.solr.query.CmisQParserPlugin=DEBUG" >> ${solrLog4j}
fi
echo "Stopping Solr...."
${solrAppServerBin}/shutdown.sh
sleep 20
echo "Starting Solr...."
${solrAppServerBin}/startup.sh
echo "Press any key to return...."
}


function timingsCheck {    
if grep "log4j.logger.org.apache.solr.core.SolrCore" ${solrLog4j} ;then
    # if found delete the line and write the debug statement 
    sed "/log4j.logger.org.apache.solr.core.SolrCore*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
    echo "log4j.logger.org.apache.solr.core.SolrCore=DEBUG" >> ${solrLog4j}
else
    # not found , lets add it 
    echo "log4j.logger.org.apache.solr.core.SolrCore=DEBUG" >> ${solrLog4j}
fi
echo "Stopping Solr...."
${solrAppServerBin}/shutdown.sh
sleep 20
echo "Starting Solr...."
${solrAppServerBin}/startup.sh
echo "Press any key to return...."
}




function revertAll {  
echo "Removing all Solr Search Debug Options"
if grep "log4j.logger.org.apache.solr.core.SolrCore" ${solrLog4j} ;then
    # if found delete the line and write the debug statement 
    sed "/log4j.logger.org.apache.solr.core.SolrCore*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
fi

if grep "log4j.logger.org.alfresco.solr.query.AbstractQParser" ${solrLog4j} ;then
    # if found delete the line to remove the debug statement 
    sed "/log4j.logger.org.alfresco.solr.query.AbstractQParser*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
fi
if grep "log4j.logger.org.alfresco.solr.query.AlfrescoFTSQParserPlugin" ${solrLog4j} ;then
    # if found delete the line to remove the debug statement 
    sed "/log4j.logger.org.alfresco.solr.query.AlfrescoFTSQParserPlugin*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
fi
if grep "log4j.logger.org.alfresco.solr.query.AlfrescoLuceneQParserPlugin" ${solrLog4j} ;then
    # if found delete the line to remove the debug statement 
    sed "/log4j.logger.org.alfresco.solr.query.AlfrescoLuceneQParserPlugin*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
fi
if grep "log4j.logger.org.alfresco.solr.query.CmisQParserPlugin" ${solrLog4j} ;then
    # if found delete the line to remove the debug statement 
    sed "/log4j.logger.org.alfresco.solr.query.CmisQParserPlugin*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
fi
if grep "log4j.logger.org.alfresco.solr.tracker.CoreTracker" ${solrLog4j} ;then
    # if found delete the line and write the debug statement 
    sed "/log4j.logger.org.alfresco.solr.tracker.CoreTracker*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
fi
if grep "log4j.logger.org.alfresco.solr.tracker.CoreTrackerJob" ${solrLog4j} ;then
    # if found delete the line and write the debug statement 
    sed "/log4j.logger.org.alfresco.solr.tracker.CoreTrackerJob*/d" ${solrLog4j} >tmp.properties
    mv tmp.properties ${solrLog4j}
fi
echo "Stopping Solr...."
${solrAppServerBin}/shutdown.sh
sleep 20
echo "Starting Solr...."
${solrAppServerBin}/startup.sh
echo "Press any key to return...."
}


function coreStatusSummary {  
echo "Generating SOLR status summary for cores ... "
cat >./solrScript.jmx<<EOF
domain solr/alfresco
domain
bean type=documentCache,id=org.apache.solr.search.LRUCache
bean
get description
get sourceid
get lookups
get hits
get hitratio
get inserts
get evictions
get size
get warmupTime
get cumutative_lookups
get cumutative_hits
get cumutative_hitratio
get cumutative_inserts
get cumutative_evictions
bean type=queryResultCache,id=org.apache.solr.search.LRUCache
bean
get description
get sourceid
get lookups
get hits
get hitratio
get inserts
get evictions
get size
get warmupTime
get cumutative_lookups
get cumutative_hits
get cumutative_hitratio
get cumutative_inserts
get cumutative_evictions
bean type=filterCache,id=org.apache.solr.search.FastLRUCache
bean
get description
get sourceid
get lookups
get hits
get hitratio
get inserts
get evictions
get size
get warmupTime
get cumutative_lookups
get cumutative_hits
get cumutative_hitratio
get cumutative_inserts
get cumutative_evictions
bean type=fieldCache,id=org.apache.solr.search.SolrFieldCacheMBean
bean
get entries_count
get insanity_count
domain solr/archive
domain
bean type=documentCache,id=org.apache.solr.search.LRUCache
bean
get description
get sourceid
get lookups
get hits
get hitratio
get inserts
get evictions
get size
get warmupTime
get cumutative_lookups
get cumutative_hits
get cumutative_hitratio
get cumutative_inserts
get cumutative_evictions
bean type=queryResultCache,id=org.apache.solr.search.LRUCache
bean
get description
get sourceid
get lookups
get hits
get hitratio
get inserts
get evictions
get size
get warmupTime
get cumutative_lookups
get cumutative_hits
get cumutative_hitratio
get cumutative_inserts
get cumutative_evictions
bean type=filterCache,id=org.apache.solr.search.FastLRUCache
bean
get description
get sourceid
get lookups
get hits
get hitratio
get inserts
get evictions
get size
get warmupTime
get cumutative_lookups
get cumutative_hits
get cumutative_hitratio
get cumutative_inserts
get cumutative_evictions
bean type=fieldCache,id=org.apache.solr.search.SolrFieldCacheMBean
bean
get entries_count
get insanity_count
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l localhost:${solrJmxPort} -i ./solrScript.jmx > ${drAlfDir}/reports/solrCoreStatusSummary.txt
rm -rf ./solrScript.jmx
#curl https://${solrHost}:${solrPort}/solr/admin/cores?action=REPORT&wt=xml > ${drAlfDir}/logs/solrCoreStatusSummary.xml
}

function indexStatusReport {  
echo "Generating SOLR index status report... "
cat >./solrScript.jmx<<EOF
domain solr/alfresco
domain
bean type=searcher,id=org.apache.solr.search.SolrIndexSearcher
bean
get numDocs
get caching
get readerDir
get numDocs
get openedAt
get warmupTime
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l localhost:${solrJmxPort} -i ./solrScript.jmx > ${drAlfDir}/reports/solrIndexesReport.txt
rm -rf ./solrScript.jmx
}


clear
echo "###################################################################################################################";
echo "IMPORTANT : Some options of this troubleshooter will only work if remote jmx connections are allowed in your solr";
echo "The best way is include the following JAVA_OPTS on the solr startup.sh script";
echo "-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.authenticate=false";
echo "-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.port=<your_port>";
echo "###################################################################################################################";
echo"";
select yn in "Generate Index Status Report" "Generate Status Summary for Alfresco Solr Cores" "Troubleshoot Solr Tracker" "Troubleshoot Solr Parsers" "Troubleshoot Solr Timings" "Stop Troubleshooting" ; do
    case $yn in
        "Generate Index Status Report" ) indexStatusReport;break;;
        "Generate Status Summary for Alfresco Solr Cores" ) coreStatusSummary;break;;
        "Troubleshoot Solr Tracker" ) trackerCheck;break;;
        "Troubleshoot Solr Parsers" ) parserCheck;break;;
        "Troubleshoot Solr Timings" ) timingsCheck;break;;
        "Stop Troubleshooting"  ) revertAll; break;;
        * ) echo "InvalidOption";endIt;;
    esac
done


# wt=xslt&tr=example.xsl in solr querys for nice xsl transformation 
#SOLR status summary for cores: http://<solrhost>:<solrport>/solr/admin/cores?action=SUMMARY&wt=xml
#SOLR Overall status report http://<solrhost>:<solrport>/solr/admin/cores?action=REPORT&wt=xml
#SOLR index status (the normal SOLR stuff) http://<solrhost>:<solrport>/solr/admin/cores?action=STATUS&wt=xml

# If you want to delete the complete index for live content you can do this:
# $ curl https://<solrhost>:<solrport>/solr/alfresco/update?commit=true -d '<delete><query>*:*</query></delete>'