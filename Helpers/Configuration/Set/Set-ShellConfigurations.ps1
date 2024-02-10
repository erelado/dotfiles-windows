function Set-ShellConfigurations {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [PSCustomObject]
        $JSON_Data
    )

    <#
    .SYNOPSIS
    Acts in favor of defining the user's requirements for different 
    Shell configurations.

    .INPUTS
    None. You cannot pipe objects to Set-ShellConfigurations.

    .OUTPUTS
    None.
    #>

    foreach ($ShellCategory in $JSON_Data.Shell.PSObject.Properties) {
        
        switch ($ShellCategory.Name.ToLower()) {
            "powershell" {
                if ($ShellCategory.Value.Install) {
                    $AppName = $AppCategory.Value.Name
                    $Source = $ShellCategory.Value.SelectedSource
                    $AppId = $ShellCategory.Value.Sources.$Source
                    Install-WingetApp -AppName $AppName -AppId $AppId -Source $Source
                }

                foreach ($Configuration in $ShellCategory.Value.Configurations.PSObject.Properties) {
                    switch ($Configuration.Name.ToLower()) {
                        "profile" {
                            if ($Configuration.Value.Set) {
                                New-PowerShellProfile -JSON_Data $JSON_Data
                            }
                            break
                        }
                        "modules" {
                            foreach ($Module in $Configuration.Value) {
                                if ($Module.Install) { 
                                    $Command = "Install-PowerShellModule -Name '$($Module.Name)' -Repository '$($Module.Repository)'"
                                    if ($Module.Force) { $Command += " -Force" }
                                    Invoke-Expression $Command
                                }
                            }
                            break
                        }
                        "ohmyposh" {
                            if ($Configuration.Value.Install) {
                                $AppName = $Configuration.Value.Name
                                $Source = $Configuration.Value.SelectedSource
                                $AppId = $Configuration.Value.Sources.$Source
                                Install-WingetApp -AppName = $AppName -AppId $AppId -Source $Source
                            }
                            break
                        }
                    }
                }
            }
        }
    }
}
