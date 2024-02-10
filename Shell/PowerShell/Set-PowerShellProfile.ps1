function Set-PowerShellProfile {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $FilePath
    )

    <#
    .SYNOPSIS
    Copies the PowerShell profile to its required location.

    .PARAMETER FilePath
    Specifies the path to the PowerShell profile file.

    .OUTPUTS
    None.
    #>

    Write-Host "Copying PowerShell profile:" -ForegroundColor "Yellow"
    
    $PSProfilePath = ${PROFILE}

    # Force as a PowerShell profile (in case of other IDE usage, like VS Code)
    $PSProfilePath = if ($PSProfilePath -notmatch "Microsoft.PowerShell") { 
        (Join-Path (Split-Path -Parent $Profile) -ChildPath "Microsoft.PowerShell_profile.ps1")
    }

    Copy-Item $FilePath -Destination $PSProfilePath

    if (-not (Test-Path $FilePath)) {
        Write-Host "Could not create the PowerShell profile.`n" -ForegroundColor "Red"
    }
    else {
        Write-Host "PowerShell profile has been successfully created.`n" -ForegroundColor "Green"
    }
}
