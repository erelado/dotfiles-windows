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
        $AppCategory.Value | ForEach-Object {

            $AppName = $_.Name

            if ($_.Install) {
                $Source = $_.SelectedSource
                $AppId = $_.Sources.$Source
                Install-WingetApp -AppName $AppName -AppId $AppId -Source $Source
            }

            # Other Apps – specific configurations
            $Configurations = $_.Configurations
            if ($Configurations) {
                switch ($AppName.ToLower()) {
                    "espanso" {
                        if ($Configurations.SetConfigs) { Set-EspansoConfiguration }

                        break
                    }
                    "git" {
                        if (-not [string]::IsNullOrEmpty($Configurations.Globals.User_Name)) {
                            # Reload environment variables
                            Update-EnvironmentVariables
            
                            # Set configurations
                            Set-GitConfiguration -UserName $Configurations.Globals.User_Name `
                                -UserEmail $Configurations.Globals.User_Email
                        }

                        break
                    }
                    "visual studio code" {
                        if ($Configurations.InstallExtensions) { Install-VSCodeExtensions }
                        if ($Configurations.SetCustomSettings) { Set-VSCodeConfiguration }

                        break
                    }
                    "windows terminal" {
                        if ($Configurations.SetCustomSettings) {
                            $SelectedNerdFont = $JSON_Data.OS.Windows.Fonts.NerdFont.FontName
                            Set-WindowsTerminalConfiguration -NerdFontName $SelectedNerdFont
                        }

                        break
                    }

                }
            }
        }
    }
}
