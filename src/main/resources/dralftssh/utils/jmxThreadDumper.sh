#!/bin/bash
# source the properties:
. dumper.properties 



function die() { echo $1 ; exit 1 ; }
function checkexe() { [ -x `which $1` ] || die "cant find executable program $1"; }

PROGS="java grep cat sed tr xsltproc xmllint"
for P in $PROGS ; do checkexe $P ; done
 

## jmxterm commands to get thread stack dump
cat >./myscript.jmx<<EOF
domain java.lang
bean java.lang:type=Threading
run dumpAllThreads 1 1
quit
EOF

## get the stack traces
java -jar ${cmdLineJMXJar} -l service:jmx:rmi:///jndi/rmi://${jmxHost}:${port}/alfresco/jmxrmi -p ${password} -u ${user}  -i ./myscript.jmx > ./jmxThreadDumperOut.txt

grep "threadId" ./jmxThreadDumperOut.txt || die "stack trace get seemed to fail ?!"

## turn them into xml
cat ./jmxThreadDumperOut.txt  | sed -e "s|\[ |<array>|g" -e "s| \]|</array>|g" -e "s|{|<obj>|g" 
sed -e "s|}|</obj>|g" 
sed -e "s|\([^ <>]*\) = \([^ <>]*\);|<\1>\2</\1>|g"
sed -e "s|\([^ ]*\) = \([^;]*\) *;|<\1>\2</\1>|g" | tr '\r\n\t' ' ' | tr -s ' ' | 
sed -e "s|\([^ =]*\) = \([^;=]*\);|<\1>\2</\1>|g" 
sed -e "s|\([^ ]*\) = \([^;]*\);|<\1>\2</\1>|g" 
sed -e "s| *, *||g" > ./allthreads.xml


## xsl to convert xml-ified stack traces to simpler format
cat >./jmxterm_threads.xslt<<EOF
<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
<jmx>
<xsl:for-each select="/array/obj">
<xsl:sort select="threadId" data-type="number"/>
<xsl:apply-templates select="." mode="thread"/>
</xsl:for-each>
</jmx>
</xsl:template>
<xsl:template match="obj" mode="thread">
<thread id="{threadId/text()}">
<xsl:copy-of select="threadName"/>
<xsl:copy-of select="threadState"/>
<xsl:copy-of select="suspended"/>
<xsl:copy-of select="inNative"/>
<xsl:copy-of select="waitedCount"/>
<xsl:copy-of select="blockedCount"/>
<xsl:apply-templates select="stackTrace"/>
</thread>
</xsl:template>
<xsl:template match="stackTrace">
<stackTrace>
<xsl:for-each select="./array/obj">
<stackfn class="{className}" method="{methodName}" file="{fileName}"
line="{lineNumber}"/>
</xsl:for-each>
</stackTrace>
</xsl:template>
</xsl:stylesheet>
EOF

## simplify xml
xsltproc ./jmxterm_threads.xslt ./allthreads.xml | xmllint --format - > ./allthreads_simple.xml

cat ./allthreads_simple.xml > mylist.xml