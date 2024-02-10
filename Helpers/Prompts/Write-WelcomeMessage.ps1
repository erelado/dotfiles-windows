function Write-WelcomeMessage {
    param (
        [Parameter(Position = 0, Mandatory = $FALSE)]
        [PSDefaultValue(Help = "Welcome to .dotfiles for Microsoft Windows OS")]
        [String]
        $Message = "Welcome to .dotfiles for Microsoft Windows OS"
    )

    <#
    .SYNOPSIS
    Displays a welcome message to the user.

    .INPUTS
    None. You cannot pipe objects to Write-WelcomeMessage.

    .OUTPUTS
    None.
    #>

    Clear-Host
    Write-Host "                          _       _    __ _ _" -ForegroundColor "Yellow"
    Write-Host "        _.-;;-._         | |     | |  / _(_) |" -ForegroundColor "Yellow"
    Write-Host " '-..-'|   ||   |      __| | ___ | |_| |_ _| | ___  ___" -ForegroundColor "Yellow"
    Write-Host " '-..-'|_.-;;-._|     / _  |/ _ \| __|  _| | |/ _ \/ __|" -ForegroundColor "Yellow"
    Write-Host " '-..-'|   ||   |    | (_| | (_) | |_| | | | |  __/\__ \" -ForegroundColor "Yellow"
    Write-Host " '-..-'|_.-''-._| (_) \____|\___/ \__|_| |_|_|\___||___/" -ForegroundColor "Yellow"
    Write-Host $("*" * 72) -ForegroundColor "Yellow"
    Write-Host (Split-Lines $Message -WrapAt 72) -ForegroundColor "Yellow"
    Write-Host $("*" * 72) -ForegroundColor "Yellow"
}
