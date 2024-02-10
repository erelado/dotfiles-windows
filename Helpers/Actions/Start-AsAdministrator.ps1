function Start-AsAdministrator {

    <#
    .SYNOPSIS
    Relaunches the program as administrator.

    .INPUTS
    None. You cannot pipe objects to Start-AsAdministrator.

    .OUTPUTS
    None.
    #>

    # Stop, and run as Administrator
    Write-Warning "You are not running this as a 'Domain Admin' or 'Local Administrator' of ${env:COMPUTERNAME}."
    Write-Warning "The script will be re-executed as Local Administrator shortly."
    Start-Sleep 3

    # Build base arguments for powershell.exe as string array
    $ArgList = '-NoLogo', '-NoProfile', '-NoExit', '-ExecutionPolicy Bypass', '-File', ('"{0}"' -f $PSCommandPath)

    try {
        Start-Process PowerShell.exe -Verb "RunAs" -WorkingDirectory $PWD -ArgumentList $ArgList -Verbose -ErrorAction "Stop"
    
        # Exit the current script
        exit
    }
    catch { throw }
}
