@rem===========================================================================
@rem  Copyright 2004-2005 jManage.org. All rights reserved.
@rem===========================================================================
@echo off

call setenv.cmd
if "%JMANAGE_CLASSPATH%" == "" goto finish

"%JAVA_HOME%/bin/java" -ea -classpath "%JMANAGE_CLASSPATH%" %DEBUG_OPTIONS% -Djmanage.root="%JMANAGE_HOME%" -Dorg.jmanage.core.management.data.formatConfig="%JMANAGE_HOME%/config/text-data-format.properties" org.jmanage.cmdui.Main %*

:finish
