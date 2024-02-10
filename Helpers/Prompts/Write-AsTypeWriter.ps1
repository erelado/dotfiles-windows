function Write-AsTypeWriter {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $Content,
        
        [Parameter(Position = 1, Mandatory = $FALSE)]
        [PSDefaultValue(Help = "White")]
        [String]
        $ForegroundColor = "White",

        [Parameter(Position = 2, Mandatory = $FALSE)]
        [PSDefaultValue(Help = 120)]
        [int]
        $Delay = 120
    )

    <#
    .SYNOPSIS
    Displays the content on the screen as it is being typed.

    .PARAMETER Content
    Specifies the text to be written.

    .PARAMETER ForegroundColor
    Specifies the color of the text to be written.

    .OUTPUTS
    None.
    #>

    $Random = New-Object System.Random

    $Content -split '' | `
        ForEach-Object {
        Write-Host $_ -ForegroundColor $ForegroundColor -NoNewline
        Start-Sleep -milliseconds $(1 + $Random.Next($Delay))
    }
    Write-Host
}
