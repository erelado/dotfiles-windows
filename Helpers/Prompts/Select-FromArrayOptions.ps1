function Select-FromArrayOptions {    
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [Array]
        $Array
    )

    <#
    .SYNOPSIS
    Displays numbered options from a given array, and requires the user
    to select one.

    .DESCRIPTION
    Displays numbered options from a given array, and requires the user
    to select one. The question will be repeated as long as the user's response
    does not match one of the possible answers.

    .PARAMETER Array
    Specifies the array with all the different options.

    .OUTPUTS
    Any. Select-FromArrayOptions returns one of the options.
    #>

    # Force $Array to always be an array, even if only 1 thing in it, to remove if/then test.
    $Array = [Array]$Array

    do {
        for ($i = 0; $i -lt $Array.Count; $i++) {
            Write-Host "  $(($i+1).ToString().PadLeft($Array.Count.ToString().Length, ' '))" -ForegroundColor "Yellow" -NoNewLine
            Write-Host ". $($Array[$i])"
        }

        $NummericReply = (Read-Host 'Please enter one of the available options (nummeric)')
        if ((-not ($NummericReply -match "^\d+$")) -or (-not (($NummericReply -as [int]) -In 1..$Array.Count))) {
            Write-Host "'${NummericReply}' is not a valid answer.`n" -ForegroundColor "Red"
        }

    } while ((-not ($NummericReply -match "^\d+$")) -or (-not (($NummericReply -as [int]) -In 1..$Array.Count)))

    Write-Host ""

    return $Array[($NummericReply -as [int]) - 1]
}
