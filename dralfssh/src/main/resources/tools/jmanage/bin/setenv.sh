#!/bin/sh
################################################################################
#  Copyright 2004-2005 jManage.org. All rights reserved.
################################################################################

if [ ! -n "$JAVA_HOME" ]; then
	echo "Please set JAVA_HOME environment variable. JAVA_HOME must point to a JDK 1.4 installation directory."
    exit 0
fi

if [ ! -n "$JMANAGE_HOME" ]; then
    JMANAGE_HOME=..
fi

if [ ! -f "$JMANAGE_HOME/config/jmanage.properties" ]; then
    echo "Please set JMANAGE_HOME environment variable pointing to jManage installation directory."
    exit 0
fi

##############################
# Determine is this cygwin env
##############################
case "`uname`" in
    CYGWIN*)	JM_PATH_SEP=";"  ;;
    *)		JM_PATH_SEP=":" ;;
esac

JMANAGE_CLASSPATH=

for i in $JMANAGE_HOME/lib/*.jar
do
    JMANAGE_CLASSPATH="$i$JM_PATH_SEP$JMANAGE_CLASSPATH"
done
if [ ! -n "$CLASSPATH" ]; then
    JMANAGE_CLASSPATH="$JMANAGE_CLASSPATH$CLASSPATH"
fi

#echo classpath=$JMANAGE_CLASSPATH
