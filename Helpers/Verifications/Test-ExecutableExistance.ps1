function Test-ExecutableExistance {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $CommandName,

        [Parameter(Position = 1, Mandatory = $FALSE)]
        [String]
        $ExecutableName,

        [Parameter(Position = 2, Mandatory = $FALSE)]
        [Boolean]
        $CurrentlyInUse
        
    )

    <#
    .SYNOPSIS
    Checks for the presence of a given executable on the local machine's
    `$env:PATH`.

    .DESCRIPTION
    Checks if the provided executable is present on the local machine's
    `$env:PATH`. It is also possible to check whether the specific executable
    is currently in use giving an appropriate boolean condition to check. An
    appropriate message is printed if one of the options is true.

    .PARAMETER CommandName
    Specifies the command of the executable to check.

    .PARAMETER ExecutableName
    Specifies the full executable's name (optional).

    .PARAMETER CurrentlyInUse
    Specifies the boolean condition to check whether the executable is currently
    in use.

    .OUTPUTS
    System.Boolean. Test-ExecutableExistance returns true if one of the options
    is true, false otherwise.
    #>

    $ExecutableName = If ($FALSE -ne $ExecutableName) { $ExecutableName } Else { (Get-Culture).TextInfo.ToTitleCase($CommandName) }

    if ($FALSE -ne $CurrentlyInUse) {
        Write-Host "An installation of '$($ExecutableName)' is not necessary since it is currently in use. This step is skipped.`n" -ForegroundColor "Yellow"
        return $TRUE
    }
    if (Get-Command $CommandName -ErrorAction SilentlyContinue) {
        Write-Host "An installation of '$($ExecutableName)' is not necessary since it is already installed. This step is skipped.`n" -ForegroundColor "Yellow"
        return $TRUE
    }
    return $FALSE
}
