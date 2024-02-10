function Set-RegionalFormat {
    
    <#
    .SYNOPSIS
    Updates the regional formats to match personal preferences.

    .INPUTS
    None. You cannot pipe objects to Set-RegionalFormat.

    .OUTPUTS
    None.
    #>

    Write-Host "Configuring Regional formatting:" -ForegroundColor "Yellow"

    $RegPath = "HKCU:\Control Panel\International" 
    
    Set-ItemProperty -Path $RegPath -Name "iFirstDayOfWeek" -Value "6"
    Write-Host "iFirstDayOfWeek = Sunday"

    Set-ItemProperty -Path $RegPath -Name "sShortDate" -Value "dd/MM/yyyy"
    Write-Host "sShortDate = 'dd/MM/yyyy'"

    Set-ItemProperty -Path $RegPath -Name "sLongDate" -Value "dddd, d MMMM, yyyy"
    Write-Host "sLongDate = 'dddd, d MMMM, yyyy'"

    Set-ItemProperty -Path $RegPath -Name "sShortTime" -Value "HH:mm"
    Write-Host "sShortTime = 'HH:mm'"

    Set-ItemProperty -Path $RegPath -Name "sTimeFormat" -Value "HH:mm:ss"
    Write-Host "sTimeFormat = 'HH:mm:ss'"

    Write-Host "Regional formatting has been successfully updated.`n" -ForegroundColor "Green"
}
