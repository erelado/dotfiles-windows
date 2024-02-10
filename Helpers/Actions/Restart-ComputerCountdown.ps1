function Restart-ComputerCountdown {
    param (
        [Parameter(Position = 0, Mandatory = $FALSE)]
        [PSDefaultValue(Help = "10")]
        [Int]
        $Seconds = 10
    )

    <#
    .SYNOPSIS
    Restarts the computer after a countdown.

    .DESCRIPTION
    After a countdown (default: 10 seconds) restarts the computer.

    .PARAMETER Seconds
    Specifies the amount of seconds to countdown prior to the restart.

    .OUTPUTS
    None.
    #>
    

    Write-Host "The process has finished." -ForegroundColor "Yellow"

    $Length = $Seconds / 100
    For ($Seconds; $Seconds -gt 0; $Seconds--) {
        $Minutes = [int](([string]($Seconds / 60)).split('.')[0])
        $Text = " " + $Minutes + " minutes " + ($Seconds % 60) + " seconds left"
        Write-Progress -Activity "Restarting the computer in" -Status $Text -PercentComplete ($Seconds / $Length)
        Start-Sleep 1
    }

    Restart-Computer
}
