function Test-Elevated {

    <#
    .SYNOPSIS
    Returns whether the script is currently running in "Administrator" mode.

    .INPUTS
    None. You cannot pipe objects to Test-Elevated.

    .OUTPUTS
    System.Boolean. Test-Elevated returns true if the script currently running
    "as Administrator", false otherwise.
    #>

    # Get the ID and security principal of the current user account
    $MyIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $MyPrincipal = new-object System.Security.Principal.WindowsPrincipal($MyIdentity)

    # Check to see if we are currently running "as Administrator"
    return $MyPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}
