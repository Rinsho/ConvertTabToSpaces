::Replace Tabs in matched files in a directory and subdirectories

@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET localDir=%~dp0%
SET /A spaceNumber=4

:EnterDirectory
SET /P workingDir=Enter working directory (blank to use current): 
IF "!workingDir!" EQU "" SET workingDir=%localDir%
IF NOT EXIST "!workingDir!" (
  ECHO Invalid directory.
  SET workingDir=
  GOTO :EnterDirectory
)
SET /P recursive=Include subdirectories (Y/N)? 

ECHO.
ECHO Enter files to convert. Wildcards supported.
ECHO Separate files with a comma (ex. *.txt, blah.dat)
SET /P files=Enter files: 

IF /I "%recursive%" EQU "Y" (
  FOR /R "!workingDir!" %%G IN (%files%) DO (
    REN "%%G" "%%~nxG.replacebackup"
    (MORE /t%spaceNumber% < "%%G.replacebackup") > "%%G"
  )
) ELSE (
  PUSHD "!workingDir!"
  FOR %%G IN (%files%) DO (
    REN "%%G" "%%G.replacebackup"
    (MORE /t%spaceNumber% < "%%G.replacebackup") > "%%G"
  )
  POPD
)
ECHO Replacement complete.
ECHO.
SET /P removeBackup=Remove backup files (*.replacebackup)? 
IF /I "%removeBackup%" EQU "Y" (
  PUSHD "!workingDir!"
  DEL /P /S *.replacebackup
  POPD
  ECHO Deletion complete.
)

ECHO Operations complete.  Press any key to exit.
ENDLOCAL
PAUSE > NUL