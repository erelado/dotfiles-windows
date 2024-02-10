function Write-ProcessingAnimation {
    param (
        [Parameter(Position = 0, Mandatory = $TRUE)]
        [ScriptBlock]
        $ScriptBlock
    )

    <#
    .SYNOPSIS
    Prints to the screen a loading animation of the cursor.

    .PARAMETER ScriptBlock
    Specifies the ScriptBlock to be executed while the animation is running.

    .INPUTS
    None. You cannot pipe objects to Write-ProcessingAnimation.

    .OUTPUTS
    None.
    #>

    $cursorTop = [Console]::CursorTop
    
    try {
        [Console]::CursorVisible = $FALSE
        
        $Counter = 0
        $Frames = '|', '/', '-', '\' 
        $JobName = Start-Job -ScriptBlock $ScriptBlock
    
        while ($JobName.JobStateInfo.State -eq "Running") {
            $frame = $Frames[$Counter % $Frames.Length]
            
            Write-Host "$frame" -NoNewLine
            [Console]::SetCursorPosition(0, $cursorTop)
            
            $Counter += 1
            Start-Sleep -Milliseconds 125
        }
        
        # # Only needed if you use a multiline Frames
        # Write-Host ($Frames[0] -replace '[^\s+]', ' ')
    }
    finally {
        [Console]::SetCursorPosition(0, $cursorTop)
        [Console]::CursorVisible = $TRUE
    }
}
