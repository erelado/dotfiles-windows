function Update-EnvironmentVariables {
    
    <#
    .SYNOPSIS
    Reloads all environment variables.

    .INPUTS
    None. You cannot pipe objects to Update-EnvironmentVariables.

    .OUTPUTS
    None.
    #>

    $env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + `
        [System.Environment]::GetEnvironmentVariable("Path", "User")
}
