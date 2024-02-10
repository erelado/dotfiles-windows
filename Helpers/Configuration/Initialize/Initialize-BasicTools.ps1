function Initialize-BasicTools {

    <#
    .SYNOPSIS
    Asks the user how to set up Basic Tools.

    .INPUTS
    None. You cannot pipe objects to Initialize-BasicTools.

    .OUTPUTS
    None.
    #>

    $Reply = Approve-YesNoQuestion -Question "Would you like to choose basic tools to install?"
    if (-not $Reply) {
        return $BasicTools
    }
    
    $BasicTools | Foreach-Object {
        $_.Install = (Approve-YesNoQuestion -Question "Would you like to install $($_.Name)?")

        if ($_.Install) {
            if ($_.Sources.Keys.Count -gt 1) { $_.SelectedSource = (Select-FromArrayOptions -Array $_.Sources.Keys) }
            else { $_.SelectedSource = ($_.Sources.Keys)[0] }
        }
    }

    return $BasicTools
}
