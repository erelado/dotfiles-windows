function Initialize-Espanso {

    <#
    .SYNOPSIS
    Asks the user how to set up Espanso.

    .INPUTS
    None. You cannot pipe objects to Initialize-Espanso.

    .OUTPUTS
    None.
    #>
    
    if (-not (Test-ExecutableExistance -CommandName "espanso")) {
        $Espanso.Install = (Approve-YesNoQuestion -Question "Would you like to install ${Espanso.Name}?")
        
        if ($Espanso.Install) {
            if ($Espanso.Sources.Length -gt 1) { $Espanso.SelectedSource = Select-FromArrayOptions -Array $Espanso.Sources.Keys }
            else { $Espanso.SelectedSource = ($Espanso.Sources.Keys)[0] }
        }
    }

    $Espanso.Configurations.SetConfigs = (Approve-YesNoQuestion -Question "Would you like to include Espanso config file(s)?")

    return $Espanso
}
