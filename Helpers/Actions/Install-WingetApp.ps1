function Install-WingetApp {
    Param(
        [Parameter(Mandatory = $TRUE)]
        [String]
        $AppName,

        [Parameter(Mandatory = $TRUE)]
        [String]
        $AppId,

        [Parameter(Mandatory = $FALSE)]
        [PSDefaultValue(Help = "winget")]
        [String]
        $Source = "winget",

        [Parameter(Mandatory = $FALSE)]
        [String]
        $Version,

        [Parameter(Mandatory = $FALSE)]
        [String]
        $Parameters
    )

    <#
    .SYNOPSIS
    Installs a application using its Application ID on the 'winget' tool.

    .PARAMETER AppName
    Specifies the name of the application.

    .PARAMETER AppId
    Specifies the ID of the application.

    .PARAMETER Source
    Specifies the source of the application to be installed from (optional).
    Read more at: 
    https://learn.microsoft.com/en-us/windows/package-manager/winget/source

    .PARAMETER Version
    Specifies a specific version to be installed (optional).

    .PARAMETER Parameters
    Specifies any additional parameters not to be included (optional).

    .OUTPUTS
    None.
    #>

    $Command = "winget install --exact --id $AppId --source $Source"

    if ($Version) {
        $Command += " --version $Version"
    }

    if ($Parameters) {
        $Command += " --override $Parameters"
    }

    $Command += " --accept-package-agreements --accept-source-agreements"

    Write-Host "Installing '${AppName}' (Source: '${Source}', ID: '${AppId}'):" -ForegroundColor "Yellow"

    Invoke-Expression $Command

    Write-Host "'${AppName}' has been successfully installed.`n" -ForegroundColor "Green"
}
