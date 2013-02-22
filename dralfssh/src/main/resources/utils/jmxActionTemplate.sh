#!/bin/bash
# source the properties:  
. ./dralf.properties 
echo "< What does your extension does ? >...."
cat >./alfrescoScript.jmx<<EOF
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
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx 
rm -rf ./alfrescoScript.jmx

