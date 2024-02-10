function Initialize-VSCode {

    <#
    .SYNOPSIS
    Asks the user how to set up Visual Studio Code.

    .INPUTS
    None. You cannot pipe objects to Initialize-VSCode.

    .OUTPUTS
    None.
    #>
    
    if (-not (Test-ExecutableExistance -CommandName "code" `
                -ExecutableName $VSCode.Name `
                -CurrentlyInUse ($env:TERM_PROGRAM -eq "vscode"))
    ) {
        $VSCode.Install = (Approve-YesNoQuestion -Question "Would you like to install ${VSCode.Name}?")
        
        if ($VSCode.Install) {
            if ($VSCode.Sources.Length -gt 1) { $VSCode.SelectedSource = Select-FromArrayOptions -Array $VSCode.Sources.Keys }
            else { $VSCode.SelectedSource = ($VSCode.Sources.Keys)[0] }
        }
    }

    $VSCode.Configurations.InstallExtensions = (Approve-YesNoQuestion -Question "Would you like to install Visual Studio Code extensions?")
    $VSCode.Configurations.SetCustomSettings = (Approve-YesNoQuestion -Question "Would you like to configure Visual Studio Code settings?")

    return $VSCode
}
