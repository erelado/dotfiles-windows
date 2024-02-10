function Set-EspansoConfiguration() {

    <#
    .SYNOPSIS
    Copies the Espanso configuration matches to the required location.

    .DESCRIPTION
    Copies the Espanso matches found in the script folder to the required
    location.

    .PARAMETER DotfilesDirectory
    Specifies the main script's directory.

    .OUTPUTS
    None.
    #>

    
    $DotFilesEspansoPath = Join-Path $DotfilesDirectory -ChildPath "Applications" | Join-Path -ChildPath "Espanso"
    $EspansoMatchesPath = Join-Path -Path $env:APPDATA -ChildPath "Code" | Join-Path -ChildPath "User"
  
    if (-not (Test-Path -Path $EspansoMatchesPath)) {
        Write-Host "Could not find Espanso configuration directory." -ForegroundColor "Red"
    }
    else {
        # matches
        Get-ChildItem -Path "${DotFilesEspansoPath}\*" -Include "*.yml" -Recurse | Copy-Item -Destination $EspansoMatchesPath -Force
        Write-Host "'Espanso' has been configured successfully.`n" -ForegroundColor "Green"
    }
}
