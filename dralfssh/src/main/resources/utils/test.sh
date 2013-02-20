#!/bin/bash
# source the properties:  
. dralf.properties 
cmdLineJMXJar=./jmxterm-1.0-alpha-4-uber.jar
user=controlRole
password=change_asap
jmxHost=localhost
port=50500

#No User and password so pass '-'
echo "Setting Alfresco to ReadOnly...."

cat >./alfrescoScript.jmx<<EOF
domain Alfresco
bean Alfresco:Name=RepoServerMgmt
info
get UserCountNonExpired
run listUserNamesNonExpired
bean Alfresco:Type=Configuration,Category=sysAdmin,id1=default
set server.allowWrite true
# Let’s log out the admin user.  (Look back at the list from the info command.) 
# You can either invalidate all of the authenticated users tickets or we can invalidate named user.
# Since you just want to remove one user let’s invalidate the admin users session.  
# (The System user is a special account, so you will ignore it.)
#run invalidateUser admin

quit
EOF
## Execute Command and get the stack Traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user} -i ./alfrescoScript.jmx > ./alfrescoOut.txt


