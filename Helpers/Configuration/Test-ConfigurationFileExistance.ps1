function Test-ConfigurationFileExistance {

    <#
    .SYNOPSIS
    Verifys whether there is an existing configuration file to load from.

    .INPUTS
    None. You cannot pipe objects to Test-ConfigurationFileExistance.

    .OUTPUTS
    None.
    #>
    
    $DotfilesConfigFile = Join-Path $DotfilesDirectory -ChildPath "config.json"

    # Existing configuration file verification
    if ((Test-Path -Path $DotfilesConfigFile)) {
        Write-Host "A 'config.json' file already exists in the '.dotfiles' directory." -ForegroundColor "Yellow"
        if ((Approve-YesNoQuestion -Question "Would you like to use the current 'config.json'?")) { return }
        else { New-ConfigurationFile -Override $TRUE; return }
    }

    New-ConfigurationFile
}
