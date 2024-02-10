function Initialize-WindowsTerminal {

    <#
    .SYNOPSIS
    Asks the user how to set up Windows Terminal.

    .INPUTS
    None. You cannot pipe objects to Initialize-WindowsTerminal.

    .OUTPUTS
    None.
    #>
    
    if (-not (Test-ExecutableExistance -CommandName "wt.exe" `
                -ExecutableName $WinTerminal.Name `
                -CurrentlyInUse ($NULL -ne $env:WT_SESSION))
    ) {
        $WinTerminal.Install = Approve-YesNoQuestion -Question "Would you like to install ${WTerminal.Name}?"

        if ($WinTerminal.Install) {
            if ($WinTerminal.Sources.Length -gt 1) { $WinTerminal.SelectedSource = Select-FromArrayOptions -Array $WinTerminal.Sources.Keys }
            else { $WinTerminal.SelectedSource = ($WinTerminal.Sources.Keys)[0] }
        }
    }

    $WinTerminal.Configurations.SetCustomSettings = (Approve-YesNoQuestion -Question "Would you like to configure Windows Terminal settings?")

    return $WinTerminal
}
