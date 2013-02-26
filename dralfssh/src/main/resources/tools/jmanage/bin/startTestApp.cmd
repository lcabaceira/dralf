@rem===========================================================================
@rem  Copyright 2004-2005 jManage.org. All rights reserved.
@rem===========================================================================
@echo off

call setenv.cmd
if "%JMANAGE_CLASSPATH%" == "" goto finish

"%JAVA_HOME%/bin/java" -Dcom.sun.management.jmxremote -ea -classpath "%JMANAGE_CLASSPATH%" %DEBUG_OPTIONS% org.jmanage.testapp.jsr160.Startup %*

:finish
