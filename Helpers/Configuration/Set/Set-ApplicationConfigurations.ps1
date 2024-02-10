function Set-ApplicationConfigurations {

    <#
    .SYNOPSIS
    Acts in favor of defining the user's requirements for different 
    applications.

    .INPUTS
    None. You cannot pipe objects to Set-ApplicationConfigurations.

    .OUTPUTS
    None.
    #>

    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [PSCustomObject]
        $JSON_Data
    )

    foreach ($AppCategory in $JSON_Data.Applications.PSObject.Properties) {
        
        if ($AppCategory.Value -is [array]) {
            $AppCategory.Value | ForEach-Object {
                if ($_.Install) {
                    $AppName = $_.Name
                    $Source = $_.SelectedSource
                    $AppId = $_.Sources.$Source
                    Install-WingetApp -AppName $AppName -AppId $AppId -Source $Source
                }
            }
            continue
        }

        if ($AppCategory.Value.Install) {
            $AppName = $AppCategory.Value.Name
            $Source = $AppCategory.Value.SelectedSource
            $AppId = $AppCategory.Value.Sources.$Source
            Install-WingetApp -AppName $AppName -AppId $AppId -Source $Source
        }
        
        switch ($AppCategory.Name.ToLower()) {
            "espanso" {
                if ($AppCategory.Value.Configurations.SetConfigs) { Set-EspansoConfiguration }

                break
            }
            "git" {
                if (-not [string]::IsNullOrEmpty($AppCategory.Value.Configurations.Globals.User_Name)) {
                    # Reload environment variables
                    Update-EnvironmentVariables
                    
                    # Set configurations
                    Set-GitConfiguration -UserName $AppCategory.Value.Configurations.Globals.User_Name `
                        -UserEmail $AppCategory.Value.Configurations.Globals.User_Email
                }

                break
            }
            "vscode" {
                if ($AppCategory.Value.Configurations.InstallExtensions) { Install-VSCodeExtensions }
                if ($AppCategory.Value.Configurations.SetCustomSettings) { Set-VSCodeConfiguration }

                break
            }
            "windowsterminal" {
                if ($AppCategory.Value.Configurations.SetCustomSettings) {
                    $SelectedNerdFont = $JSON_Data.OS.Windows.Fonts.NerdFont.FontName
                    Set-WindowsTerminalConfiguration -NerdFontName $SelectedNerdFont
                }

                break
            }
        }
    }
}
