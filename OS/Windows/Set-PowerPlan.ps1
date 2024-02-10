function Set-PowerPlan {
    
    <#
    .SYNOPSIS
    Updates the AC power plan work continuously.

    .DESCRIPTION
    Timeout number is in minutes; 0 = never.

    .INPUTS
    None. You cannot pipe objects to Set-PowerPlan.

    .OUTPUTS
    None.
    #>

    Write-Host "Configuring power plan:" -ForegroundColor "Yellow"
    
    # Disk timeout
    powercfg -change "disk-timeout-ac" 0
    Write-Host "Disk timeout (AC) = 0"

    # Hibernate timeout
    powercfg -change "hibernate-timeout-ac" 0
    Write-Host "Hibernate timeout (AC) = 0"
    
    # Screen timeout
    powercfg -change "monitor-timeout-ac" 10
    Write-Host "Screen timeout (AC) = 10"
    
    # Sleep timeout
    powercfg -change "standby-timeout-ac" 0
    Write-Host "Sleep timeout (AC) = 0"

    Write-Host "The power plan has been successfully updated.`n" -ForegroundColor "Green"
}
