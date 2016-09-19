# EnableWinRMServices
Enable WinRM services remotely with batch file and PSService.exe


# Usage
Program  : remotesvc_winrm.cmd
Needed   : Ensure PSService.exe is in $Path
           Ensure a listfile for machines exists
           Ensure all servers are reachable
Limits   : no check added so far covering the case where a
           server cannot be contacted

-----------------With List-----------------------------------------
Function : read the computerlist argument (example: C:\serverlist.txt)
           in a for loop process each server name (1 per line)
           and run the defined command on each server remotely
Usage
         : remotesvc_winrm.cmd [-UseList] [-on/-off] [serverlist.txt]

-----------------With Machine Name----------------------------------
Function : read the computername argument (example: MACHINE_NAME)
           and set WinRM service on and Automatic
           or set the WinRM service to off and Manual
Usage    : remotesvc_winrm.cmd [-NoList] [-on/-off] [machine_name]

-----------------Help-----------------------------------------------
Help     : remotesvc_winrm.cmd [(with no args)(/?)(-h)(--help)]  

Examples : remotesvc_winrm.cmd -UseList -on C:\serverlist.txt
           remotesvc_winrm.cmd -UseList -off C:\serverlist.txt
           remotesvc_winrm.cmd -NoList -on MACHINE_NAME
           remotesvc_winrm.cmd -NoList -off MACHINE_NAME
           remotesvd_winrm.cmd --help
