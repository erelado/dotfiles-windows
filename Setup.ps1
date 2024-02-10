################################################################################
# Launch                                                                       #
################################################################################
Using module .\Helpers\Data\Classes\WingetApp.psm1
Using module .\Helpers\Data\Classes\WingetConfiguredApp.psm1
Using module .\Helpers\Data\Classes\OSObject.psm1

$DotfilesDirectory = Join-Path -Path ${HOME} -ChildPath ".dotfiles"

if (-not (Test-Path $DotfilesDirectory)) {
    Write-Host "Cannot find the '.dotfiles' directory." -ForegroundColor "Red"
    break
}


################################################################################
# Load helpers                                                                 #
################################################################################
Write-Host "Loading helpers: " -ForegroundColor "Yellow" -NoNewline

Push-Location $DotfilesDirectory

# Load classes first
Get-ChildItem -Path ".\Helpers\Data\Classes" -Filter "*.psm1" -Recurse | `
    ForEach-Object -process { Invoke-Expression "Import-Module $($_.FullName)" }

# Then, load the rest
$SubDirectories = @("Applications", "Helpers", "OS", "Shell")
$ExcludedScripts = @("Template.ps1", "Profile.ps1")

$SubDirectories | ForEach-Object { Get-ChildItem -Path $_ -Filter "*.ps1" -Recurse } | `
    Where-Object { $ExcludedScripts -notcontains $_.Name } | `
    ForEach-Object -process { Invoke-Expression ". $($_.FullName)" }
Pop-Location

Write-Host "Done."

Write-WelcomeMessage


################################################################################
# Prerequisites verifications                                                  #
################################################################################
# Whether Winget is installed
if (-not (Test-WingetExistance)) { break }

# Whether running 'as Administrator'
if (-not (Test-Elevated)) {
    
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

$CurrentLoginPrincipal = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent())
Write-Host "$($CurrentLoginPrincipal.Identity.Name.ToString()) is currently running as a Local Administrator.`n" -ForegroundColor "Green"


################################################################################
# Configurations                                                               #
################################################################################
# Generate and save the user's required configurations
Test-ConfigurationFileExistance

# Act according to the generated file
Set-Configurations


################################################################################
# Wrap up                                                                      #
################################################################################
Remove-DesktopShortcuts
Restart-ComputerCountdown
