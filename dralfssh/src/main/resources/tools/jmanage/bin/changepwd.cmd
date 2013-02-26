@rem===========================================================================
@rem  Copyright 2004-2005 jManage.org. All rights reserved.
@rem===========================================================================
@echo off

call setenv.cmd
if "%JMANAGE_CLASSPATH%" == "" goto finish

"%JAVA_HOME%\bin\java" -ea -classpath "%JMANAGE_CLASSPATH%" -Djmanage.root="%JMANAGE_HOME%" org.jmanage.core.tools.ChangeAdminPassword

:finish
