function Initialize-OtherApps {

    <#
    .SYNOPSIS
    Asks the user how to set up additional applications.

    .INPUTS
    None. You cannot pipe objects to Initialize-OtherApps.

    .OUTPUTS
    None.
    #>

    $Applications | Foreach-Object {
        $App = $_
        $App.Install = (Approve-YesNoQuestion -Question "Would you like to install $($App.Name)?")

        if ($App.Install) {
            if ($App.Sources.Keys.Count -gt 1) { $App.SelectedSource = (Select-FromArrayOptions -Array $App.Sources.Keys) } # let the user choose
            else { $App.SelectedSource = ($App.Sources.Keys)[0] } # select the only source available

            switch ($App.Name.ToLower()) {
                "espanso" {
                    $App.Configurations.SetConfigs = (Approve-YesNoQuestion -Question "Would you like to include Espanso config file(s)?")

                    break
                }
                "git" {
                    $Reply = (Approve-YesNoQuestion -Question "Would you like to configure Git settings (User.Name, User.Email)?")
                    if ($Reply) {
                        $App.Configurations.Globals.User_Name = (Read-Host "Please enter your Git 'user.name'")
                        $App.Configurations.Globals.User_Email = (Read-Host "Please enter your Git 'user.email'")
                        Write-Host ""
                    }

                    break
                }
                "visual studio code" {
                    $App.Configurations.InstallExtensions = (Approve-YesNoQuestion -Question "Would you like to install Visual Studio Code extensions?")
                    $App.Configurations.SetCustomSettings = (Approve-YesNoQuestion -Question "Would you like to configure Visual Studio Code settings?")

                    break
                }
                "windows terminal" {
                    $App.Configurations.SetCustomSettings = (Approve-YesNoQuestion -Question "Would you like to configure Windows Terminal settings?")

                    break
                }
            }
        }


    }

    return $Applications
}
