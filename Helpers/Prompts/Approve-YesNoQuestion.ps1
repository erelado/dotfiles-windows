
function Approve-YesNoQuestion {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [String]
        $Question,

        [Parameter(Position = 1, Mandatory = $FALSE)]
        [PSDefaultValue(Help = 'y')]
        [String]
        $Default = 'y'
    )

    <#
    .SYNOPSIS
    Prints a yes-no question and waits for the user's response.

    .DESCRIPTION
    Prints a yes-no question and waits for the user's response.
    The question will be repeated as long as the user's response does not match
    one of the possible answers.

    .PARAMETER Question
    Specifies the question to ask the user.

    .PARAMETER Default
    Specifies the default answer to the question ('y'=yes/'n'=no).

    .OUTPUTS
    System.Boolean. Approve-YesNoQuestion returns true if the user answers 
    the question with 'y'/'yes', false otherwise.
    #>

    Write-Host $Question

    if (($Default.ToLower() -match "^(?:y|yes)$")) {
        do {
            Write-Host "[Y] Yes " -Foregroundcolor "Yellow" -NoNewline
            Write-Host "[N] No " -NoNewline
            Write-Host "(default is 'Y'): " -Foregroundcolor "DarkGray" -NoNewline
            
            $YesNoReply = Read-Host
            if (-not ($YesNoReply -match "^(?:y|yes|n|no|)$")) {
                Write-Host "'${YesNoReply}' is not a valid answer.`n" -ForegroundColor "Red"
            }
        }
        while (-not ($YesNoReply -match "^(?:y|yes|n|no|)$"))

        Write-Host ""
        
        if ($YesNoReply -match "^(?:n|no)$") { return $FALSE }
        return $TRUE
    }

    do {
        Write-Host ""
        Write-Host "[Y] Yes " -NoNewline
        Write-Host "[N] No " -Foregroundcolor "Yellow" -NoNewline
        Write-Host "(default is 'N'): " -Foregroundcolor "DarkGray" -NoNewline
        $YesNoReply = Read-Host
    }
    while (-not ($YesNoReply -match "^(?:y|yes|n|no|)$"))

    Write-Host ""

    if ($YesNoReply -match "^(?:y|yes)$") { return $TRUE }
    return $FALSE
}
