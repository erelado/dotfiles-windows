function Set-OSConfigurations {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [PSCustomObject]
        $JSON_Data
    )

    <#
    .SYNOPSIS
    Acts in favor of defining the user's requirements for different 
    OS configurations.

    .INPUTS
    None. You cannot pipe objects to Set-OSConfigurations.

    .OUTPUTS
    None.
    #>

    foreach ($OSCategory in $JSON_Data.OS.PSObject.Properties) {
        
        switch ($OSCategory.Name.ToLower()) {
            "windows" {
                foreach ($Configuration in $OSCategory.Value.Configurations.PSObject.Properties) {
                    switch ($Configuration.Name.ToLower()) {
                        "RenameComputer" {
                            if ($Configuration.Value.Set) { Rename-PC -Name $Configuration.Value.ComputerName }
                            break
                        }
                        Default {
                            if ($Configuration.Value) { 
                                $CommandName = "Set-$($Configuration.Name)"
                                Invoke-Expression $CommandName
                            }
                            break
                        }
                    }
                }

                foreach ($Directory in $OSCategory.Value.Directories.PSObject.Properties) {
                    switch ($Directory.Name.ToLower()) {
                        Default {
                            if ($Directory.Value.Set) {
                                $CommandName = "New-$($Directory.Name)Directory"
                                Invoke-Expression $CommandName -ParentDirectory $Directory.Value.ParentDirectory
                            }
                            break
                        }
                    }
                }

                foreach ($Font in $OSCategory.Value.Fonts.PSObject.Properties) {
                    switch ($Font.Name.ToLower()) {
                        "NerdFont" {
                            if ($Font.Value.Install) {
                                Install-NerdFont -FontName $Font.Value.FontName
                            }
                            break
                        }
                    }
                }

                break
            }
        }
    }
}
