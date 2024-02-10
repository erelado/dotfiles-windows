function Split-Lines {
    [CmdletBinding()]
    param(
        [parameter(Position = 0, Mandatory = 1, ValueFromPipeline = 1,
            ValueFromPipelineByPropertyName = 1)]
        [Object[]]
        $Text,

        [Parameter(Position = 1, Mandatory = $FALSE)]
        [PSDefaultValue(Help = "80")]
        [String]
        $WrapAt = 80
    )

    <#
    .SYNOPSIS
    Wraps a string or an array of strings at the console width without
    breaking within a word.

    .PARAMETER Text
    Specifies the string or an array of strings to split.

    .PARAMETER WrapAt
    Specifies the length to split after.

    .OUTPUTS
    System.String. Split-Lines returns the original string splitted every 

    .EXAMPLE
    Split-Lines -Text $String

    .EXAMPLE
    Split-Lines -Text $String -WrapAt 79

    .EXAMPLE
    $String | Split-Lines
    #>
    #>
    
    PROCESS {
        $Lines = @()
        foreach ($Line in $Text) {
            $Content = ''
            $Counter = 0
            $Line -split '\s+' | ForEach-Object {
                $Counter += $_.Length + 1
                if ($Counter -gt $WrapAt) {
                    $Lines += , $Content.trim()
                    $Content = ''
                    $Counter = $_.Length + 1
                }
                $Content = "${Content}$_ "
            }
            $Lines += , $Content.Trim()
        }
        $Lines
    }
}
