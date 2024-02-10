function Set-GitConfiguration() {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $UserName,
        
        [Parameter(Position = 1, Mandatory = $TRUE)]
        [String]
        $UserEmail
    )

    <#
    .SYNOPSIS
    Sets the Git information to be configured.

    .DESCRIPTION
    Sets the 'user.name' and 'user.email' globals using the 
    'git config' command.

    .PARAMETER UserName
    Specifies the 'user.name' global.

    .PARAMETER UserEmail
    Specifies the 'user.email' global.

    .OUTPUTS
    None.
    #>

    Write-Host "Configuring Git:" -ForegroundColor "Yellow"

    git config --global color.ui auto
    Write-Host "color.ui = auto"
    
    git config --global core.editor "code --wait"
    Write-Host "core.editor = 'code --wait'"

    git config --global fetch.prune true
    Write-Host "fetch.prune = true"

    git config --global init.defaultBranch "main"
    Write-Host "init.defaultBranch = 'main'"

    git config --global user.email $UserEmail
    Write-Host "user.name = '${UserEmail}'"

    git config --global user.name $UserName
    Write-Host "user.name = '${UserName}'"

    Write-Host "Git has been successfully configured.`n" -ForegroundColor "Green"
}
