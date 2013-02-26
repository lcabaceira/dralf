@rem===========================================================================
@rem  Copyright 2004-2005 jManage.org. All rights reserved.
@rem===========================================================================

if "%JAVA_HOME%" == "" goto javaHomeNotSet

if "%JMANAGE_HOME%" == "" set JMANAGE_HOME=..

if not exist "%JMANAGE_HOME%\lib\jmanage-startup.jar" goto jmanageHomeNotSet

set JMANAGE_CLASSPATH=

set CURR_PWD=%CD%
cd "%JMANAGE_HOME%\lib"

for %%i in ("*.jar") do call ..\bin\jmcp.cmd %%i 

cd %CURR_PWD%

if "%CLASSPATH%" == "" goto finish
set JMANAGE_CLASSPATH=%JMANAGE_CLASSPATH%;%CLASSPATH%
@rem echo classpath=%JMANAGE_CLASSPATH%

goto finish

:javaHomeNotSet
echo Please set JAVA_HOME environment variable. JAVA_HOME must point to a JDK 1.4 installation directory.
goto finish

:jmanageHomeNotSet
echo Please set JMANAGE_HOME environment variable pointing to jManage installation directory.
goto finish

:finish
