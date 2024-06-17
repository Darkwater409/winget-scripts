@echo off
  rem Test if current context is already elevated:
  whoami /groups | findstr /b BUILTIN\Administrators | findstr /c:"Enabled group" 1> nul 2>nul && goto :isadministrator
  echo Requesting Administrator permission...
  :: Use gsudo to launch this batch file elevated.
  gsudo "%~f0"
  goto end
:isadministrator
  set id=Microsoft.PowerToys
  set name=Microsoft PowerToys

  set logpath=%LOCALAPPDATA%\logging\winget

  for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
  set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
  set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

  set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
  set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

  echo datestamp: "%datestamp%"
  echo timestamp: "%timestamp%"
  echo fullstamp: "%fullstamp%"
  echo package: "%name% [%id%]"

  echo Installing selected package... please be patient...
  winget install %id% -e -i --accept-package-agreements --accept-source-agreements --verbose > "%logpath%\%name%_%fullstamp%.log"
:end