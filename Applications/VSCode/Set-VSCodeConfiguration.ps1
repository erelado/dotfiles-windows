function Set-VSCodeConfiguration() {

    <#
    .SYNOPSIS
    Copies the VS Code settings to the required location.

    .DESCRIPTION
    Copies the VS Code settings found in the script folder to the required
    location.

    .PARAMETER DotfilesDirectory
    Specifies the main script's directory.

    .OUTPUTS
    None.
    #>

    $DotFilesVSCodePath = Join-Path $DotfilesDirectory -ChildPath "Applications" | Join-Path -ChildPath "VSCode"
    $VSCodeSettingsPath = Join-Path -Path $env:APPDATA -ChildPath "Code" | Join-Path -ChildPath "User"
  
    if (-not (Test-Path -Path $VSCodeSettingsPath)) {
        Write-Host "Could not find Visual Studio Code settings directory." -ForegroundColor "Red"
    }
    else {
        # Settings & Keybindings
        Get-ChildItem -Path "${DotFilesVSCodePath}\*" -Include "*.json" -Recurse | Copy-Item -Destination $VSCodeSettingsPath
        Write-Host "'Visual Studio Code' has been configured successfully.`n" -ForegroundColor "Green"
    }
}
