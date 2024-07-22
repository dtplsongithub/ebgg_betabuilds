@echo off
if exist temp\ (
  rd /S /Q "temp\"
  mkdir temp
) else (
  mkdir temp
)
cd temp
if exist latestversion.zip (
  del latestversion.zip
)
cls
echo.
echo.
echo      +-------------+    code written by d
echo     EBGG UPDATER V1.0
echo      +-------------+    last updated 2024 may 23
echo.
echo.
echo.
echo What kind of ebgg version do you have?
echo.
echo 1) windows-amd64
echo 2) windows-amd64-openJDK-included
echo.
choice /C 12 /N
cls
if %ERRORLEVEL% EQU 2 (
  echo Downloading latest version...
  powershell Invoke-WebRequest https://github.com/dtplsongithub/ebgg/releases/latest/download/windows-amd64-openJDK-included.zip -OutFile "latestversion.zip" >nul
  cls
  echo Unzipping...
  powershell Expand-Archive latestversion.zip -DestinationPath .\
  xcopy ".\windows-amd64-openJDK-included\" .\ /-Y /E
) else if %ERRORLEVEL% EQU 1 (
  echo Downloading latest version...
  powershell Invoke-WebRequest https://github.com/dtplsongithub/ebgg/releases/latest/download/windows-amd64.zip -OutFile "latestversion.zip" >nul
  cls
  echo Unzipping...
  powershell Expand-Archive latestversion.zip -DestinationPath .\
  cd..
  cls
  echo Copying files...
  echo.
  xcopy ".\temp\windows-amd64\" .\ /-Y /E
)
cls
echo Succesfully updated! Press any key to exit...
pause>nul
cd..
rd /S /Q "temp\"