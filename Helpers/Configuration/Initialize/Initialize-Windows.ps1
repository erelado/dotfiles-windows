function Initialize-Windows {
    
    <#
    .SYNOPSIS
    Asks the user how to set up Windows settings.

    .INPUTS
    None. You cannot pipe objects to Initialize-Windows.

    .OUTPUTS
    None.
    #>
    
    $Reply = Approve-YesNoQuestion -Question "Would you like to choose Windows settings to configure?"
    if (-not $Reply) {
        return $Windows
    }

    $Windows.Configurations.RenameComputer.Set = (Approve-YesNoQuestion -Question "Would you like to set a PC name?")
    if ($Windows.Configurations.RenameComputer.Set) {
        $Windows.Configurations.RenameComputer.ComputerName = (Read-Host "Please enter the computer name")
        Write-Host
    }

    $Windows.Configurations.DarkMode = (Approve-YesNoQuestion -Question "Would you like to configure 'dark mode' theme?")
    $Windows.Configurations.ExplorerSettings = (Approve-YesNoQuestion -Question "Would you like to configure explorer settings?")
    $Windows.Configurations.PowerPlan = (Approve-YesNoQuestion -Question "Would you like to configure the power plan (AC timeout = 0)?")
    $Windows.Configurations.PrivacySettings = (Approve-YesNoQuestion -Question "Would you like to configure privacy settings?")
    $Windows.Configurations.RegionalFormat = (Approve-YesNoQuestion -Question "Would you like to configure regional formats?")


    $Windows.Directories.Workspace.Set = (Approve-YesNoQuestion -Question "Would you like to set up a 'Workspace' directory?")
    if ($Windows.Directories.Workspace.Set) { $Windows.Directories.Workspace.ParentDirectory = ( Set-RootDisk ) }
    
    $Windows.Fonts.NerdFont.Install = (Approve-YesNoQuestion -Question "Would you like to install a Nerd-Font?")
    if ($Windows.Fonts.NerdFont.Install) { $Windows.Fonts.NerdFont.FontName = Set-NerdFont }

    return $Windows
}
