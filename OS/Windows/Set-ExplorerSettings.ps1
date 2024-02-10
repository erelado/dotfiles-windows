function Set-ExplorerSettings {
    
    <#
    .SYNOPSIS
    Updates the File Explorer settings.
    
    .DESCRIPTION
    Turns off Windows Narrator hotkey, shows file extensions and hidden files.

    .INPUTS
    None. You cannot pipe objects to Set-ExplorerSettings.

    .OUTPUTS
    None.
    #>

    Write-Host "Configuring Explorer settings:" -ForegroundColor "Yellow"

    # Turn off Windows Narrator hotkey [Disable: 0, Enable: 1]
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Narrator\NoRoam" `
        -Name "WinEnterLaunchEnabled" -Value 0
    Write-Host "Disabled Windows Narrator hotkey."

    # Show file extensions [Show: 0, Hide: 1]
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
        -Name "HideFileExt" -Value 0
    Write-Host "Enabled file extensions."

    # Show hidden files [Show: 1, Hide: 2]
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
        -Name "Hidden" -Value 1
    Write-Host "Enabled hidden files."

    Write-Host "Explorer settings have been successfully updated.`n" -ForegroundColor "Green"
}
