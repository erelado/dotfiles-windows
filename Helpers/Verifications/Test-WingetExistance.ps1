function Test-WingetExistance {

    <#
    .SYNOPSIS
    Checks for the presence of 'winget' on the local machine.

    .DESCRIPTION
    Verifying the presence of winget on the local machine, since the entire
    script depends on it. If not, print an appropriate message.

    .INPUTS
    None. You cannot pipe objects to Test-WingetExistance.

    .OUTPUTS
    System.Boolean. Test-WingetExistance returns true if 'winget' is present,
    false otherwise.
    #>

    if (Get-Command "winget" -ErrorAction SilentlyContinue) {
        return $TRUE
    }
    Write-Host "Windows Package Manager is currently not installed." -ForegroundColor "Yellow"
    Write-Host "For more information, please visit https://learn.microsoft.com/en-us/windows/package-manager/winget." -ForegroundColor "Yellow"
    Write-Host "Please come back once the installation has been completed." -ForegroundColor "Yellow"
    return $FALSE
}
