function Remove-PowerShellProfileSection {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $ProfileFilePath,

        [Parameter(Position = 1, Mandatory = $TRUE)]
        [String]
        $SectionName
    )

    <#
    .SYNOPSIS
    Removes a requested part of the PowerShell profile file.

    .DESCRIPTION
    Based on a pattern defined for the PowerShell profile file, looks for
    the requested header and removes all lines from it to the next header.

    .PARAMETER ProfileFilePath
    Specifies the path to the PowerShell profile file.

    .PARAMETER SectionName
    Specifies the name of the section header.

    .OUTPUTS
    None.
    #>

    $ProfileContent = Get-Content $ProfileFilePath
    $ProfileLineLength = (Get-Content $ProfileFilePath).Count - 1

    # Finds the required section header
    $Start = 0..$ProfileLineLength | `
        Where-Object { $ProfileContent[$_] -match $SectionName } | `
        Select-Object -First 1
    
    if ($null -ne $Start) {
        # The structure of each section is represented by 3 lines of a comment
        $Stop = 0..$ProfileLineLength | `
            Where-Object { ($ProfileContent[$_] -match "####") -and ($_ -gt $Start + 2) } | `
            Select-Object -First 1
        
        # if the required section header is the last, just copy everything up 
        # to its beginning line
        if ($null -eq $Stop) {
            Get-Content $ProfileFilePath | `
                Where-Object { ($_.ReadCount -lt $Start) } | `
                Set-Content "temp.ps1" 
        }
        else {
            Get-Content $ProfileFilePath | `
                Where-Object { ($_.ReadCount -lt $Start) -or ($_.ReadCount -gt $Stop) } | `
                Set-Content "temp.ps1"
        }

        Move-Item -Force "temp.ps1" $ProfileFilePath
    }
}
