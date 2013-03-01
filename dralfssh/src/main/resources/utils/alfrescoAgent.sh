#!/bin/sh

# Disabling SELinux if enabled
if [ -f "/usr/sbin/getenforce" ] && [ `id -u` = 0 ] ; then
    selinux_status=`/usr/sbin/getenforce`
    /usr/sbin/setenforce 0 2> /dev/null
fi

INSTALLDIR=/Users/lcabaceira/Alfresco/Training/ACA/Hands_on_Experience/alfresco1

if [ -r "$INSTALLDIR/scripts/setenv.sh" ]; then
. "$INSTALLDIR/scripts/setenv.sh"
fi

ERROR=0
TOMCAT_SCRIPT=$INSTALLDIR/tomcat/scripts/ctl.sh

help() {
	echo "usage: $0 help"
	echo "       $0 (start|stop|restart|status)"

	if test -x $TOMCAT_SCRIPT; then	
	    echo "       $0 (start|stop|restart|status) tomcat"
	fi
	cat <<EOF

help       - this screen
start      - start the service(s)
stop       - stop  the service(s)
restart    - restart or start the service(s)
status     - show the status of the service(s)

EOF
}


if [ "x$1" = "xhelp" ] || [ "x$1" = "x" ]; then
    help
elif [ "x$1" = "xstart" ]; then
    if [ "x$2" = "xtomcat" ]; then
        if test -x $TOMCAT_SCRIPT; then
            $TOMCAT_SCRIPT start  
            TOMCAT_ERROR=$?
        fi
    else  
        if test -x $TOMCAT_SCRIPT; then
            $TOMCAT_SCRIPT start  
            TOMCAT_ERROR=$?
        fi
    fi
    
elif [ "x$1" = "xstop" ]; then
  if [ "x$2" = "xtomcat" ]; then
        if test -x $TOMCAT_SCRIPT; then
            $TOMCAT_SCRIPT stop
            TOMCAT_ERROR=$?
        fi
    else
        if test -x $TOMCAT_SCRIPT; then
            $TOMCAT_SCRIPT stop
            TOMCAT_ERROR=$?
            sleep 3
        fi
    fi

elif [ "x$1" = "xrestart" ]; then
  
    if [ "x$2" = "xtomcat" ]; then
        if test -x $TOMCAT_SCRIPT; then
            $TOMCAT_SCRIPT stop
            sleep 5
            $TOMCAT_SCRIPT start
            TOMCAT_ERROR=$?
        fi
    else
        if test -x $TOMCAT_SCRIPT; then
            $TOMCAT_SCRIPT stop
            TOMCAT_ERROR=$?
        fi              
        if test -x $TOMCAT_SCRIPT; then
            $TOMCAT_SCRIPT start
            TOMCAT_ERROR=$?
        fi
    fi
elif [ "x$1" = "xstatus" ]; then       
    if  [ "x$2" = "xtomcat" ]; then
        if test -x $TOMCAT_SCRIPT; then
            $TOMCAT_SCRIPT status
        fi
    else
        if test -x $TOMCAT_SCRIPT; then
            $TOMCAT_SCRIPT status
            sleep 3
        fi
    fi
else
    help
    exit 1
fi

# Checking for errors
for e in $TOMCAT_ERROR; do
    if [ $e -gt 0 ]; then
        ERROR=$e
    fi
done
# Restoring SELinux
if [ -f "/usr/sbin/getenforce" ] && [ `id -u` = 0 ] ; then
    /usr/sbin/setenforce $selinux_status 2> /dev/null
fi

exit $ERROR
