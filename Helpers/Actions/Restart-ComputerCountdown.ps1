function Restart-ComputerCountdown {
    param (
        [Parameter(Position = 0, Mandatory = $FALSE)]
        [PSDefaultValue(Help = "30")]
        [Int]
        $Seconds = 30
    )

    <#
    .SYNOPSIS
    Restarts the computer after a countdown.

    .DESCRIPTION
    After a countdown (default: 30 seconds) restarts the computer.

    .PARAMETER Seconds
    Specifies the amount of seconds to countdown prior to the restart.

    .OUTPUTS
    None.
    #>
    

    Write-Host "The process has finished." -ForegroundColor "Yellow"
    Write-Host ""
    Write-Host "The configuration of the machine is almost complete."
    Write-Host "Restarting the machine in 30 seconds will ensure that the new settings take effect."
    Write-Host ""
    Write-Host "You can cancel it by pressing Ctrl+C."

    Stop-Transcript

    $Length = $Seconds / 100
    For ($Seconds; $Seconds -gt 0; $Seconds--) {
        $Minutes = [int](([string]($Seconds / 60)).split('.')[0])
        $Text = " " + $Minutes + " minutes " + ($Seconds % 60) + " seconds left"
        Write-Progress -Activity "Restarting the computer in" -Status $Text -PercentComplete ($Seconds / $Length)
        Start-Sleep 1
    }

    Restart-Computer
}
