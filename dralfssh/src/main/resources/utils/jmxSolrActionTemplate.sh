#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "< What does your extension does ? >...."
cat >./solrScript.jmx<<EOF
domain <enter domain name for your target bean>
bean <enter full bean idenfification here>
<set>
<get>
<execute>
<info>
....
quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l localhost:${solrJmxPort} -i ./solrScript.jmx > ${drAlfDir}/reports/solrIndexesReport.txt
rm -rf ./solrScript.jmx

