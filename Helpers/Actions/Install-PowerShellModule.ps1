function Install-PowerShellModule {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $Name,

        [Parameter(Position = 1, Mandatory = $TRUE)]
        [String]
        $Repository,

        [Parameter(Position = 2, Mandatory = $FALSE)]
        [switch]
        $Force
    )

    <#
    .SYNOPSIS
    Installs frequently used PowerShell modules.

    .INPUTS
    None. You cannot pipe objects to Install-PowerShellModules.

    .OUTPUTS
    None.
    #>

    $Command = "Install-Module -Name ${Name} -Repository ${Repository}"
    if ($Force) { $Command += " -Force" }

    Write-Host "Installing PowerShell module '${Name}':" -ForegroundColor "Yellow"

    # Trust PSRepository
    if (-not (Test-PSRepositoryTrustedStatus -PSRepositoryName $Repository)) {
        Write-Host "Setting up ${Repository} as PowerShell trusted repository: " -ForegroundColor "Yellow" -NoNewline
        Set-PSRepository -Name $Repository -InstallationPolicy Trusted
        Write-Host "Done."
    }
    
    Invoke-Expression $Command

    Write-Host "The PowerShell module '${Name}' has been successfully installed.`n" -ForegroundColor "Green"
}
