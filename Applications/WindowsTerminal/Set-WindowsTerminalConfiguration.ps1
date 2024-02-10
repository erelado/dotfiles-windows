function Set-WindowsTerminalConfiguration() {
    param (
        [Parameter(Position = 1, Mandatory = $FALSE)]
        [String]
        $NerdFontName
    )

    <#
    .SYNOPSIS
    Copies the Windows Terminal settings to the required location.

    .DESCRIPTION
    Copies the Windows Terminal settings found in the script folder to
    the required location.

    .PARAMETER NerdFontName
    Specifies the selected Nerd Font name as the default font.

    .OUTPUTS
    None.
    #>

    Write-Host "Configuring Windows Terminal settings:" -ForegroundColor "Yellow"
    
    $LocalAppDataPackagesPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Packages"
    $WindowsTerminalSettingsPath = Join-Path (Get-ChildItem -Path $LocalAppDataPackagesPath -Filter "Microsoft.WindowsTerminal*") -ChildPath "LocalState" | `
        Join-Path -ChildPath "settings.json"

    $CustomActionsPath = Join-Path $DotfilesDirectory -ChildPath "Applications" | `
        Join-Path -ChildPath "WindowsTerminal" | `
        Join-Path -ChildPath "customActions.json"
    $ProfileDefaultsPath = Join-Path $DotfilesDirectory -ChildPath "Applications" | `
        Join-Path -ChildPath "WindowsTerminal" | `
        Join-Path -ChildPath "profileDefaults.json"

    if (-not (Test-Path $WindowsTerminalSettingsPath)) {
        Write-Host "Could not find Windows Terminal 'settings.json' file." -ForegroundColor "Red"
        return
    }
	
    # Add custom actions
    $Settings = Get-Content $WindowsTerminalSettingsPath | ConvertFrom-Json
	(Get-Content $CustomActionsPath | ConvertFrom-Json).actions | ForEach-Object {
        $Settings.actions += $_
    }
    Write-Host "Updated custom actions."
	
    # Set profile defaults
    if ($null -eq $NerdFontName) { $FontName = "Cascadia Mono" } else { $FontName = "$($NerdFontName) Nerd Font Mono" }
    (Get-Content -Path $ProfileDefaultsPath) -replace "<FONT_NAME>", $FontName | Set-Content -Path $ProfileDefaultsPath
    Write-Host "Updated the default font to: ${FontName}"
    Write-Host "Updated profile defaults."

    $Settings = (Get-Content $WindowsTerminalSettingsPath | ConvertFrom-Json)
    $Settings.profiles.defaults = (Get-Content $ProfileDefaultsPath | ConvertFrom-Json).defaults

    # Set and copy to required location
    $Settings | ConvertTo-Json -Depth 100 | Out-file $WindowsTerminalSettingsPath -Force
    
    Write-Host "Windows Terminal has been successfully configured.`n" -ForegroundColor "Green"
}
