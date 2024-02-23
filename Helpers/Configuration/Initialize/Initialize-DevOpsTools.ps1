function Initialize-DevOpsTools {

    <#
    .SYNOPSIS
    Asks the user how to set up DevOps Tools.

    .INPUTS
    None. You cannot pipe objects to Initialize-DevOpsTools.

    .OUTPUTS
    None.
    #>

    $Reply = Approve-YesNoQuestion -Question "Would you like to choose DevOps tools to install?"
    if (-not $Reply) {
        return $DevOpsTools
    }
    
    $DevOpsTools | Foreach-Object {
        $_.Install = (Approve-YesNoQuestion -Question "Would you like to install $($_.Name)?")

        if ($_.Install) {
            if ($_.Sources.Keys.Count -gt 1) { $_.SelectedSource = (Select-FromArrayOptions -Array $_.Sources.Keys) } # let the user choose
            else { $_.SelectedSource = ($_.Sources.Keys)[0] } # select the only source available
        }
    }

    return $DevOpsTools
}
