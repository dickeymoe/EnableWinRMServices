 @echo off

:: Program  : remotesvc_winrm.cmd
:: Needed   : Ensure PSService.exe is in $Path
::            Ensure a listfile for machines exists
::            Ensure all servers are reachable
:: Limits   : no check added so far covering the case where a
::            server cannot be contacted
:: -----------------With List-----------------------------------------
:: Function : read the computerlist argument (example: C:\serverlist.txt)
::            in a for loop process each server name (1 per line)
::            and run the defined command on each server remotely
:: Usage
::          : remotesvc_winrm.cmd [-UseList] [-on/-off] [serverlist.txt]
:: -----------------With Machine Name----------------------------------
::     
:: Function : read the computername argument (example: MACHINE_NAME)
::            and set WinRM service on and Automatic
::            or set the WinRM service to off and Manual
:: Usage    : remotesvc_winrm.cmd [-NoList] [-on/-off] [machine_name]
:: -----------------Help-----------------------------------------------
:: Help     : remotesvc_winrm.cmd [(with no args)(/?)(-h)(--help)]  
::
:: Examples : remotesvc_winrm.cmd -UseList -on C:\serverlist.txt
::            remotesvc_winrm.cmd -UseList -off C:\serverlist.txt
::            remotesvc_winrm.cmd -NoList -on MACHINE_NAME
::            remotesvc_winrm.cmd -NoList -off MACHINE_NAME
::            remotesvd_winrm.cmd --help


setlocal enableextensions enabledelayedexpansion
if "%1"=="-h" goto help
if "%1"=="--help" goto help
if "%1"=="/?" goto help
if [%1] == [] goto help
goto main

:main
	set RUNTYPE=""
	set LISTFILE=""
	set TARGET=""
	set RUNTYPE=%1
	if "%1"=="-UseList" set LISTFILE=%3
	if "%1"=="-NoList"	set TARGET=%3
	if [%1] == [] goto help
	if [%2] == [] echo Please specify -on or -off
	echo. 
	if [%2] == [] goto help
	if "%1"=="-NoList" goto NoList
	if "%1"=="-UseList" goto UseWithList

:NoList
	if "%2" == "-on" goto EnableWinRM_byTarget
	if "%2" == "-off" goto DisableWinRM_byTarget

:EnableWinRM_byTarget
	echo EnableWinRM_byTarget
	::Starts the WinRM service on machine
	psservice.exe \\%TARGET% start winrm
	echo WinRM service started on %TARGET%
	
	::Sets the (running) WinRM service to auto
	psservice.exe \\%TARGET% setconfig winrm auto
	echo WinRM service set to Automatic on %TARGET%
	goto EOF
	
:DisableWinRM_byTarget
	echo DisableWinRM_byTarget
	::Sets WinRM back to manual
	psservice.exe \\%TARGET% setconfig winrm demand
	echo WinRM service set to Manual on %TARGET%
	
	::Stops WinRM service
	psservice.exe \\%TARGET% stop winrm
	echo WinRM service stopped on %TARGET%
	goto EOF
	
:UseWithList
	:: check that the listfile is there
	if not exist %LISTFILE% (
	   echo Listfile %LISTFILE% not found. Create it and try again.
	   exit /b 1
	   goto EOF
	)

	if "%2" == "-on" goto EnableWinRM_byList
	if "%2" == "-off" goto DisableWinRM_byList

:EnableWinRM_byList
	echo -------------------------------------------------------
	echo Starting WinRM Service and set to Automatic
	echo -------------------------------------------------------
	:: Loop through the server list
	for /F  %%A in (%LISTFILE%) do (
		::Starts the WinRM service on machine
		psservice.exe \\%%A start winrm
		echo WinRM service started on %%A

		::Sets the (running) WinRM service to auto
		psservice \\%%A setconfig winrm auto
		echo WinRM service set to Automatic on %%A
	)
	echo -------------------------------------------------------
	echo Started WinRM Service (Automatic) for all items in list
	echo -------------------------------------------------------
	goto EOF

:DisableWinRM_byList
	echo -------------------------------------------------------
	echo Stopping WinRM Service and set to Manual
	echo -------------------------------------------------------
	
	:: Loop through the server list
	for /F  %%A in (%LISTFILE%) do (
		
		::Sets WinRM back to manual
		psservice \\%%A setconfig winrm demand
		echo WinRM service set to Manual on %%A

		::Stops WinRM service
		psservice \\%%A stop winrm
		echo WinRM service stopped on %%A
	)
	echo -------------------------------------------------------
	echo Stopped WinRM Service (Manual) for all items in list
	echo -------------------------------------------------------
	goto EOF

:help
	echo.
	echo ####HELP###########################################################
	echo.
	echo Program  : remotesvc_winrm.cmd
	echo Needed   : Ensure PSService.exe is in $Path
	echo            Ensure a listfile for machines exists
	echo            Ensure all servers are reachable
	echo Limits   : no check added so far covering the case where a
	echo            server cannot be contacted
	echo.
	echo -----------------With List-----------------------------------------
	echo Function : read the computerlist argument (example: C:\serverlist.txt)
	echo            in a for loop process each server name (1 per line)
	echo            and run the defined command on each server remotely
	echo Usage
	echo          : remotesvc_winrm.cmd [-UseList] [-on/-off] [serverlist.txt]
	echo.
	echo -----------------With Machine Name----------------------------------
	echo Function : read the computername argument (example: MACHINE_NAME)
	echo            and set WinRM service on and Automatic
	echo            or set the WinRM service to off and Manual
	echo Usage    : remotesvc_winrm.cmd [-NoList] [-on/-off] [machine_name]
	echo.
	echo -----------------Help-----------------------------------------------
	echo Help     : remotesvc_winrm.cmd [(with no args)(/?)(-h)(--help)]  
	echo.
	echo Examples : remotesvc_winrm.cmd -UseList -on C:\serverlist.txt
	echo            remotesvc_winrm.cmd -UseList -off C:\serverlist.txt
	echo            remotesvc_winrm.cmd -NoList -on MACHINE_NAME
	echo            remotesvc_winrm.cmd -NoList -off MACHINE_NAME
	echo            remotesvd_winrm.cmd --help
	echo.
	echo ###################################################################

:EOF
	endlocal
