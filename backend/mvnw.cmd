@ECHO OFF
SETLOCAL
IF NOT "%MAVEN_HOME%"=="" (
  SET "MVN_CMD=%MAVEN_HOME%\bin\mvn.cmd"
) ELSE IF EXIST "C:\Program Files\JetBrains\IntelliJ IDEA 2025.3.2\plugins\maven\lib\maven3\bin\mvn.cmd" (
  SET "MVN_CMD=C:\Program Files\JetBrains\IntelliJ IDEA 2025.3.2\plugins\maven\lib\maven3\bin\mvn.cmd"
) ELSE (
  SET "MVN_CMD=mvn.cmd"
)

CALL "%MVN_CMD%" %*
ENDLOCAL
