function Set-PrivacySettings {
    
    <#
    .SYNOPSIS
    Updates the advertising and applications permissions.

    .INPUTS
    None. You cannot pipe objects to Set-Privacy.

    .OUTPUTS
    None.
    #>

    Write-Host "Configuring Privacy settings:" -ForegroundColor "Yellow"
    
    # Do not let apps use advertising ID for experiences across apps [Deny: 0, Allow: 1]
    $RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"

    if (-not (Test-Path $RegPath)) { 
        New-Item -Path $RegPath -Type Folder | Out-Null
    }
    Set-ItemProperty -Path $RegPath -Name "Enabled" -Value 0
    Remove-ItemProperty $RegPath "Id" -ErrorAction SilentlyContinue
    Write-Host "Denied from applications to use advertising ID."

    # Store applications access [Allow, Deny]
    $RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore"
    
    # Account Information (name, profile picture, etc.)
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "userAccountInformation") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to account information."

    # Contacts
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "contacts") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to contacts."

    # Calendar
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "appointments") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to calendar."

    # Call History (phone calls)
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "phoneCall") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to phone calls."

    # Call History
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "phoneCallHistory") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to phone calls history."

    # Diagnostics (of other apps)
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "appDiagnostics") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to other applications diagnostics."

    # Documents
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "documentsLibrary") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to documents library."

    # Email (read or send)
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "email") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to emails."

    # Location
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "location") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to location."

    # Messaging (read or send, text or MMS)
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "chat") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to messaging."

    # Pictures
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "picturesLibrary") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to pictures library."

    # Radios (control, like Bluetooth)
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "radios") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to radios (such as Bluetooth)."

    # Tasks
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "userDataTasks") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to user data tasks."

    # Other Devices (share and sync with non-explicitly-paired wireless devices over uPnP)
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "bluetoothSync") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to other devices."

    # Videos
    Set-ItemProperty -Path (Join-Path "${RegPath}" -ChildPath "videosLibrary") -Name "Value" -Value "Deny"
    Write-Host "Denied access from MS Store applications to videos."

    Write-Host "Privacy settings have been successfully updated.`n" -ForegroundColor "Green"                    
}
