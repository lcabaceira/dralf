#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "Rebuilding Solr Indexes...."
echo "Stopping Solr ..."
${solrAppServerBin}/shutdown.sh
sleep 10
echo "Deleting Indexes  ..."
rm -rf ${solrRoot}/solrdata/workspace/SpacesStore/Index
echo "Deleting models cached on the SOLR side for workspace-SpacesStore core  ..."
rm -rf ${solrRoot}/workspace-SpacesStore/alfrescoModels
echo "Starting Solr ..."
${solrAppServerBin}/startup.sh
echo "Press any key to return to Dr. Alf..."

