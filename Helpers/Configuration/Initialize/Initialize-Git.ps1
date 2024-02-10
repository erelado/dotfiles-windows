function Initialize-Git {

    <#
    .SYNOPSIS
    Asks the user how to set up Git.

    .INPUTS
    None. You cannot pipe objects to Initialize-Git.

    .OUTPUTS
    None.
    #>

    if (-not (Test-ExecutableExistance -CommandName "git.exe" -ExecutableName $Git.Name)) {
        $Git.Install = (Approve-YesNoQuestion -Question "Would you like to install ${Git.Name}?")
        
        if ($_.Install) {
            if ($_.Sources.Keys.Count -gt 1) { $_.SelectedSource = (Select-FromArrayOptions -Array $_.Sources.Keys) }
            else { $_.SelectedSource = ($_.Sources.Keys)[0] }
        }
    }

    $Reply = (Approve-YesNoQuestion -Question "Would you like to configure Git settings (User.Name, User.Email)?")
    if ($Reply) {
        $Git.Configurations.Globals.User_Name = (Read-Host "Please enter your Git 'user.name'")
        $Git.Configurations.Globals.User_Email = (Read-Host "Please enter your Git 'user.email'")
    }

    return $Git
}
