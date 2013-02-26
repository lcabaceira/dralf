@rem===========================================================================
@rem  Copyright 2004-2005 jManage.org. All rights reserved.
@rem===========================================================================
@echo off

call setenv.cmd
if "%JMANAGE_CLASSPATH%" == "" goto finish

"%JAVA_HOME%/bin/java" -ea -classpath "%JMANAGE_CLASSPATH%" %DEBUG_OPTIONS% -Djava.security.policy=java.policy -Djava.util.logging.config.file="%JMANAGE_HOME%/config/logging.properties" -Djmanage.root="%JMANAGE_HOME%" -Djava.security.auth.login.config="%JMANAGE_HOME%/config/jmanage-auth.conf" -Dorg.jmanage.core.management.data.formatConfig=%JMANAGE_HOME%/config/html-data-format.properties org.jmanage.webui.Startup %*

:finish
