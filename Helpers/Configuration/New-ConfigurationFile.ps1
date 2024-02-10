function New-ConfigurationFile {
    param(
        [Parameter( Position = 0, Mandatory = $FALSE)]
        [PSDefaultValue(Help = $FALSE)]
        [bool]
        $Override = $FALSE
    )

    <#
    .SYNOPSIS
    Creates a new configuration file according to the user's input.

    .DESCRIPTION
    Guides the user through the process of creating a new configuration file. 
    It is configured for predefined settings and guides the user through 
    the process of selecting options for each setting.

    .PARAMETER Override
    Specifies whether to override an existing configuration file.

    .OUTPUTS
    None.
    #>
    
    $DotfilesConfigFile = Join-Path $DotfilesDirectory -ChildPath "config.json"

    $Sections = [ordered]@{
        'Applications' = @(
            'Basic Tools',
            'DevOps Tools',
            'Espanso',
            'Git',
            'VSCode',
            'WindowsTerminal'
        )
        'OS'           = @(
            "Windows"
        )
        'Shell'        = @(
            "PowerShell"
        )
    }

    # Count sections
    $Sections.GetEnumerator() | ForEach-Object { $TotalSections += $_.Value.Count }
    $CurrentSection = 1
    
    $ConfigurationData = [ordered]@{}
    foreach ($Section in $Sections.GetEnumerator()) {
        $SectionData = [ordered]@{}
        for ($i = 0; $i -lt $Section.Value.Count; $i++) {
            $SectionNameNoWhitespaces = $($Section.Value[$i].Replace(' ', ''))
            $CommandName = "Initialize-${SectionNameNoWhitespaces}"
            
            Write-WelcomeMessage -Message "Setting up a new 'config.json' file: $($Section.Value[$i]) (${CurrentSection}/${TotalSections})"
            $SectionData.Add($SectionNameNoWhitespaces, (Invoke-Expression $CommandName))

            $CurrentSection++
        }
        $ConfigurationData.Add($Section.Key, $SectionData)
    }

    # JSON file generation
    if ($Override) {
        Write-WelcomeMessage -Message "Overriding the existing 'config.json' file:"
        Remove-Item $DotfilesConfigFile -ErrorAction SilentlyContinue
    }
    else { Write-WelcomeMessage -Message "Creating config.json file:" }

    Set-Content -Path $DotfilesConfigFile `
        -Value ($ConfigurationData | ConvertTo-Json -Depth 10)

    # JSON file generation verification
    if (Test-Path -Path $DotfilesConfigFile) {
        Write-Host "'config.json' file has been successfully created at " -ForegroundColor "Green" -NoNewline
        Write-Host "${DotfilesConfigFile}`n"
    }
    else {
        Write-Host "Could not create the 'config.json' file. Please check your settings and try again later.`n" -ForegroundColor "Red"
        break
    }

    # Execution verification
    if (-not (Approve-YesNoQuestion -Question "Would you like to execute the script right now?")) { 
        Clear-Host
        Write-Host "You can always find me at '" -NoNewline
        Write-Host "${DotfilesDirectory}\Setup.ps1" -ForegroundColor "Yellow" -NoNewline
        Write-Host "'.`nBye-bye."
        break
    }
}
