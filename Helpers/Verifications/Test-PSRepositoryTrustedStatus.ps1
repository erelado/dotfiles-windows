function Test-PSRepositoryTrustedStatus {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $PSRepositoryName
    )

    <#
    .SYNOPSIS
    Returns the installation policy status of a given PS repository.

    .PARAMETER PSRepositoryName
    Specifies the PS repository name.

    .OUTPUTS
    System.Boolean. Test-PSRepositoryTrustedStatus returns true if 
    the installation policy status is "Trusted", false otherwise.
    #>
    
    try {
        if (-not (Get-PSRepository -Name $PSRepositoryName -ErrorAction SilentlyContinue)) {
            return $FALSE
        }
        
        if ((Get-PSRepository -Name $PSRepositoryName).InstallationPolicy -eq "Trusted") {
            return $TRUE
        }
        return $FALSE
    }
    catch [Exception] {
        return $FALSE
    }
}
