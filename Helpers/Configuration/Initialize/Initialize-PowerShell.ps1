function Initialize-PowerShell {

    <#
    .SYNOPSIS
    Asks the user how to set up PowerShell.

    .INPUTS
    None. You cannot pipe objects to Initialize-PowerShell.

    .OUTPUTS
    None.
    #>

    if (-not (Test-ExecutableExistance -CommandName "pwsh.exe" `
                -ExecutableName "PowerShell Core" `
                -CurrentlyInUse ($PSVersionTable.PSEdition -eq "core"))
    ) {
        $PowerShell.Install = Approve-YesNoQuestion -Question "Would you like to install ${PowerShell.Name}?"

        if ($PowerShell.Install) {
            if ($PowerShell.Sources.Length -gt 1) { $PowerShell.SelectedSource = Select-FromArrayOptions -Array $PowerShell.Sources.Keys }
            else { $PowerShell.SelectedSource = ($PowerShell.Sources.Keys)[0] }
        }
    }

    $PowerShell.Configurations.Profile.Set = (Approve-YesNoQuestion -Question "Would you like to set the PowerShell profile?")
    if ($PowerShell.Configurations.Profile.Set) {
        $PowerShell.Configurations.Profile.RemoveNonInstalledSections = `
        (Approve-YesNoQuestion -Question "Would you like to remove selected sections not to be installed from the PowerShell profile?")
    }

    $InstallPowerShellModules = (Approve-YesNoQuestion -Question "Would you like to select PowerShell modules to install?")
    if ($InstallPowerShellModules) {
        $PowerShell.Configurations.Modules | Foreach-Object {
            $_.Install = (Approve-YesNoQuestion -Question "Would you like to install '$($_.Name)' module?")
        }
    }

    # OhMyPosh
    $OhMyPosh = $PowerShell.Configurations.OhMyPosh
    $OhMyPosh.Install = (Approve-YesNoQuestion -Question "Would you like to install $($OhMyPosh.Name)?")

    if ($OhMyPosh.Install) {
        if ($OhMyPosh.Sources.Keys.Count -gt 1) { $_.SelectedSource = (Select-FromArrayOptions -Array $OhMyPosh.Sources.Keys) }
        else { $OhMyPosh.SelectedSource = ($OhMyPosh.Sources.Keys)[0] }
    }

    return $PowerShell
}
