# Winget Scripts
A collection of scripts to automate installing packages from winget

## Requirements
- gsudo
- winget-cli

## Instructions
1. Before using the scripts in this repo, you must first install gsudo. You can do so via the following methods.

 - Using Scoop: `scoop install gsudo`
 - Using WinGet: `winget install gerardog.gsudo -e -i`
 - Using Chocolatey: `choco install gsudo`
 - Powershell:
 ```powershell
 PowerShell -Command "Set-ExecutionPolicy RemoteSigned -scope Process; [Net.ServicePointManager]::SecurityProtocol = 'Tls12'; iwr -useb https://raw.githubusercontent.com/gerardog/gsudo/master/installgsudo.ps1 | iex"
 ```
 - Portable:
  1. Download gsudo.portable.zip from the [latest release][gsudo]
  2. Extract the folder corresponding to your processor architecture (x64, x86, or arm64) from the zip file to a suitable directory on your computer.
  3. Optionally, add that directory to your system's `PATH` environment variable if it's not already accessible.

 Make sure to restart all your console windows after installing to ensure that the `PATH` environment variable is refreshed.

2. Once you have installed `gsudo`, simply double click the batch file for whichever program you wish to install.

Note: The batch files will store verbose logs in the `%localappdata%\logging\winget` folder. If the folder does not exist, the batch scripts will create it.

[gsudo]: https://github.com/gerardog/gsudo/releases/latest

## Contributing
Contributors are more than welcome to add their own scripts. Simply make sure to copy and paste the following and then edit in the id and name.

Note: Do NOT include `""` in the id or name, as it will break the script.

```sh
@echo off
  rem Test if current context is already elevated:
  whoami /groups | findstr /b BUILTIN\Administrators | findstr /c:"Enabled group" 1> nul 2>nul && goto :isadministrator
  echo Requesting Administrator permission...
  :: Use gsudo to launch this batch file elevated.
  gsudo "%~f0"
  goto end
:isadministrator
  set id=
  set name=

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
```
<details><summary>Example Script</summary>

```sh
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
```
</details>
